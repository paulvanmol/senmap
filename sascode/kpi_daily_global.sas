proc import datafile="/home/christine/senmap/KPI_DAILY_GLOBAL_TEST.xlsx"
DBMS=XLSX
out=mapscstm.kpi_daily_global; 
GETNAMES=YES;
run; 

data mapscstm.kpi_daily_global_final;
set mapscstm.kpi_daily_global; 
if day ne 0 then do; 
dayc=put(day,8.);
daydt=input(dayc,yymmdd8.);
end; 
format daydt yymmdd8.; 
run; 

cas mysession; 
proc casutil; 
droptable incaslib="public" casdata="kpi_global_daily" quiet; 
load data=mapscstm.kpi_daily_global_final 
casout="kpi_global_daily" outcaslib="public" promote; 
quit; 

cas mysession terminate; 