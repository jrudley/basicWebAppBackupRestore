#place into an Azure automation runbook to automate backups and optional restores
#author: Jimmy Rudley 
#date: 05/31/2018


#Login-AzureRmAccount
function get-zip {
    param( 
        [Parameter(Mandatory = $true)]
        [string]$resourceGroup,
        [Parameter(Mandatory = $true)]
        [string]$siteName,
        [string]$folderPathToDownloadFile = 'c:\temp\'
    )  
    
    try {
        [xml]$publishSettings = Get-AzureRmWebAppPublishingProfile -Format WebDeploy  -ResourceGroupName $resourceGroup -Name $siteName
        $creds = $publishSettings.SelectSingleNode("//publishData/publishProfile[@publishMethod='MSDeploy']")
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $creds.userName, $creds.userPWD)))

        if (!(Test-Path $folderPathToDownloadFile)) {
            New-Item -ItemType Directory -Path $folderPathToDownloadFile
        }

        #include trailing slash
        Invoke-RestMethod -Uri "https://$siteName.scm.azurewebsites.net/api/zip/site/wwwroot/" -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} `
            -OutFile "$($folderPathToDownloadFile)\wwwroot.zip" -Method Get -ContentType 'multipart/form-data' -Verbose
    }
    catch {
        $_ 
    }
}

function set-zip {
    param( 
        [Parameter(Mandatory = $true)]
        [string]$resourceGroup,
        [Parameter(Mandatory = $true)]
        [string]$siteName,
        [Parameter(Mandatory = $true)]
        [string]$zipFile,
        [switch]$detailedDebug,
        [int]$extractSleepTimeInSeconds = 15
    ) 

    try {      
        [xml]$publishSettings = Get-AzureRmWebAppPublishingProfile -Format WebDeploy  -ResourceGroupName $resourceGroup -Name $siteName
        $creds = $publishSettings.SelectSingleNode("//publishData/publishProfile[@publishMethod='MSDeploy']")
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $creds.userName, $creds.userPWD)))


        $Headers = @{
            Authorization = $base64AuthInfo
        }
      
        $headers = Invoke-WebRequest -Uri "https://$siteName.scm.azurewebsites.net/api/zipdeploy?isAsync=true" -Method Post  -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} -InFile $zipFile -ContentType  'multipart/form-data'  | 
            Select-Object -expand Headers
       
        $status = Invoke-RestMethod -Uri $headers.Location -Method Get -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        
        #looked through kudu api source and it seems 4 means success. 
        while ($status.status -ne 4) {   
            Write-Output "Not finished unzipping..sleeping $extractSleepTimeInSeconds seconds"
            $status = Invoke-RestMethod -Uri $headers.Location -Method Get -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)} 
            if ($detailedDebug) {
                Write-Output $status
            }
            start-sleep -s $extractSleepTimeInSeconds
        }           
        
        $status = Invoke-RestMethod -Uri $headers.Location -Method Get -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo)}
        if ($status.status -eq 4) {
            Write-Output "Finished unzipping $zipFile"
            $status
        }
        else {
            Write-Output "Something did not go right unzipping $zipfile. Please investigate..."
        }
    }
    catch {
        $_
    }
}

get-zip -resourceGroup 'jimmywebappbasic' -siteName 'jimmywebappbasic'
set-zip -resourceGroup 'jimmydr' -siteName 'jimmydr' -zipFile 'C:\temp\wwwroot.zip' -detailedDebug
