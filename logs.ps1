function parseLogTime {
    param (
        $log
    )
    $time = $log.Split("(")[0].TrimEnd()
    
    $time
}
function parseLogText {
    param (
        $log
    )
    $text = $log.Split(")")[1].TrimStart()
    $text
}
function parseMachineIdle {
    param (
        $log
    )
    try{
        $text_log = $log.Substring($log.Length - 12).TrimStart()
        #$text = $log.Split("Machine")[0]
        $time_seconds  = $text_log.Split("seconds")[0].TrimEnd()
        
    }catch [System.Management.Automation.RuntimeException]{
        $time_seconds = 0

    }
    $time_seconds

}

while ($true) {
    $logs = Get-Content "C:\Users\<User>\\AppData\Roaming\Microsoft\Teams\logs.txt" -Last 1000
    [array]::Reverse($logs)
    #$logs | select -Last 10 | Out-Host
    $logs_found = 0
    $relevant_logs = @()
    foreach($log in $logs){
        #Write-Host "new log"
        if(($log -like "*Verfügbar*") -or ($log -like "*Abwesend*") -or ($log -like "*Am Telefon*")-or ($log -like "*Neue Aktivität*")-or ($log -like "*Präsentation*")){
        #if(($log -like "*Verfügbar*") -or ($log -like "*Abwesend*") -or ($log -like "*Am Telefon*")-or ($log -like "*Neue Aktivität*")-or ($log -like "*Präsentation*")-or ($log -like "*Machine has been idle for*")){
            #$log
            $time = parseLogTime -log $log | select -Last 1
            #$time
            $text = parseLogText -log $log | select -Last 1
            #$text
            $new_log = New-Object PSObject
            $new_log | Add-Member -MemberType NoteProperty -Name "Timestamp" -Value $time
            if ($log -like "*Verfügbar*"){
                $new_log | Add-Member -MemberType NoteProperty -Name "Logtext" -Value "Verfügbar" 
            }
            if ($log -like "*Abwesend*"){
                $new_log | Add-Member -MemberType NoteProperty -Name "Logtext" -Value "Abwesend" 
            }
            if ($log -like "*Am Telefon*"){
                $new_log | Add-Member -MemberType NoteProperty -Name "Logtext" -Value "Am Telefon" 
            }
            if ($log -like "*Neue Aktivität*"){
                $new_log | Add-Member -MemberType NoteProperty -Name "Logtext" -Value "Neue Aktivität" 
            }
            if ($log -like "*Präsentation*"){
                $new_log | Add-Member -MemberType NoteProperty -Name "Logtext" -Value "Präsentation" 
            }
            $relevant_logs += $new_log

            $logs_found = $logs_found + 1
            if ($logs_found -gt 10){
                break
            }
        }
    }
    #$relevant_logs 
    $text = "aktuelle Teams-Sitzung: " + ($relevant_logs | select -First 1).Logtext
    Write-Warning $text
    if (($relevant_logs | select -First 1).Logtext -eq "Verfügbar"){
        foreach($log in $logs){
            if($log -like "*Machine has been idle for*"){
                 
                $text = parseLogText -log $log | select -Last 1
                $text
                try{
                    [int]$time_idle = parseMachineIdle -log $text | select -Last 1 -ErrorAction Stop
                }catch [System.Management.Automation.RuntimeException]{
                    $time_idle = 0
                }
                Write-Host $time_idle
                If ($time_idle -gt 250){
                    Write-Error "time"
                }
                break
            }
        }
        Start-Sleep -Seconds 10
    }else{
        Start-Sleep -Seconds 120
    }
    
}

#"Verfügbar"
#"Abwesend"
#"Am Telefon"
#"Neue Aktivität"
#"Präsentation"
#"Machine has been idle for xx seconds" 


