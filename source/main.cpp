#include <nds.h>
#include <stdio.h>
#include <fat.h>
#include <vector>
#include <string>

u8 workbuffer[1024] ALIGN(32);

#define SCREEN_COLS 32
#define ITEMS_PER_SCREEN 10
#define ITEMS_START_ROW 8

using namespace std;

struct patchEntry {
	string description;
	u32 fileoffset;
};

//---------------------------------------------------------------------------------
void halt() {
//---------------------------------------------------------------------------------
	int pressed;

	iprintf("Press A to exit\n");

	while(1) {
		swiWaitForVBlank();
		scanKeys();
		pressed = keysDown();
		if (pressed & KEY_A) break;
	}
	exit(0);
}

//---------------------------------------------------------------------------------
void userSettingsCRC(void *buffer) {
//---------------------------------------------------------------------------------
	u16 *slot = (u16*)buffer;
	u16 CRC1 = swiCRC16(0xFFFF, slot, 0x70);
	u16 CRC2 = swiCRC16(0xFFFF, &slot[0x3a], 0x8A);
	slot[0x39] = CRC1; slot[0x7f] = CRC2;
}


//---------------------------------------------------------------------------------
void saveFile(char *name, void *buffer, int size) {
//---------------------------------------------------------------------------------
	FILE *out = fopen(name,"wb");
	if (out) {
		fwrite(buffer, 1, 1024, out);
		fclose(out);
	} else {
		printf("couldn't open %s for writing\n",name);
	}
}

//---------------------------------------------------------------------------------
void showPatchList (const vector<patchEntry>& patchList, int startRow) {
//---------------------------------------------------------------------------------

	for (int i = 0; i < ((int)patchList.size() - startRow) && i < ITEMS_PER_SCREEN; i++) {
		const patchEntry* patch = &patchList.at(i + startRow);

		// Set row
		iprintf ("\x1b[%d;6H", i + ITEMS_START_ROW);
		iprintf ("%s", patch->description.c_str());
	}
}

//---------------------------------------------------------------------------------
int main(int argc, char **argv) {
//---------------------------------------------------------------------------------
	consoleDemoInit();

	iprintf("\n\n");
	iprintf("    >> 3DS ROP Installer <<   ");
	iprintf("\n\n\n");

	if(!fatInitDefault()) {
		iprintf("FAT initialisation failed!\n");
		halt();
	}

	FILE *patchfile = fopen("patches","rb");

	if (!patchfile) {
		iprintf("patches file not found! %p\n",patchfile);
		halt();
	}

	int header;

	fread(&header,1,4,patchfile);

	if ( header != 'ROPP') {
		iprintf("Invalid patch file!\n");
		halt();
	}

	int index_offset;
	fread(&index_offset,1,4,patchfile);

	fseek(patchfile,index_offset,SEEK_SET);

	vector<patchEntry> patches;
	patchEntry patch;

	while(1) {
		patch.description.clear();
		int string_offset;

		fread(&string_offset,1,4,patchfile);
		if (feof(patchfile)) break;

		fread(&patch.fileoffset,1,4,patchfile);

		// save file pointer
		int file_ptr = ftell(patchfile);

		fseek(patchfile,string_offset,SEEK_SET);

		char description[21];

		char *desc = fgets(description, 20, patchfile);

		if (desc == NULL ) {
			iprintf("Failed reading description\n");
			halt();
		}

		// terminate string
		description[20] = 0;
		patch.description = description;
		patches.push_back(patch);

		// restore file pointer for next offset
		fseek(patchfile,file_ptr,SEEK_SET);
	}

	iprintf("    Select Firmware version");

	int pressed,fwSelected=0,screenOffset=0;

	showPatchList(patches,fwSelected);

	while(1) {

		// Show cursor
		iprintf ("\x1b[%d;3H[>\x1b[22C<]", fwSelected - screenOffset + ITEMS_START_ROW);

		// Power saving loop. Only poll the keys once per frame and sleep the CPU if there is nothing else to do
		do {
			scanKeys();
			pressed = keysDownRepeat();
			swiWaitForVBlank();
		} while (!pressed);

		// Hide cursor
		iprintf ("\x1b[%d;3H  \x1b[22C  ", fwSelected - screenOffset + ITEMS_START_ROW);
		if (pressed & KEY_UP) 		fwSelected -= 1;
		if (pressed & KEY_DOWN) 	fwSelected += 1;

		if (pressed & KEY_A) break;

		if (fwSelected < 0) 	fwSelected = patches.size() - 1;		// Wrap around to bottom of list
		if (fwSelected > ((int)patches.size() - 1))		fwSelected = 0;		// Wrap around to top of list


	}

	iprintf ("\x1b[5;0H\x1b[J");


	const patchEntry *selectedPatch = &patches.at(fwSelected);


	iprintf("Patching for %s\n\n",selectedPatch->description.c_str());

	// read header
	readFirmware(0,workbuffer,42);

	u32 userSettingsOffset = (workbuffer[32] + (workbuffer[33] << 8))<<3;

	// read User Settings
	readFirmware(userSettingsOffset,workbuffer,512);


	fseek(patchfile,selectedPatch->fileoffset,SEEK_SET);
	fread(&header,1,4,patchfile);

	if (header != 'PTCH' ) {

			printf("Patch set invalid\n");
			halt();

	} else {

		int32_t numPatches;
		uint32_t patchSize,patchOffset;
		fread(&numPatches,1,4,patchfile);

		uint32_t patchOffsetList[numPatches];
		fread(patchOffsetList,1,sizeof(patchOffsetList),patchfile);

		for (int i=0; i<numPatches; i++) {

			fseek(patchfile,patchOffsetList[i],SEEK_SET);
			fread(&patchSize,1,4,patchfile);
			fread(&patchOffset,1,4,patchfile);
			fread(&workbuffer[patchOffset],1,patchSize,patchfile);

		}
	}

	userSettingsCRC(workbuffer);
	userSettingsCRC(workbuffer+256);


	iprintf("Writing ... ");
	int ret = writeFirmware(userSettingsOffset,workbuffer,512);

	if (ret) {

		iprintf("failed\n");

	} else {

		iprintf("success\n");

	}

	iprintf("Verifying ... ");
	readFirmware(userSettingsOffset,workbuffer+512,512);

	if (memcmp(workbuffer,workbuffer+512,512)){

		iprintf("failed\n");

	} else {

		iprintf("success\n");

	}

	halt();
	return 0;
}
