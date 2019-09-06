object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 237
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 92
    Width = 497
    Height = 137
    Caption = 'Person'
    TabOrder = 0
    object Label1: TLabel
      Left = 24
      Top = 29
      Width = 10
      Height = 13
      Caption = 'Id'
    end
    object Label2: TLabel
      Left = 111
      Top = 29
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object Label3: TLabel
      Left = 399
      Top = 29
      Width = 19
      Height = 13
      Caption = 'Age'
    end
    object EdtId: TEdit
      Left = 24
      Top = 48
      Width = 81
      Height = 21
      Color = clInfoBk
      Enabled = False
      TabOrder = 0
    end
    object EdtName: TEdit
      Left = 111
      Top = 48
      Width = 282
      Height = 21
      TabOrder = 1
    end
    object EdtAge: TEdit
      Left = 399
      Top = 48
      Width = 81
      Height = 21
      TabOrder = 2
    end
    object Button1: TButton
      Left = 24
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Insert'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 111
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Update'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 198
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Delete'
      TabOrder = 5
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 285
      Top = 91
      Width = 81
      Height = 25
      Caption = 'Find By Id'
      TabOrder = 6
      OnClick = Button4Click
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 497
    Height = 78
    Caption = 'Current Security Role'
    TabOrder = 1
    object EdtCurrentSecurityRole: TComboBox
      Left = 120
      Top = 32
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'ROLE_ADMIN'
      Items.Strings = (
        'ROLE_ADMIN'
        'ROLE_GUEST')
    end
    object Button5: TButton
      Left = 271
      Top = 30
      Width = 81
      Height = 25
      Caption = 'Change'
      TabOrder = 1
      OnClick = Button5Click
    end
  end
end
