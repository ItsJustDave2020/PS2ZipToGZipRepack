#This script is designed to extract Playstation 2 zips and then compress the files that are extracted into a much smaller .gzip file. 
#IMPORTANT - YOU SHOULD HAVE THIS SCRIPT IN THE SAME FOLDER AS WHAT YOU HAVE $procPath set to below. Placing it elsewhere may result
#in loss of data due to the way the cleanup routine is coded. YOU'VE BEEN WARNED.
#Requirements - 
# Powershell 7 : https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7
# 7zip4Powershell - after you install powershell 7 you can run this command: Install-Module -Name 7Zip4Powershell -RequiredVersion 1.9.0 
# Power ISO Pro - power ISO pro is required (and needs to be added to PATH) for the ISO conversion portion


$procPath = "F:\PS2Processing"; #folder on a drive that has space for you to process the files. SSDs are usually faster if you have one. Should be the folder this script is in!
$destPath = "F:\Launchbox\Games\Sony Playstation 2"; #final destination - Launchbox's rom folder most likely
$wtpPath = "F:\PS2WTP"; #waiting to process folder - where you usually download your roms
$dlPath = "D:\ps2games";
$targ = 5; #number of files you'd like to process at a time, set this to -1 if you're OK copying every file over at once. - NOT ENCOURAGED TO DO THIS
$uz = 0; #value to report how many files the system has unpacked so far
$rp = 0; #value to report how many files the system has recompressed so far
$loop = 0; #value to track how many loops the system has done. Also used to time when to check the download folder. 
$i = 5;
$iTotal = 0;
$forever = 1; #change this to zero if you only want to do 30 files at a time with breaks in between. If set to 1 program will lopp until it runs out of zips.
$checkdlFolder = 0; #flag for system to check a designated download folder
$zipstoMove = 0; #value set by system for monitoring if there are 10 or more zips to move from your download folder
$loopstoCheckin = 0; #value to modify how often we check in the download folder for more files
$ltcii = 10;

#Loop to run forever / move 30 zips into processing folder at a time only - to change the number you move adjust $targ above.

$dlPath = Write-Host "What is the path to your download folder? (IE: D:\Downloads)";
$loopstoCheckin = Write-Host "How many times should we loop before checking for new downloads?";
$ltcii = $loopstoCheckin;
$checkdlFolder = Write-Host "Should we check the dl folder now? (1 for yes, 0 for no)";
$convertbin = Write-Host "Should we convert .bin/.cue files to .isos? (1 for yes, 0 for no)";

if($convertbin = 0){
    $bincueFolder = Write-Host "Where should we store bin/cue files so you can convert them later?";
}


while ($checkdlFolder = 1){
        Get-ChildItem "$dlfolder\*.zip" | ForEach-Object {
        $zipstoMove++
}
    if($zipstoMove -gt 10){
        RoboCopy $dlPath $wtpPath /mov
        $checkdlFolder = 0;
        $forever = 1;
    }
}

while ($forever = 1)
{
        Get-ChildItem "$wtpPath\*.zip","$wtpPath\*.gz" | ForEach-Object {
        if( $i -ne $targ ){
        Move-Item $_ $procPath
        $i++;
        $iTotal++;
        Write-Host "Moved a file new total is $iTotal!"
            }
        }


#Extract Copied Zips
    Get-ChildItem "$procPath\*.zip","$procPath\*.gz" | ForEach-Object { 
        & Expand-7Zip $_.Name .\;
        $uz++ 
        Write-Host "$uz files unpacked"};

    if($convertbin = 1){    
    Get-ChildItem "$procPath\*.bin" | ForEach-Object{
        Write-Host "We're converting "$_.Name" to an ISO and deleting the Bin/Cue files!"
        & piso convert $_.Name -o ($_.BaseName+".iso");
        Remove-Item ($_.BaseName+".bin"), ($_.BaseName+".Cue") -Force

    if($convertbin = 0){
        Move-Item *.bin $bincueFolder
        Move-Item *.cue $bincueFolder
    }
    }
}

    
#Repack With Superior Compression and Clean Up Folder / Move 
    Get-ChildItem  "$procPath\*.iso" | ForEach-Object { 
        & .\maxcso.exe --threads=10 --fast ($_.Name) -o ($_.BaseName+".cso"); 
        $rp++
        Write-Host "We've repacked $rp files."};
        Write-Host "We're cleaning up the folder so we can do it again!"
        Remove-Item *.iso, *.zip, *.gz -Force;
        Move-Item *.cso "$destPath";
        $loop++
        $i = 0
        Write-Host "We've looped $loop times!"

    if($loop -eq $loopstoCheckin){
        $checkdlFolder = 1;
        $forever = 0;
        $loopstoCheckin + $ltcii;
    }
}



