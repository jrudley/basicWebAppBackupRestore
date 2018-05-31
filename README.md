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
get-zip -resourceGroup 'jimmywebappbasic' -siteName 'jimmywebappbasic'
set-zip -resourceGroup 'jimmydr' -siteName 'jimmydr' -zipFile 'C:\temp\wwwroot.zip' -detailedDebug
```
