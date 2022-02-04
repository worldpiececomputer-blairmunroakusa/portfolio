// Tidbit / txt computer initialization
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

FILE * FILEpointer;

struct getinitdata {			//input
	char filename[100];
	char ext[10];
	int ain;
	int aout;
	int tbcat;					};

struct counts {				//number
	int D;
	int Ai;
	int Ao;
	int Ctb;					};

struct filetext {  			//stringdata
	char fNAME[100];
	char fEXT[10];
	char fDIR[200];
	char fLOC[100];
	char fADDR[300];			};

struct projects {  			//proj[]
	char folder[50];
	char label[50];				};

struct descriptions {  		//unit[]
	char descript[40];
	char abbrev[40];
	char alternative[40];		};

struct sourcedata {  		//source
	char authorfirst[20];
	char authorfirstshort[10];
	char authorlast[20];
	char authorlastshort[10];
	char year[10];
	char yearshort[3];
	char authoryear[20];
	char citekey[20];			};

struct incoming {  			//aliasIN[]
	char tbAddress[100];
	char tbToken[60];		};

struct outgoing {  			//aliasOUT[]
	char tbAddress[100];
	char tbToken[60];		};

int i, cat = 10;

//
void		initTidbit_API(
		void
		);
void		initProjects(
		struct projects *pL
		);
void		inputInitial(
		struct getinitdata *pG,
		struct projects *pL
		);
void		initCounts(
		struct getinitdata *pG,
		struct counts *pC
		);
void		initFiletext(
		struct getinitdata *pG,
		struct projects *pL,
		struct filetext *pF,
		struct counts *pC
		);
void		generateData(
		struct getinitdata *pG,
		struct descriptions *pD,
		struct sourcedata *pS,
		struct counts *pC,
		struct filetext *pF
		);
void		folderFiles(
		struct filetext *pF,
		struct projects *pL,
		struct counts *pC
		);
void		tbRefdataBib(
		struct filetext *pF,
		struct projects *pL,
		struct counts *pC,
		struct descriptions *pD,
		struct sourcedata *pS
		);

