Rem Stop Tileusage Service so that the IIS Logs can be refreshed with the previous days activities
cd /D "C:\PYTHON27\ArcGIS10.1\"

python.exe "C:\Program Files\ArcGIS\Server\tools\admin\manageservice.py" -u erodenberg -p mapmaker -s http://localhost:6080 -t -n CacheUsageHeatmap -o stop


Rem Update IISLogsLP with the previous days activites
cd /D "C:\Program Files (x86)\Log Parser 2.2"

LogParser.exe "SELECT TO_TIMESTAMP(date, time) AS dateTime, c-ip, time-taken, cs-uri-stem FROM c:\inetpub\logs\LogFiles\w3svc1\u_extend1.log TO IISLogsLP WHERE cs-uri-stem LIKE '/maps/rest/services/ODNR/ODNR_Streetmap/MapServer/tile/%%' AND dateTime >= SUB(SYSTEM_TIMESTAMP(), TIMESTAMP('0000-01-01 23:59:59','yyyy-mm-dd hh:mm:ss'))" -o:SQL -oConnString: "Driver={SQL Server Native Client 10.0}; Server=AMAZONA-MF76T38; Database=IISLogsLP;Trusted_Connection=yes;" -ignoreMinwarns:OFF -createTable:ON -maxStrFieldLen:8000

Rem Update Tileusage Geodatabase
echo on
cd /D "C:\Python27\ArcGIS10.1\"
python.exe "D:\Geoprocessing\TileTracking\Python\TileUsage\TileUsage.py" 
echo off

Rem Restart Tile Usage Map Service
python.exe "C:\Program Files\ArcGIS\Server\tools\admin\manageservice.py" -u erodenberg -p mapmaker -s http://localhost:6080 -t -n CacheUsageHeatmap -o start