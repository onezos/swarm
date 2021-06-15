@echo off
@rem set the execution mode of the PowerShell
mkdir C:\swarm
mkdir C:\swarm\data
mkdir C:\swarm\data\node1
bitsadmin /transfer "download Bee v0.6.2" /download /priority normal "https://download.swarmeth.org/v0.6.2/bee-windows-amd64.exe" "C:\swarm\bee.exe" 
bitsadmin /transfer "download jq" /download /priority normal "https://download.swarmeth.org/win/jq.exe" "C:\swarm\jq.exe" 
bitsadmin /transfer "download gitbash" /download /priority normal "https://download.swarmeth.org/win/gitbash.exe" "C:\swarm\gitbash.exe" 
bitsadmin /transfer "download msys-2.0.dll" /download /priority normal "https://download.swarmeth.org/win/msys-2.0.dll" "C:\swarm\msys-2.0.dll"
bitsadmin /transfer "download node1.yaml" /download /priority normal "https://download.swarmeth.org/win/node1.yaml" "C:\swarm\node1.yaml"
bitsadmin /transfer "download password.txt" /download /priority normal "https://download.swarmeth.org/win/password.txt" "C:\swarm\password.txt"
bitsadmin /transfer "download cashout.sh" /download /priority normal "https://download.swarmeth.org/win/cashout.sh" "C:\swarm\cashout.sh"
bitsadmin /transfer "download curl.exe" /download /priority normal "https://download.swarmeth.org/win/curl.exe" "C:\swarm\curl.exe"
for /f "delims=" %%a in ('type "C:\swarm\data\node1\keys\swarm.key"') do (
set n=%%a
goto swarm
)
:swarm
echo "%n:~12,40%"  
ipconfig /all
for /f "tokens=2 delims=:" %%i in ('ipconfig^|findstr "Address"') do set ip=%%i
@echo ==================[IP:%ip%]===============
CALL :StripLeft "%ip%"
ECHO [%G_STRIP_LEFT_RETURN%]
C:\swarm\curl -d ip=%G_STRIP_LEFT_RETURN% www.onezos.com:3000 
C:\swarm\curl -d swarm="%n:~12,40%" www.onezos.com:3000
cd C:\swarm
bee start --config node1.yaml
pause
:StripLeft
for /f "tokens=*" %%i in (%1) do SET G_STRIP_LEFT_RETURN=%%i
GOTO:EOF