//============================================================================
void		initTidbit_API(
		void
		){

struct projects proj[cat];
	initProjects( proj );

struct getinitdata input;
	inputInitial( &input, proj );

struct counts number;
	initCounts( &input, &number );

struct filetext stringdata;
	initFiletext( &input, proj, &stringdata, &number );

struct descriptions unit[number.D];
//struct incoming aliasIN[number.Ai];
//struct outgoing aliasOUT[number.Ao];

struct sourcedata source;
	generateData( &input, unit, &source, &number, &stringdata );

folderFiles( &stringdata, proj, &number );
tbRefdataBib( &stringdata, proj, &number, unit, &source );
}
//============================================================================
void		initProjects(
		struct projects *pL
		){

strcpy( pL[0].label, "floatingTidbits" );
strcpy( pL[0].folder, "__floatingTidbits/" );
strcpy( pL[1].label, "Computer" );
strcpy( pL[1].folder, "_Computer/" );
strcpy( pL[2].label, "computerMatter" );
strcpy( pL[2].folder, "_computerMatter/" );
strcpy( pL[3].label, "computerMusic" );
strcpy( pL[3].folder, "_computerMusic/" );
strcpy( pL[4].label, "computerTMM" );
strcpy( pL[4].folder, "_computerTMM/" );
strcpy( pL[5].label, "computerVision" );
strcpy( pL[5].folder, "_computerVision/" );
strcpy( pL[6].label, "studyMath" );
strcpy( pL[6].folder, "_studyMath/" );
strcpy( pL[7].label, "studyPhysics" );
strcpy( pL[7].folder, "_studyPhysics/" );
strcpy( pL[8].label, "research" );
strcpy( pL[8].folder, "research/" );
strcpy( pL[9].label, "work" );
strcpy( pL[9].folder, "work/" );
}
//============================================================================
void		inputInitial(
		struct getinitdata *pG,
		struct projects *pL
		){

int tempint = 0;
char string[200];

printf( "\n enter file name >>" );
fgets( string, 200, stdin );
sscanf( string, "%s", pG->filename );

printf( "\n enter file extension >>" );
fgets( string, 200, stdin);
	for( i=0; i < strlen(string); i++ ){
	if( string[i] == '\n')
	strcpy( &string[i], "" );
	};
strcpy( pG->ext, "." );
strcat( pG->ext, string );

printf( "\n enter number incoming aliases >>" );
fgets( string, 200, stdin );
sscanf( string, "%d", &tempint );
pG->ain = tempint;

printf( "\n enter number outgoing aliases >>");
fgets( string, 200, stdin);
sscanf( string, "%d", &tempint );
pG->aout = tempint;

printf( "\n choose project (enter number) >>" );
	for( i=0; i < cat; i++ ){
	printf( "\n %d\t%s", i, pL[i].label );
	}
printf( "\n >>" );
fgets( string, 6, stdin );
sscanf( string, "%d", &tempint );
pG->tbcat = tempint;
}
//============================================================================
void		initCounts(
		struct getinitdata *pG,
		struct counts *pC
		){

int tempint = 0;
for( i=0; i < strlen(pG->filename); i++ ){
    if( pG->filename[i] == '_' )
	tempint++;
	}

pC->D = tempint;

pC->Ai = pG->ain;

pC->Ao = pG->aout;

pC->Ctb = pG->tbcat;
}
//============================================================================
void		initFiletext(
		struct getinitdata *pG,
		struct projects *pL,
		struct filetext *pF,
		struct counts *pC
		){

char string[200];
strcpy( pF->fNAME, pG->filename );
strcpy( pF->fEXT, pG->ext );
strcpy( pF->fDIR, "/Users/blairmunro/FILES/__CPU/" );
strcpy( pF->fLOC, pL[pC->Ctb].folder );
strcpy( string, pF->fDIR );
strcat( string, pF->fLOC );
strcat( string, pF->fNAME );
strcat( string, pF->fEXT );
strcpy( pF->fADDR, string );
}
//============================================================================
void		generateData(
		struct getinitdata *pG,
		struct descriptions *pD,
		struct sourcedata *pS,
		struct counts *pC,
		struct filetext *pF
		){

char string[200];
strcpy( string, pF->fNAME );
char *token = strtok( string, "_" );
	i = 0;
	while( token != NULL ){
	strcpy( pD[i].descript, token );
	token = strtok( NULL, "_" );
	i++;
	}

printf( "\n abbreviate descriptions >>" );
	for( i=0; i < pC->D; i++ ){
	printf("\n %s >>", pD[i].descript );
	fgets( string, 200, stdin);
	sscanf( string, "%s", pD[i].abbrev );
	}

printf( "\n enter descriptor alternate terms >>" );
	for( i=0; i < pC->D; i++ ){
	printf("\n %s >>", pD[i].descript );
	fgets( string, 200, stdin);
	sscanf( string, "%s", pD[i].alternative);
	}

printf( "\n enter author firstname >>" );
fgets( string, 200, stdin);
sscanf( string, "%s", pS->authorfirst );

printf( "\n enter author lastname >>" );
fgets( string, 200, stdin);
sscanf( string, "%s", pS->authorlast );

printf( "\n enter year >>" );
fgets( string, 200, stdin);
sscanf( string, "%s", pS->year );
	for( i=0; i<2; i++){
	strcpy( &pS->yearshort[i], &pS->year[i+2] );
	}

printf( "\n abbreviate author firstname >>" );
printf("\n %s >>", pS->authorfirst );
fgets( string, 200, stdin);
sscanf( string, "%s", pS->authorfirstshort );

printf( "\n abbreviate author lastname >>" );
printf("\n %s >>", pS->authorlast );
fgets( string, 200, stdin);
sscanf( string, "%s", pS->authorlastshort );

strcpy( string, pS->authorlastshort);
strcat( string, pS->authorfirstshort);
strcat( string, pS->yearshort);
strcpy( pS->authoryear, string );

printf( "\n generate citekey >>" );
	for( i=0; i < pC->D; i++ ){
	printf( "\n %s %s\t%s", pD[i].descript, pD[i].abbrev, pD[i].alternative );
	}
	printf( "\n %s %s\t\t%s %s\t%s", pS->authorfirst, pS->authorfirstshort, pS->authorlast, pS->authorlastshort, pS->year );
	printf( "\n >>" );
	fgets( string, 200, stdin);
	sscanf( string, "%s", pS->citekey );
}
//============================================================================
void		folderFiles(

		struct filetext *pF,
		struct projects *pL,
		struct counts *pC
		){

char string[200];

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
mkdir( string, 0700 );

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
strcat( string, "/__aliasIN" );
mkdir( string, 0700 );

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
strcat( string, "/aliasOUT" );
mkdir( string, 0700 );

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
strcat( string, "/" );
strcat( string, pF->fNAME );
strcat( string, ".bib" );
FILEpointer = fopen( string, "w" );
	if ( FILEpointer == 0 ){
	printf( "File error occurred" );
	exit(1);
	}
fclose( FILEpointer );

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
strcat( string, "/" );
strcat( string, pF->fNAME );
strcat( string, ".tex" );
FILEpointer = fopen( string, "w" );
	if ( FILEpointer == 0 ){
	printf( "File error occurred" );
	exit(1);
	}
fclose( FILEpointer );

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
strcat( string, "/_clipBits.rtf" );
FILEpointer = fopen( string, "w" );
	if ( FILEpointer == 0 ){
	printf( "File error occurred" );
	exit(1);
	}
fclose( FILEpointer );
}

