#define MyAppName "CLIRA"
#define MyAppVersion "0.7.0"
#define MyAppPublisher "Juniper Networks, Inc."
#define MyAppURL "https://github.com/Juniper/juise"

; Change the below define to be the location where you checked out clira-windows-installer
#define CliraWindowsInstallerRoot "C:\CLIRABASE"

; app = application install dir
; tmp = temp dir
; win = windows dir
; group = program group dir

[Setup]
AppId={{7117EAAC-64B1-40FE-9185-0D2949B4783D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
OutputBaseFilename=setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
                  
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel2=This will install [name/ver] on your computer.%n%nIt is recommended that you close all other applications and disable any anti-virus software before continuing.%n%nPlease note that installing this will install a barebones Cygwin installation to run CLIRA inside of.
FinishedLabel=CLIRA has been successfully installed.  To start and stop the CLIRA service, use the scripts provided in the installation folder.

[Files]
Source: "{#CliraWindowsInstallerRoot}\cygwin64\*"; DestDir: "{tmp}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#CliraWindowsInstallerRoot}\Start CLIRA.bat"; DestDir: "{app}";
Source: "{#CliraWindowsInstallerRoot}\Stop CLIRA.bat"; DestDir: "{app}";

[Icons]
Name: "{group}\Start CLIRA Service"; Filename: "{app}\Start CLIRA.bat";
Name: "{group}\Stop CLIRA Service"; Filename: "{app}\Stop CLIRA.bat";
Name: "{group}\Open Browser to CLIRA"; Filename: "http://127.0.0.1:{code:GetCliraPort}/";

[Run]
Filename: "{tmp}\setup-x86_64.exe"; Parameters: "-L -l ""{tmp}\local"" -a x86_64 -P libbz2_1,libcurl4,libopenssl100,libpcre0,libsqlite3_0,libssh2_1,libuuid1,libxml2,libxslt,openssh,libslax,lighttpd-for-juise,juise -q -n -R ""{app}\cygwin""";
Filename: "{app}\cygwin\bin\bash.exe"; Parameters: "--login -c ""/usr/local/bin/mixer --create-db"""; Flags: runhidden;

[UninstallRun]
Filename: "{app}\Stop CLIRA.bat"; Flags: runhidden;

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
var
portPage : TInputQueryWizardPage;

procedure InitializeWizard;
begin
  portPage := CreateInputQueryPage(wpSelectDir,
    'CLIRA Options', 'Please specify the following installation options.',
    '');
  portPage.Add('Port CLIRA Listens On:', False);
  portPage.Values[0] := '3000';
end;

procedure ExpandVariablesInFile(fileName: String; portOnly: Boolean);
var
  data: String;
begin
  if LoadStringFromFile(fileName, data) then
  begin
    if portOnly then
    begin
      StringChangeEx(data, '3000', portPage.Values[0], True);
    end else
    begin
      StringChangeEx(data, '$APPDIR$', ExpandConstant('{app}'), True);
    end;  
    SaveStringToFile(FileName, data, False);
  end; 
end;
 
procedure DoPostInstall();
begin
  ExpandVariablesInFile(ExpandConstant('{app}\Start CLIRA.bat'), False);
  ExpandVariablesInFile(ExpandConstant('{app}\Stop CLIRA.bat'), False);
  ExpandVariablesInFile(ExpandConstant('{app}\cygwin\usr\local\etc\lighttpd.conf'), True);
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssInstall then
  begin
    // messages before install
  end else if CurStep = ssPostInstall then
  begin
    DoPostInstall();
  end;
end;

function GetCliraPort(Param: String): String;
begin
  result := PortPage.Values[0];
end;
