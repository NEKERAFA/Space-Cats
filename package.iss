; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Space Cats"
#define MyAppVersion "1.0"
#define MyAppPublisher "NEKERAFA"
#define MyAppExeName "spacecats.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{14075D8A-C231-46CB-BCF2-387F542AAE57}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=C:\Users\NEKERAFA\Desktop\Space Cats\LICENSE
OutputBaseFilename=setup
SetupIconFile=C:\Users\NEKERAFA\Desktop\Space Cats\icon.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\spacecats.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\changes.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\license.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\love.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\lovec.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\lua51.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\mpg123.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\msvcp120.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\msvcr120.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\OpenAL32.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\readme.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\SDL2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\src\*"; DestDir: "{app}\src"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Users\NEKERAFA\Desktop\Space Cats\binary\spacecats_1.0-demo-win32\lang\*"; DestDir: "{app}\lang"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
