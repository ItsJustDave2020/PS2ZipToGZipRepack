# PS2ZipToGZipRepack
Powershell Script To Repack PS2 ZIP archives into GZIP for better storage / native PCSX2 support.

REQUIREMENTS:

Powershell 7 : https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-windows?view=powershell-7

7zip4Powershell - after you install Powershell 7 you can run this command: Install-Module -Name 7Zip4Powershell -RequiredVersion 1.9.0 

maxcso - https://github.com/unknownbrackets/maxcso/releases

powerISO - https://www.poweriso.com/ (pro required for .bin to .iso conversion)

You can either download the file from the repository, or simply copy and paste it into any text editor and save it as a .ps1 file. 
I'd recommend placing this ps1 file in the PROCESSING DIRECTORY (where you're moving the zips to, for the script to work on them) -
as my testing trying to use a dynamic path in the cleanup routine didn't go so well. 

If you put this anywhere else, I am not responsible for lost data. 

Feel free to reach out to me on the LaunchBox discord (ItsJustDave) or Forums (nchawk) if you have any questions!
