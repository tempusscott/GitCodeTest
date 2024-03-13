object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Testing GIT Repository'
  ClientHeight = 486
  ClientWidth = 610
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    610
    486)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 99
    Width = 49
    Height = 13
    Caption = 'KeyName:'
  end
  object Label2: TLabel
    Left = 24
    Top = 171
    Width = 127
    Height = 13
    Caption = 'SubKey2 (Phone Number):'
  end
  object Label3: TLabel
    Left = 24
    Top = 358
    Width = 51
    Height = 13
    Caption = 'Command:'
  end
  object mmOutput: TMemo
    Left = 300
    Top = 8
    Width = 302
    Height = 470
    Anchors = [akTop, akRight, akBottom]
    Lines.Strings = (
      'mmOutput')
    TabOrder = 0
  end
  object txtKeyName: TEdit
    Left = 79
    Top = 96
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'TWILIO'
  end
  object btnConnect: TButton
    Left = 24
    Top = 24
    Width = 241
    Height = 25
    Caption = 'Connect to Database'
    TabOrder = 2
    OnClick = btnConnectClick
  end
  object btnSearchForRecords: TButton
    Left = 24
    Top = 55
    Width = 241
    Height = 25
    Caption = 'Search for Records'
    TabOrder = 3
    OnClick = btnSearchForRecordsClick
  end
  object txtSubKey2: TEdit
    Left = 168
    Top = 168
    Width = 97
    Height = 21
    TabOrder = 4
    Text = '2608294124'
  end
  object cbIncludeSubKey2: TCheckBox
    Left = 24
    Top = 137
    Width = 169
    Height = 17
    Caption = 'Search by Subkey2:'
    TabOrder = 5
  end
  object btBufferOverruns: TButton
    Left = 24
    Top = 231
    Width = 241
    Height = 25
    Caption = 'Attempt Buffer Over-Runs'
    TabOrder = 6
    OnClick = btBufferOverrunsClick
  end
  object btAccessUnitializedInterface: TButton
    Left = 24
    Top = 262
    Width = 241
    Height = 25
    Caption = 'Access an Interface Incorrectly'
    TabOrder = 7
    OnClick = btAccessUnitializedInterfaceClick
  end
  object btAccessUnitializedObject: TButton
    Left = 24
    Top = 293
    Width = 241
    Height = 25
    Caption = 'Access an Uninitialized TObject'
    TabOrder = 8
    OnClick = btAccessUnitializedObjectClick
  end
  object btnRunCommand: TButton
    Left = 24
    Top = 324
    Width = 241
    Height = 25
    Caption = 'Run a CMD Command'
    TabOrder = 9
    OnClick = btnRunCommandClick
  end
  object btCreateFileInWinSys: TButton
    Left = 24
    Top = 419
    Width = 241
    Height = 25
    Caption = 'Create a File in Win/System32'
    TabOrder = 10
    OnClick = btCreateFileInWinSysClick
  end
  object txtCommand: TEdit
    Left = 88
    Top = 355
    Width = 177
    Height = 21
    TabOrder = 11
    Text = 'dir /b /a-d | find /c /v ""'
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnection
    Parameters = <>
    Left = 384
    Top = 32
  end
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=tempus;Persist Security Info=True;U' +
      'ser ID=tempus;Initial Catalog=RetailNetDev;Data Source=pmdevdb.t' +
      'empus.local;Use Procedure for Prepare=1;Auto Translate=True;Pack' +
      'et Size=4096;Workstation ID=TEMPUSDEV;Use Encryption for Data=Fa' +
      'lse'
    Provider = 'SQLOLEDB.1'
    AfterConnect = ADOConnectionAfterConnect
    BeforeConnect = ADOConnectionBeforeConnect
    AfterDisconnect = ADOConnectionAfterDisconnect
    Left = 496
    Top = 32
  end
end
