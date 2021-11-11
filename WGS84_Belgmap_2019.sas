%let path=/workshop/belgmap;
/*%let shapeversion=AdminVector_2015_WGS84_shp;*/
%let shapeversion=AdminVector_2019_WGS84_shp; 
%let version=%scan(&shapeversion,2,_);
%put &version;

cas mysession; 

proc casutil ; 
droptable casdata="StatisticSector&version" incaslib='mapscstm' quiet;
droptable casdata="StatisticSector&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/AD_0_StatisticSector.shp)

%include "/opt/sas/spre/home/SASFoundation/sasautos/shprduce.sas";
%include "/opt/sas/spre/home/SASFoundation/sasautos/shpimprt.sas";
%shpimprt(shapefilepath=&path/&shapeversion/AD_0_StatisticSector.shp,
			ID=NISCODE,
			outtable=StatisticSector&version,
			cashost=server,
			casport=5570,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data mapscstm.StatisticSector&version (promote=yes replace=yes);
length niscode $ 9; 
set casuser.StatisticSector&version;
IDNAME=NISCODE;
 
drop 
	  modifdate  shape_Area shape_leng ; 
run; 
/*
     Input filename: /workshop/belgmap/AdminVector_2015_WGS84_shp/AD_0_StatisticSector.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 XYORIGIN     NUM      9     0
   2 MODIFDATE    NUM      8     0
   3 NISCODE      CHAR   254     0
   4 Shape_Leng   NUM     19    11
   5 Shape_Area   NUM     19    11
*/
cas mysession terminate;
cas mysession; 

proc casutil ; 
droptable casdata="municipalsection&version" incaslib='mapscstm' quiet;
droptable casdata="municipalsection&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/AD_1_MunicipalSection.shp)

%include "/opt/sas/spre/home/SASFoundation/sasautos/shprduce.sas";

%shpimprt(shapefilepath=&path/&shapeversion/AD_1_MunicipalSection.shp,
			ID=PSEUDONIS,
			outtable=municipalsection&version,
			cashost=server,
			casport=5570,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data mapscstm.municipalsection&version (promote=yes replace=yes);
length niscode $ 9; 
set casuser.municipalsection&version (rename=(pseudonis=niscode));
IDNAME=NISCODE;
drop
	  modifdate  shape_Area shape_leng; 
run; 
/*
         Contents of the Input file
   Input filename: /workshop/belgmap/AdminVector_2019_WGS84_shp/AD_1_MunicipalSection.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 PseudoNIS    CHAR   254     0
   2 ModifDate    NUM      8     0
   3 Shape_Leng   NUM     19    11
   4 Shape_Area   NUM     19    11
Number of Fields:      4
Number of Records:     2664
*/
cas mysession terminate;



/*****************************************************************************/
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale     */
/*  defaults.                                                                */
/*****************************************************************************/

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");

/*****************************************************************************/
/*  Create a CAS library (myCaslib) for the specified path ("/filePath/")    */ 
/*  and session (mySession).  If "sessref=" is omitted, the caslib is        */ 
/*  created and activated for the current session.  Setting subdirs extends  */
/*  the scope of myCaslib to subdirectories of "/filePath".                  */
/*****************************************************************************/

*caslib mapscstm datasource=(srctype="path") path="&path/sasdata" sessref=mySession subdirs;

proc casutil ; 
droptable casdata="municipality&version" incaslib='mapscstm' quiet;
droptable casdata="municipality&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/AD_2_Municipality.shp)

%include "/opt/sas/spre/home/SASFoundation/sasautos/shprduce.sas";

%shpimprt(shapefilepath=&path/&shapeversion/AD_2_Municipality.shp,
			ID=NISCODE,
			outtable=municipality&version,
			cashost=server,
			casport=5570,
			caslib='casuser',
			reduce=1)

cas mysession; 
caslib _all_ assign;

data mapscstm.municipality&version (promote=yes replace=yes) ;
length niscode $ 9; 
set casuser.municipality&version;
if languagest=1 then IDNAME=NAMEDUT; 
else if languagest=2 then IDNAME=NAMEFRE;
else if languagest=4 then IDNAME=catx('-',NAMEFRE,NAMEDUT);
else if languagest=5 then IDNAME=catx('-',NAMEFRE,NAMEDUT);
else if languagest=6 then IDNAME=catx('-',NAMEFRE,NAMEDUT);
else if languagest=7 then IDNAME=catx('-',NAMEFRE,NAMEGER);
else if languagest=8 then IDNAME=catx('-',NAMEFRE,NAMEGER);
drop nameger namedut namefre
	regioncapi provinceca languagest modifdate districtca countrycap city shape_Area shape_leng ; 
run; 
/*   Input filename: /workshop/belgmap/AdminVector_2019_WGS84_shp/AD_2_Municipality.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 ModifDate    NUM      8     0
   2 City         NUM      9     0
   3 LanguageSt   NUM      9     0
   4 NISCode      CHAR   254     0
   5 DistrictCa   NUM      9     0
   6 ProvinceCa   NUM      9     0
   7 RegionCapi   NUM      9     0
   8 CountryCap   NUM      9     0
   9 NameGer      CHAR    50     0
  10 NameFre      CHAR    50     0
  11 NameDut      CHAR    50     0
  12 Shape_Leng   NUM     19    11
  13 Shape_Area   NUM     19    11*/
cas mysession terminate;


cas mysession; 

proc casutil ; 
droptable casdata="district&version" incaslib='mapscstm' quiet;
droptable casdata="district&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/AD_3_District.shp)

%include "/opt/sas/spre/home/SASFoundation/sasautos/shprduce.sas";

%shpimprt(shapefilepath=&path/&shapeversion/AD_3_District.shp,
			ID=NISCODE,
			outtable=district&version,
			cashost=server,
			casport=5570,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data mapscstm.district&version (promote=yes replace=yes);
length niscode $ 9; 
set casuser.district&version;
IF substr(left(niscode),1,1) in ('7','4','3','1') THEN DO;
  	IF namedut ne ' ' THEN IDNAME=namedut; 
  END; 
  ELSE IF substr(left(niscode),1,1) in ('9','8','6','5') THEN DO; 
  	IF namefre ne ' ' THEN IDNAME=namefre;
  	ELSE IF nameger ne ' ' THEN IDNAME=nameger;
  END;
  ELSE IF substr(left(niscode),1,1) = '2' THEN DO;
    code = substr(left(niscode),1,2);
  	IF code in ('24', '23') THEN IDNAME = namedut;
	ELSE IF code = '25' THEN IDNAME = namefre;
	ELSE IF code = '21' THEN IDNAME = catx(' / ',namefre,namedut);
  END;
drop nameger namedut namefre
	  modifdate  shape_Area shape_leng code ; 
run; 

cas mysession terminate;
/*   Input filename: /workshop/belgmap/AdminVector_2019_WGS84_shp/AD_3_District.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 ModifDate    NUM      8     0
   2 NISCode      CHAR   254     0
   3 NameDut      CHAR    50     0
   4 NameGer      CHAR    50     0
   5 NameFre      CHAR    50     0
   6 Shape_Leng   NUM     19    11
   7 Shape_Area   NUM     19    11
*/

cas mysession; 
caslib _all_ assign;
proc casutil ; 
droptable casdata="province&version" incaslib='mapscstm' quiet;
droptable casdata="province&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/AD_4_Province.shp)

%include "/opt/sas/spre/home/SASFoundation/sasautos/shprduce.sas";

%shpimprt(shapefilepath=&path/&shapeversion/AD_4_Province.shp,
			ID=NISCODE,
			outtable=province&version,
			cashost=server,
			casport=5570,
			caslib='casuser',
			reduce=1)

cas mysession; 
caslib _all_ assign;

data mapscstm.province&version (replace=yes promote=yes) ;
length niscode $ 9; 
set casuser.province&version;
IF substr(left(niscode),1,1) in ('7','4','3','1') THEN DO;
  	IF namedut ne ' ' THEN IDNAME=namedut; 
  END; 
  ELSE IF substr(left(niscode),1,1) in ('9','8','6','5') THEN DO; 
  	IF namefre ne ' ' THEN IDNAME=namefre;
  	ELSE IF nameger ne ' ' THEN IDNAME=nameger;
  END;
  ELSE IF substr(left(niscode),1,1) = '2' THEN DO;
    IF substr(left(niscode),1,2) in ('24', '23') THEN IDNAME = namedut;
	ELSE IF substr(left(niscode),1,2) = '25' THEN IDNAME = namefre;
	ELSE IF substr(left(niscode),1,2) = '21' THEN IDNAME = catx(' / ',namefre,namedut);
  END;
drop nameger namedut namefre
	modifdate Fictitious shape_Area shape_leng ; 
run; 
/*   Input filename: /workshop/belgmap/AdminVector_2019_WGS84_shp/AD_4_Province.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 ModifDate    NUM      8     0
   2 NISCode      CHAR   254     0
   3 Fictitious   NUM      9     0
   4 NameDut      CHAR    50     0
   5 NameFre      CHAR    50     0
   6 NameGer      CHAR    50     0
   7 Shape_Leng   NUM     19    11
   8 Shape_Area   NUM     19    11
*/
cas mysession terminate;

cas mysession; 
caslib _all_ assign;
proc casutil ; 
droptable casdata="region&version" incaslib='mapscstm' quiet;
droptable casdata="region&version" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/&shapeversion/AD_5_Region.shp)

%include "/opt/sas/spre/home/SASFoundation/sasautos/shprduce.sas";

%shpimprt(shapefilepath=&path/&shapeversion/AD_5_Region.shp,
			ID=NISCODE,
			outtable=region&version,
			cashost=server,
			casport=5570,
			caslib='casuser',
			reduce=1)

cas mysession; 
caslib _all_ assign;

data mapscstm.region&version (replace=yes promote=yes) ;
length niscode $ 9; 
set casuser.region&version;
IF substr(left(niscode),1,2) in ('02') THEN DO;
  	IF namedut ne ' ' THEN IDNAME=namedut; 
  END; 
  ELSE IF substr(left(niscode),1,3) in ('03') THEN DO; 
  	IF namefre ne ' ' THEN IDNAME=namefre;
  END;
  ELSE IF substr(left(niscode),1,2) = '01' THEN DO;
     NISCODE='04000';
     IDNAME = catx(' / ',namefre,namedut);
  END;
drop nameger namedut namefre
	modifdate shape_Area shape_leng ; 
run; 
/*   Input filename: /workshop/belgmap/AdminVector_2019_WGS84_shp/AD_5_Region.shp
   List of Fields and Attributes
   # Field        Type Width Decimals
   1 ModifDate    NUM      8     0
   2 NISCode      CHAR   254     0
   3 NameDut      CHAR    50     0
   4 NameFre      CHAR    50     0
   5 NameGer      CHAR    50     0
   6 Shape_Leng   NUM     19    11
   7 Shape_Area   NUM     19    11
Number of Fields:      7
Number of Records:     3
*/
cas mysession terminate;

/* Creates a permanent copy of an in-memory table ("sourceTableName") from "sourceCaslib". */
/* The in-memory table is saved to the data source that is associated with the target      */
/* caslib ("targetCaslib") using the specified name ("targetTableName").                   */
/*                                                                                         */
/* To find out the caslib associated with an CAS engine libref, right click on the libref  */
/* from "Libraries" and select "Properties". Then look for the entry named "Server Session */
/* CASLIB".                                                                                */
cas mysession; 

proc casutil;
 save casdata="statisticsector&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="municipalsection&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="municipality&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="district&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="province&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
 save casdata="region&version" incaslib="MAPSCSTM" outcaslib="MAPSCSTM" replace;
quit;
cas mysession terminate;