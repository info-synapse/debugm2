object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 433
  ClientWidth = 622
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Memo1: TMemo
    Left = 0
    Top = 161
    Width = 622
    Height = 272
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssBoth
    TabOrder = 0
    ExplicitTop = 176
    ExplicitHeight = 257
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 622
    Height = 161
    Align = alTop
    TabOrder = 1
    object EditSQL: TEdit
      Left = 56
      Top = 96
      Width = 433
      Height = 23
      TabOrder = 0
      Text = 
        'select event_id,testget(event_id) as fresult from bet_events lim' +
        'it 20'
    end
    object CheckLog: TCheckBox
      Left = 408
      Top = 36
      Width = 97
      Height = 17
      Caption = 'Full Log'
      TabOrder = 1
      OnClick = CheckLogClick
    end
    object Test: TButton
      Left = 56
      Top = 65
      Width = 91
      Height = 25
      Caption = '2. Test'
      TabOrder = 2
      OnClick = TestClick
    end
    object CheckUseTSQLDB: TCheckBox
      Left = 56
      Top = 125
      Width = 465
      Height = 25
      Caption = 
        'Run test with TSQLDatabase.executeJson (if checked it will produ' +
        'ce very rare errors)'
      TabOrder = 3
    end
    object Edit1: TEdit
      Left = 272
      Top = 33
      Width = 81
      Height = 23
      TabOrder = 4
      Text = '8887'
    end
    object Button1: TButton
      Left = 56
      Top = 32
      Width = 210
      Height = 25
      Caption = '1. Create Server and DB, listen to port'
      TabOrder = 5
      OnClick = Button1Click
    end
  end
end
