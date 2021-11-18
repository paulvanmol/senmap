%let path=/srv/nfs/kubedata/compute-landingzone/sonatel/senmap;
/* %let path=/home/christine/senmap; */
%let level=ZoneDVRI; 
%let ID=Zone_DVRI;
%let maplib=public;
%let cashost=sas-cas-server-default-client;
/* %let cashost=server.demo.sas.com;  */
%let casport=5570; 
libname mapscstm "&path/sasdata";


cas mysession; 
/*****************************************************************************/
/*  Create a CAS library (mapscstm) for the specified path ("/filePath/")    */ 
/*  and session (mySession).  If "sessref=" is omitted, the caslib is        */ 
/*  created and activated for the current session.  Setting subdirs extends  */
/*  the scope of myCaslib to subdirectories of "/filePath".                  */
/*****************************************************************************/
/*
caslib mapscstm datasource=(srctype="path") 
path="&path/sasdata" sessref=mySession subdirs libref=mapscstm ;
*/

proc casutil ; 
droptable casdata="senmap_&level" incaslib="&maplib" quiet;
droptable casdata="senmap_&level._attr" incaslib="&maplib" quiet;
droptable casdata="senmap_&level" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/ShapefileSNG/&level/Carte_DVRI_region.shp)

%shpimprt(shapefilepath=&path/ShapefileSNG/&level/Carte_DVRI_region.shp,
			ID=&ID,
			outtable=senmap_&level,
			cashost=&cashost,
			casport=&casport,
			caslib='casuser',
			reduce=1)
/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/

cas mysession; 
caslib _all_ assign;

data &maplib..senmap_&level (promote=yes replace=yes 
drop=	Zone_DRV) 
&maplib..senmap_&level._attr (promote=yes replace=yes 
keep=&ID Zone_DRV);
set casuser.senmap_&level ;
 
run; 

cas mysession terminate;
/* Creates a permanent copy of an in-memory table ("sourceTableName") from "sourceCaslib". */
/* The in-memory table is saved to the data source that is associated with the target      */
/* caslib ("targetCaslib") using the specified name ("targetTableName").                   */
/*                                                                                         */
/* To find out the caslib associated with an CAS engine libref, right click on the libref  */
/* from "Libraries" and select "Properties". Then look for the entry named "Server Session */
/* CASLIB".                                                                                */
cas mysession; 
caslib _all_ assign;
proc casutil;
 save casdata="senmap_&level" incaslib="&maplib" outcaslib="&maplib" replace;

quit;
proc copy inlib=public outlib=mapscstm; 
select senmap_&level senmap_&level._attr ; 
quit; 
proc sort data=mapscstm.SENMAP_&level._ATTR 
		out=mapscstm.SENMAP_&level._ATTROK  nodupkey equals;
	by &ID;
run;
proc casutil ; 
droptable casdata="senmap_&level._attr" incaslib="&maplib" quiet; 
load data=mapscstm.senmap_&level._attrok casout="senmap_&level._attr" outcaslib="&maplib" promote; 
quit; 
proc datasets lib=mapscstm; 
delete senmap_&level._attr; 
change senmap_&level._attrok=senmap_&level._attr; 
quit; 
cas mysession terminate;