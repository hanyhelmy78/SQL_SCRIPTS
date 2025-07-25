/*
Solution: We shall use the DISKPART method as follows:

Open Command Prompt as administrator: Search for "cmd" in the Start menu, right-click on "Command Prompt," and select "Run as administrator."

Launch DiskPart: Type **DISKPART** and press Enter.
List volumes: Type **LIST VOLUME** and press Enter to display all available volumes and their corresponding numbers.
Select the target volume: Type **SELECT VOLUME X** (replace X with the number of the volume you want to clear read-only) and press Enter.
Set the volume as read-only: Type **ATTRIBUTES VOLUME CLEAR READONLY** and press Enter.
*/
