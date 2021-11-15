%let path=/srv/nfs/kubedata/compute-landingzone/sonatel/senmap;
%let path=/home/christine/senmap;
%let level=arrondissement; 
%let ID=CODE; 
%let maplib=public;
%let cashost=server.demo.sas.com; 
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
droptable casdata="senmap_&level" incaslib='casuser' quiet;
quit; 

cas mysession terminate ; 
 
%shpcntnt(shapefilepath=&path/shapefiles/Limite_&level..shp)

%shpimprt(shapefilepath=&path/shapefiles/Limite_&level..shp,
			ID=CODE,
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

data &maplib..senmap_&level (promote=yes replace=yes);
set casuser.senmap_&level;
length cCode $12;
ccode=cats('SN',code); 
drop 
	  sum_superf  shape_Area shape_leng shape_le_1; 
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
select senmap_&level /*senmap_&level._attr*/; 
quit; 
cas mysession terminate;