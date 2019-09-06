object DBConnection: TDBConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 179
  Width = 215
  object FDConnection: TFDConnection
    Params.Strings = (
      
        'Database=D:\Workspace\Aspect4Delphi\samples\transaction\database' +
        '\Invoices.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 88
    Top = 32
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 88
    Top = 96
  end
end
