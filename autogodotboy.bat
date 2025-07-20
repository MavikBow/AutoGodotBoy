@echo off
setlocal enabledelayedexpansion

echo =====================================================================

if not exist "godot\" (
	echo Godot not found, downloading from github
	curl -L -o Godot_v4.3.zip "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip"
	mkdir godot
	tar -xf Godot_v4.3.zip -C godot
	del Godot_v4.3.zip
)

echo =====================================================================

if not exist "%APPDATA%\Godot\export_templates\4.3.stable\" (
	echo Export templates not found, downloading from github
	curl -L -o templates.zip "https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_export_templates.tpz"
	echo Unzipping the templates
	tar -xf templates.zip 
	del templates.zip
	robocopy templates "%APPDATA%\Godot\export_templates\4.3.stable" /MOVE /E
)

echo =====================================================================

if not exist "gbc-exe-template\" (
	echo Template project not found, downloading from gitlab
	curl -L -o gbc.zip "https://gitlab.com/greenfox/gbc-exe-template/-/archive/0787b25271eca39a9886047ba0aef945f536c9a2/gbc-exe-template-0787b25271eca39a9886047ba0aef945f536c9a2.zip"
	tar -xf gbc.zip
	ren gbc-exe-template-0787b25271eca39a9886047ba0aef945f536c9a2 gbc-exe-template
	del gbc.zip
)

echo =====================================================================

REM copying the rom file

set "gameName=game"
for %%F in (*.gb *.gbc) do (
	echo Copying over %%~nxF
	set "gameName=%%~nF"
	del /q "gbc-exe-template\roms\*"
	xcopy "%%F" "gbc-exe-template\roms\" /i /y
	break
)

echo =====================================================================

if not exist "sed-4.9-x64.exe" (
	curl -L -O "https://github.com/mbuilov/sed-windows/releases/download/sed-4.9-x64-fixed/sed-4.9-x64.exe"
)
sed-4.9-x64.exe -i "s|^.*config/name=.*|config/name=\"!gameName!\"|" "gbc-exe-template\project.godot"

echo =====================================================================

if not exist "build\" (
	echo Cleaning the export folder
	for /d %%i in ("gbc-exe-template\public\*") do (
    	del /q "%%i\*"
    	for /d %%j in ("%%i\*") do rd /s /q "%%j"
	)
	echo(
	echo Exporting the projects
	mkdir build
	cd gbc-exe-template
	..\godot\Godot_v4.3-stable_win64.exe --headless --export-release Windows "public\Windows\!gameName!.exe"
	..\godot\Godot_v4.3-stable_win64.exe --headless --export-release Web "public\Web\!gameName!.html"
	..\godot\Godot_v4.3-stable_win64.exe --headless --export-release Linux.arm64 "public\Linux.arm64\!gameName!.arm64"
	..\godot\Godot_v4.3-stable_win64.exe --headless --export-release Linux.x64 "public\Linux.x64\!gameName!.x86_64"
	cd ..
	echo(
	echo Copying the results into the build folder
	xcopy gbc-exe-template\public build /E /H /C /I
)

pause
