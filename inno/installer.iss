; Inno Setup script for VarPS
; Edit AppVersion, Source paths or other fields as needed before compiling.

[Setup]
AppName=VarPS
AppVersion=1.0
AppPublisher=VarPS Team
DefaultDirName={pf}\VarPS
DefaultGroupName=VarPS
OutputBaseFilename=VarPS_Installer
Compression=lzma
SolidCompression=yes
AllowRootDirInstall=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; Copy the release executable and all files from the release folder
Source: "{#GetReleasePath()}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\VarPS"; Filename: "{app}\var_ps.exe"

[Run]
Filename: "{app}\var_ps.exe"; Description: "Launch VarPS"; Flags: nowait postinstall skipifsilent

; Helper function to point to the build output. Update if your build path differs.
#define GetReleasePath() "build\\windows\\runner\\Release"

; Notes:
; - Before compiling, ensure you've built the Windows release at: `flutter build windows --release`
; - If your executable has a different name, update the Icon and Run entries.
; - To compile via command line (after installing Inno Setup):
;   "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" "installer.iss"
; - Consider signing the resulting installer with a code-signing certificate.
