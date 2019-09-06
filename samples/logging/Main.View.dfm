object MainView: TMainView
  Left = 0
  Top = 0
  Caption = 'MainView'
  ClientHeight = 153
  ClientWidth = 377
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
  object Button1: TButton
    Left = 32
    Top = 64
    Width = 150
    Height = 25
    Caption = 'Send e-mail message'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 188
    Top = 64
    Width = 150
    Height = 25
    Caption = 'Send WhatsApp message'
    TabOrder = 1
    OnClick = Button2Click
  end
end