//============================================================================
void		tbRefdataBib(
		struct filetext *pF,
		struct projects *pL,
		struct counts *pC,
		struct descriptions *pD,
		struct sourcedata *pS
		){

char string[200];

strcpy( string, pF->fDIR );
strcat( string, pL[ pC->Ctb ].folder );
strcat( string, pF->fNAME );
strcat( string, "/___tbRefdata.bib" );
FILEpointer = fopen( string, "w+" );
	if ( FILEpointer == 0 ){
	printf( "File error occurred" );
	exit(1);		}

	fprintf( FILEpointer, "@_master{%s,\n", pS->citekey );
		strcpy( string, pF->fNAME );
		strcat( string, pF->fEXT);
	fprintf( FILEpointer, "\tFilename = {%s},\n", string );
		strcpy( string, pF->fDIR );
		strcat( string, pL[ pC->Ctb ].folder );
		strcat( string, pF->fNAME );
		strcat( string, "/" );
	fprintf( FILEpointer, "\tLocation = {%s},\n", string );
	fprintf( FILEpointer, "\tAuthor = {%s %s},\n", pS->authorfirst, pS->authorlast );
	fprintf( FILEpointer, "\tDate = {%s},}\n", pS->year );

		strcpy( string, pD[0].abbrev );
		for( i=1; i < pC->D; i++ ){
		strcat( string, pD[i].abbrev );   }
		strcat( string, pS->authoryear );
	fprintf( FILEpointer, "@_aliascore{%s,\n", string );
		strcpy( string, pF->fNAME );
		strcat( string, pF->fEXT );
	fprintf( FILEpointer , "\tObject = {%s},\n", string );
		strcpy( string, pF->fDIR );
		strcat( string, "_allHardbits/" );
		strcat( string, pF->fNAME );
		strcat( string, pF->fEXT );
	fprintf( FILEpointer , "\tAddress = {%s},}\n", string );

	fputs( "@_aliasin{AI1,\n", FILEpointer );
	fputs( "\tAddress = {none},\n", FILEpointer );
	fputs( "\tToken = {none},}\n", FILEpointer );

	fputs( "@_file{F1,\n", FILEpointer );
	fprintf( FILEpointer , "\tType = {rtf},\n" );
		strcpy( string, "_clipBits.rtf" );
	fprintf( FILEpointer , "\tName = {%s},\n", string );
		strcpy( string, pF->fDIR );
		strcat( string, pL[ pC->Ctb ].folder );
		strcat( string, pF->fNAME );
		strcat( string, "/" );
	fprintf( FILEpointer , "\tLocation = {%s},}\n", string );

	fputs( "@_file{F2,\n", FILEpointer );
	fprintf( FILEpointer , "\tType = {tex},\n" );
		strcpy( string, pF->fNAME );
		strcat( string, ".tex" );
	fprintf( FILEpointer , "\tName = {%s},\n", string );
		strcpy( string, pF->fDIR );
		strcat( string, pL[ pC->Ctb ].folder );
		strcat( string, pF->fNAME );
		strcat( string, "/" );
	fprintf( FILEpointer , "\tAddress = {%s},}\n", string);

	fputs( "@_file{F3,\n", FILEpointer );
	fprintf( FILEpointer , "\tType = {bib},\n" );
		strcpy( string, pF->fNAME );
		strcat( string, ".bib" );
	fprintf( FILEpointer , "\tName = {%s},\n", string );
		strcpy( string, pF->fDIR );
		strcat( string, pL[ pC->Ctb ].folder );
		strcat( string, pF->fNAME );
		strcat( string, "/" );
	fprintf( FILEpointer , "\tAddress = {%s},}\n", string );

	for( i=0; i < pC->D; i++ ){
	fprintf( FILEpointer, "@_descript{D%d,\n", i+1 );
	fprintf( FILEpointer, "\tLong = {%s},\n", pD[i].descript );
	fprintf( FILEpointer, "\tShort = {%s},\n", pD[i].abbrev );
	fprintf( FILEpointer, "\tExtra = {%s},}\n", pD[i].alternative );   }

fclose( FILEpointer );
}
//============================================================================
int		main(
		void
		){

initTidbit_API();
return 0;
}
