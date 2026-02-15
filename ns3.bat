@echo off
setlocal

REM === Step 1: Build Docker image ===
echo Building ns-3 Docker image...
docker build -f Dockerfile.ns3 -t ns3-gui .

REM === Step 2: Check for VcXsrv installation ===
set "VCXSRC_PATH=%ProgramFiles%\VcXsrv\vcxsrv.exe"

if exist "%VCXSRC_PATH%" (
    echo VcXsrv is already installed.
) else (
    echo VcXsrv not found. Downloading installer...
    powershell -Command "Invoke-WebRequest -Uri https://sourceforge.net/projects/vcxsrv/files/latest/download -OutFile vcxsrv_installer.exe"
    echo Installing VcXsrv...
    start /wait vcxsrv_installer.exe /S
)

REM === Step 3: Start X server ===
echo Starting X server...
start "" "%VCXSRC_PATH%" :0 -ac -multiwindow -clipboard

REM === Step 4: Run ns-3 container with mounted code/ directory ===
set "CODE_DIR=%cd%\code"
if not exist "%CODE_DIR%" (
    echo Creating code directory...
    mkdir "%CODE_DIR%"
)

echo Running ns-3 container...
docker run -it --rm ^
    -e DISPLAY=host.docker.internal:0 ^
    -v "%CODE_DIR%":/opt/ns3/code ^
    ns3-gui

endlocal
