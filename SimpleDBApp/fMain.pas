unit fMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB, System.DateUtils;

type
  TFormMain = class(TForm)
    ADOQuery: TADOQuery;
    ADOConnection: TADOConnection;
    mmOutput: TMemo;
    txtKeyName: TEdit;
    btnConnect: TButton;
    btnSearchForRecords: TButton;
    Label1: TLabel;
    Label2: TLabel;
    txtSubKey2: TEdit;
    cbIncludeSubKey2: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    btAccessUnitializedObject: TButton;
    btnRunCommand: TButton;
    btCreateFileInWinSys: TButton;
    Label3: TLabel;
    txtCommand: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSearchForRecordsClick(Sender: TObject);
    procedure ADOConnectionAfterConnect(Sender: TObject);
    procedure ADOConnectionAfterDisconnect(Sender: TObject);
    procedure ADOConnectionBeforeConnect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnRunCommandClick(Sender: TObject);
    procedure btCreateFileInWinSysClick(Sender: TObject);
    procedure btAccessUnitializedObjectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddToLog(sText : string);
  end;

  TDumbObject = class(TObject)
    function AddNumbers(n1, n2 : integer) : integer;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
// Run a DOS program and retrieve its output dynamically while it is running.
// https://stackoverflow.com/questions/1454501/how-do-i-run-a-command-line-program-in-delphi
function GetDosOutput(CommandLine: string; Work: string = 'D:\'): string;
var
  SecAtrrs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  pCommandLine: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SecAtrrs do begin
    nLength := SizeOf(SecAtrrs);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAtrrs, 0);
  try
    with StartupInfo do
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), StartupInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := ReadFile(StdOutPipeRead, pCommandLine, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            pCommandLine[BytesRead] := #0;
            Result := Result + pCommandLine;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;

//------------------------------------------------------------------------------
procedure TFormMain.FormShow(Sender: TObject);
begin
  Randomize();
  mmOutput.Lines.Clear;
end;

//------------------------------------------------------------------------------
procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Cleanup and close
  if (ADOConnection.Connected) then begin
    AddToLog('Disconnecting from Database...');
    ADOConnection.Connected := false;
    sleep(1000);
  end;
end;

//------------------------------------------------------------------------------
procedure TFormMain.AddToLog(sText: string);
begin
  if (sText = '') then
    mmOutput.Lines.Add('')
  else
    mmOutput.Lines.Add(FormatDateTime('H:NN:SSam/pm', Now()) + ' - ' + sText);
end;

//------------------------------------------------------------------------------
procedure TFormMain.btnConnectClick(Sender: TObject);
begin
  ADOConnection.Connected := not ADOConnection.Connected;
end;

//------------------------------------------------------------------------------
procedure TFormMain.btnSearchForRecordsClick(Sender: TObject);
var
   sSQL : string;
   d : TDateTime;
   iRows, iMS : integer;
begin
  // Note the intentional lack of parameterization
  // There might be a reason :-)
  sSQL :=
    'SELECT TOP 500 * FROM Registry WHERE (KeyName = ''' +
    Trim(txtKeyName.Text) + ''')';

  if cbIncludeSubKey2.Checked then begin
     sSQL := sSQL + ' AND (SubKey2 = ''' + Trim(txtSubKey2.Text) + ''')';
  end;

  d := Now();
  AddToLog('Running Query...');
  if (ADOQuery.Active) then ADOQuery.Close;
  ADOQuery.SQL.Text := sSQL;
  ADOQuery.Open;
  iRows := ADOQuery.RecordCount;
  ADOQuery.Close;

  iMS := MilliSecondsBetween(Now(), d);
  AddToLog('Records Returned: ' + IntToStr(iRows) + ', Elapsed: ' + IntToStr(iMS) + 'ms');
end;

//------------------------------------------------------------------------------
procedure TFormMain.ADOConnectionAfterConnect(Sender: TObject);
begin
  AddToLog('Connected to Database');
end;

//------------------------------------------------------------------------------
procedure TFormMain.ADOConnectionAfterDisconnect(Sender: TObject);
begin
  AddToLog('Disconnected from Database');
end;

//------------------------------------------------------------------------------
procedure TFormMain.ADOConnectionBeforeConnect(Sender: TObject);
begin
  AddToLog('Attempting to connect...');
end;

//------------------------------------------------------------------------------
procedure TFormMain.btnRunCommandClick(Sender: TObject);
var
  sCommand, sPath, sResult : string;
begin
  sCommand := txtCommand.Text;
  sPath := GetCurrentDir() + '\';
  AddToLog('');
  AddToLog('Command: ' + sCommand);
  AddToLog('Path: ' + sPath);

  sResult := GetDosOutput(sCommand, sPath);
  AddToLog('Result: ' + sResult);
end;

//------------------------------------------------------------------------------
procedure TFormMain.btCreateFileInWinSysClick(Sender: TObject);
var
  sl : TStringList;
  sPath : string;
begin
  sl := TStringList.Create;
  sl.Text := 'Test file. Delete when you want';
  sPath := 'C:\Windows\System32\_tempfile.exe';
  sl.SaveToFile(sPath);

  AddToLog('File Creation Attempt: ' + sPath);
  AddToLog('As a bonus, StringList not free''d!');
end;

//------------------------------------------------------------------------------
function TDumbObject.AddNumbers(n1, n2: integer): integer;
begin
  result := n1 + n2;
end;

//------------------------------------------------------------------------------
procedure TFormMain.btAccessUnitializedObjectClick(Sender: TObject);
var
  dumb : TDumbObject;
  n1, n2, n3 : integer;
begin
  try
    n1 := Random(100);
    n2 := Random(100);
    n3 := dumb.AddNumbers(n1, n2);
    AddToLog('Well... ' + IntToStr(n1) + ' + ' + IntToStr(n2) + ' = ' + IntToStr(n3));
  except
    AddToLog('AddToNumbers Exception');
  end;
end;

end.
