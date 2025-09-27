<###################################################
##SCript Name:   Harvest Data Processing
###Created by:   Gary Jones
##Create Date:   1/21/2019
##Last Update:   1/21/2019
##Description:   The Process to monitor files being created by Harvest LIS
##               If files are fold in Folder $HarvestSource they are moved to 
##               Harvest Target and events are logged
##               Triggers run every 5 minutes     
####################################################>

#######Process Variables####################################
$HarvestSource = "C:\OrchHost\Results"
$HarvestTarget = "\\pcdbssrsprd1.ohsu.edu\HarvestData\CentralDistribution"
$LogFiles = "C:\OrchHost\Logs\fileChange.txt"
$ISEScripts = "C:\OrchHost\ISEScripts"
$HArvestOrders = "C:\OrchHost\orders"
$TimeStamp = get-Date -format g
$MovedFiles = "C:\OrchHost\ISEScripts\movedFiles" 

########Code################################################
$ArchiveFiles = "\\pcdbssrsprd1\HarvestData\Archive"

###########Test for Files #################################
$CheckSource = Get-ChildItem $HarvestSource
$SourceCount = $CheckSource.count
#"$TimeStamp --Total Files in Source $SourceCount" | Out-File -FilePath $LogFiles -Append 
#get-childitem -path $HarvestSource | out-file -FilePath $LogFiles -Append
#move-item -Path $HarvestSource\*.* -Destination $HarvestTarget -Force
$Targetfiles = get-childItem -path $HarvestTarget
$TargetCount = $Targetfiles.count
#"$TimeStamp --Total Files in Target $TargetCount" | Out-File -FilePath $LogFiles -Append 
$SourceReCheck = $CheckSource.Count
#"$TimeStamp -- Recheck Total Files in Source $SourceRecheck" | Out-File -FilePath $LogFiles -Append 
<#####Verification Code Check ##########################################
If ($WaitingCount -gt 0 )
        {
            $Date = get-date -format g
            $WaitingFiles = get-childItem -path $HarvestSource
            $WaitingCount = $WaitingFiles.count 
             
            Write-host "$Date -- $WaitingCount Files waiting Transfer" -ForegroundColor Green
        }
    Else
        {Write-host "No Files waiting Transfer" -ForegroundColor Yellow}
#>

##############Check for Waiting Files and Log Findings ########################
If ($SourceCount -gt 0)
    ##Files are Found Record Count adn Insert Files List##

    {
            $WaitingFiles = get-childItem -path $HarvestSource
            $WaitingCount = $WaitingFiles.count
        "$Date -- $WaitingCount Files waiting Transfer" | Out-File -FilePath $LogFiles -Append
        Get-ChildItem -path $HarvestSource | Out-file -FilePath $LogFiles -Append

      ###############Move Files to Destination////////////////////////////////////
      Copy-item -Path  $HarvestSource\* -Destination $MovedFiles -Force
      Move-Item -Path $HarvestSource\* -Destination $HarvestTarget -Force
      ##############Check results of Move///////////////////////////////
      $destingtionfiles = Get-ChildItem -Path $HarvestTarget\*
      $DestinationCount = $destingtionfiles.count
      "$Date -- File Move-- File Count for Destination $DestinationCount " | Out-File -FilePath $LogFiles -Append
      ##############Check Source File Count##############################################
      $sourcecheck = Get-childitem -path $HarvestSource
      $SourceReviewCount = $sourcecheck.count
        If($SourceReviewCheck -gt 0)
        {
        ##Need to alert admin of issue
        }else { "$Date -- No Files to Move" | Out-File -FilePath $LogFiles -Append
        #No Action Needed
        }



    }
    exit
       