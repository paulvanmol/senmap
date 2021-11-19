%let cashost=sas-cas-server-default-client; 
%let casport=5570; 
/*****************************************************************************/
/*  Set the options necessary for creating a connection to a CAS server.     */
/*  Once the options are set, the cas command connects the default session   */ 
/*  to the specified CAS server and CAS port, for example the default value  */
/*  is 5570.                                                                 */
/*****************************************************************************/

options cashost="&cashost" casport=&casport;

/*****************************************************************************/
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale     */
/*  defaults.                                                                */
/*****************************************************************************/

cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");


/*****************************************************************************/
/*  Load a table ("sourceTableName") from the specified caslib               */
/*  ("sourceCaslib") to the target Caslib ("targetCaslib") and save it as    */
/*  "targetTableName".                                                       */
/*****************************************************************************/

proc casutil;
    droptable casdata="KPI_DAILY_GLOBAL" incaslib="PUBLIC" quiet; 
	load casdata="KPI_DAILY_GLOBAL" incaslib="HIVECASLIB" 
	outcaslib="PUBLIC" casout="KPI_DAILY_GLOBAL" promote;
run;


/*****************************************************************************/
/*  Terminate the specified CAS session (mySession). No reconnect is possible*/
/*****************************************************************************/

cas mySession terminate;


