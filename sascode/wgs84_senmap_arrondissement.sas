%let path=/srv/nfs/kubedata/compute-landingzone/sonatel/senmap;
%let level=arrondissement; 
%let cashost=sas-cas-server-default-client; 
%let casport=5570; 


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
droptable casdata="senmap_&level" incaslib='public' quiet;
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

data public.senmap_&level (promote=yes replace=yes);
set casuser.senmap_&level (rename=(code=numcode));
length Code $12;
code=cats('SN',numcode); 
drop 
	  sum_superf  shape_Area shape_leng shape_le_1; 
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