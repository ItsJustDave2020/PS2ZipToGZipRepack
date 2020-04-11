#This script is designed to extract Playstation 2 zips and then compress the files that are extracted into a much smaller .gzip file. 
#IMPORTANT - YOU SHOULD HAVE THIS SCRIPT IN THE SAME FOLDER AS WHAT YOU HAVE $procPath set to below. Placing it elsewhere may result
#in loss of data due to the way the cleanup routine is coded. YOU'VE BEEN WARNED.
#Requirements - 
# Powershell 7 : https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7
# 7zip4Powershell - after you install powershell 7 you can run this command: Install-Module -Name 7Zip4Powershell -RequiredVersion 1.9.0 


$procPath = "E:\PS2Processing"; #folder on a drive that has space for you to process the files. SSDs are usually faster if you have one. Should be the folder this script is in!
$destPath = "E:\Launchbox\Games\Sony Playstation 2"; #final destination - Launchbox's rom folder most likely
$wtpPath = "E:\PS2WTP" #waiting to process folder - where you usually download your roms
$targ = 30; #number of files you'd like to process at a time, set this to -1 if you're OK copying every file over at once. - NOT ENCOURAGED TO DO THIS
$uz = 0;
$rp = 0;
$loop = 0;
$i = 0;
$forever = 1; #change this to zero if you only want to do 30 files at a time with breaks in between. If set to 1 program will lopp until it runs out of zips.

#Loop to run forever / move 30 zips into processing folder at a time only - to change the number you move adjust $targ above.
while ($forever = 1)
{
        Get-ChildItem "$wtpPath\*.zip" | ForEach-Object {
        if( $i -ne $targ ){
        Move-Item $_ $procPath
        $i++;
        Write-Host "Moved a file new total is $i"
            }
        }


#Extract Copied Zips
    Get-ChildItem "$procPath\*.zip" | ForEach-Object { 
        & Expand-7Zip $_.Name .\;
        $uz++ 
        Write-Host "$uz files unpacked"};

    
#Repack With Superior Compression and Clean Up Folder / Move 
    Get-ChildItem  "$procPath\*.iso","$procPath\*.bin" | ForEach-Object { 
        & Compress-7Zip ($_.BaseName+".gz") $_.Name; 
        $rp++
        Write-Host "We've repacked $rp files."};
        Write-Host "We're cleaning up the folder so we can do it again!"
        Remove-Item *.iso, *.bin, *.cue, *.zip -Force;
        Move-Item *.gz "$destPath";
        $loop++
        $i = 0
        Write-Host "We've looped $loop times!"
}



