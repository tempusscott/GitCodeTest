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
    procedure FormShow(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnSearchForRecordsClick(Sender: TObject);
    procedure ADOConnectionAfterConnect(Sender: TObject);
    procedure ADOConnectionAfterDisconnect(Sender: TObject);
    procedure ADOConnectionBeforeConnect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddToLog(sText : string);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
procedure TFormMain.FormShow(Sender: TObject);
begin
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

end.
