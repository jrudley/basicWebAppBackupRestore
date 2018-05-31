# basicWebAppBackupRestore
This script will use the kudu api to backup and restore web app wwwroot folders.
```
Function get-zip
$resourceGroup = Resource group holding the web app to backup
$siteName = Web App name to backup
$folderPathToDownloadFile = (optional) Folder to download the zip. Will create if it doesn't exist
```  

```
Function set-zip
$resourceGroup = Resource group holding the web app to restore
$siteName = Web App name to restore
$zipFile = Full path to zip file to restore
$detailedDebug = Outputs the status of the restore
$extractSleepTimeInSeconds = How long to sleep in the while loop to check the status
```
Examples:
```
#generate zip and download to c:\temp\
get-zip -resourceGroup 'jimmywebappbasic2' -siteName 'jimmywebappbasic2'
VERBOSE: GET https://jimmywebappbasic2.scm.azurewebsites.net/api/zip/site/wwwroot/ with 0-byte payload
VERBOSE: received -1-byte response of content type application/zip


#unzip without detailed debug
set-zip -resourceGroup 'jimmywebappbasic3' -siteName 'jimmywebappbasic3' -zipFile 'C:\temp\wwwroot.zip'
Not finished unzipping..sleeping 15 seconds
Not finished unzipping..sleeping 15 seconds
Finished unzipping C:\temp\wwwroot.zip


id                    : a781943572cf4a2eaeb7c482a6defa7e
status                : 4
status_text           :
author_email          : N/A
author                : N/A
deployer              : Push-Deployer
message               : Created via a push deployment
progress              :
received_time         : 2018-05-31T13:42:24.0788904Z
start_time            : 2018-05-31T13:42:24.5705089Z
end_time              : 2018-05-31T13:42:26.967799Z
last_success_end_time : 2018-05-31T13:42:26.967799Z
complete              : True
active                : True
is_temp               : False
is_readonly           : True
url                   : https://jimmywebappbasic3.scm.azurewebsites.net/api/deployments/latest
log_url               : https://jimmywebappbasic3.scm.azurewebsites.net/api/deployments/latest/log
site_name             : jimmywebappbasic3



#unzip with detailed debug
set-zip -resourceGroup 'jimmywebappbasic3' -siteName 'jimmywebappbasic3' -zipFile 'C:\temp\wwwroot.zip' -detailedDebug
Not finished unzipping..sleeping 15 seconds


id                    : temp-6fd50185
status                : 0
status_text           : Receiving changes.
author_email          : N/A
author                : N/A
deployer              : Push-Deployer
message               : Deploying from pushed zip file
progress              : Fetching changes.
received_time         : 2018-05-31T13:43:36.0640165Z
start_time            : 2018-05-31T13:43:36.0640165Z
end_time              :
last_success_end_time :
complete              : False
active                : False
is_temp               : True
is_readonly           : False
url                   :
log_url               :
site_name             : jimmywebappbasic3

Not finished unzipping..sleeping 15 seconds
id                    : 2ae6dc90387a41be87f23b1b27544bd5
status                : 4
status_text           :
author_email          : N/A
author                : N/A
deployer              : Push-Deployer
message               : Created via a push deployment
progress              :
received_time         : 2018-05-31T13:43:37.8138692Z
start_time            : 2018-05-31T13:43:38.1117145Z
end_time              : 2018-05-31T13:43:41.1592119Z
last_success_end_time : 2018-05-31T13:43:41.1592119Z
complete              : True
active                : True
is_temp               : False
is_readonly           : True
url                   : https://jimmywebappbasic3.scm.azurewebsites.net/api/deployments/latest
log_url               : https://jimmywebappbasic3.scm.azurewebsites.net/api/deployments/latest/log
site_name             : jimmywebappbasic3

Finished unzipping C:\temp\wwwroot.zip
id                    : 2ae6dc90387a41be87f23b1b27544bd5
status                : 4
status_text           :
author_email          : N/A
author                : N/A
deployer              : Push-Deployer
message               : Created via a push deployment
progress              :
received_time         : 2018-05-31T13:43:37.8138692Z
start_time            : 2018-05-31T13:43:38.1117145Z
end_time              : 2018-05-31T13:43:41.1592119Z
last_success_end_time : 2018-05-31T13:43:41.1592119Z
complete              : True
active                : True
is_temp               : False
is_readonly           : True
url                   : https://jimmywebappbasic3.scm.azurewebsites.net/api/deployments/latest
log_url               : https://jimmywebappbasic3.scm.azurewebsites.net/api/deployments/latest/log
site_name             : jimmywebappbasic3


```
