#start "C:\Program Files\Google\Chrome\Application\chrome.exe"
$input = Read-Host "Bitte link eingeben: "
if ($input.EndsWith("?download=true")){

    #aus Link: ...e/doi/pdf/10.3139/9783446449893.019?download=true
    #wird:  ...e/doi/pdf/10.3139/9783446449893.001?download=true
    #       ...e/doi/pdf/10.3139/9783446449893.002?download=true
    #       ...
    #       ...e/doi/pdf/10.3139/9783446449893.fm?download=true
    #       ...e/doi/pdf/10.3139/9783446449893.bm?download=true

    Write-Host "richtiges Format"
    $input
    $raw = $input.replace("?download=true","")
    $raw
    $raw = $raw.Substring(0, $raw.length - 3)
    for($i = 31; $i -lt 70; $i++){
        try {
            $texti = '{0:d3}' -f $i
            $link = $raw + $texti  + "?download=true" 
            $link
            start "C:\Program Files\Google\Chrome\Application\chrome.exe" $link
        }
        catch {
            <#Do this if a terminating exception happens#>
        }
    }
    $link = $raw + "fm"  + "?download=true"
    start "C:\Program Files\Google\Chrome\Application\chrome.exe" $link
    $link = $raw + "bm"  + "?download=true"
    start "C:\Program Files\Google\Chrome\Application\chrome.exe" $link
}else{
    Write-Host "Link hat nicht das richtiges Format"   
}