function Add-RegistryKey{

    $parent_path = "Registry::\HKEY_CLASSES_ROOT\Directory\Background\shell\"
    $newItemName = "OpenPSHereAdmin"
    $displayName = "Powershell öffnen (Admin)"
    $pathToIcon = "C:\programs\icons\powershell.ico"
    $commandToExecute = "powershell.exe -noexit -command Start-Process powershell -Verb runAs"




    Write-Host "Adding Registry Key"
    Get-ChildItem -Path $parent_path
    #Get-ItemPropertyValue -Path "Registry::\HKEY_CLASSES_ROOT\Directory\Background\shell\"

    $registry_path = $parent_path + "\" + $newItemName

    if (Test-Path -Path $registry_path){
        Write-Host "Path already exists: " $registry_path
    }else{
        New-Item -Path $registry_path -Force
        
        $value = $displayName
        New-ItemProperty -Path $registry_path -Name "(Default)" -Value $value
        $value =  $pathToIcon 
        New-ItemProperty -Path $registry_path -Name "Icon" -Value $value -PropertyType "2"
    }


    $registry_path = $registry_path + "\command"
    if (Test-Path -Path $registry_path){
        Write-Host "Path already exists: " $registry_path
    }else{
        #$registry_path = "Registry::\HKEY_CLASSES_ROOT\Directory\Background\shell\Test" 
        New-Item -Path $registry_path -Force
        #$registry_path = "Registry::\HKEY_CLASSES_ROOT\Directory\Background\shell\Test" 

    }
    $value = $commandToExecute
    New-ItemProperty -Path $registry_path -Name "(Default)" -Value $value

}