object InvoiceModel: TInvoiceModel
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 213
  Width = 215
  object Invoice: TFDQuery
    Connection = DBConnection.FDConnection
    SQL.Strings = (
      'SELECT * FROM INVOICE')
    Left = 88
    Top = 24
    object InvoiceINV_NUMBER: TIntegerField
      DisplayLabel = 'Number'
      FieldName = 'INV_NUMBER'
      Origin = 'INV_NUMBER'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object InvoiceINV_DATE: TDateField
      DisplayLabel = 'Date'
      FieldName = 'INV_DATE'
      Origin = 'INV_DATE'
      ProviderFlags = [pfInUpdate]
      Required = True
    end
    object InvoiceINV_CUSTOMER: TStringField
      DisplayLabel = 'Customer'
      FieldName = 'INV_CUSTOMER'
      Origin = 'INV_CUSTOMER'
      ProviderFlags = [pfInUpdate]
      Required = True
      Size = 60
    end
  end
  object DsInvoice: TDataSource
    DataSet = Invoice
    Left = 88
    Top = 88
  end
  object Product: TFDQuery
    MasterSource = DsInvoice
    MasterFields = 'INV_NUMBER'
    Connection = DBConnection.FDConnection
    SQL.Strings = (
      'SELECT * FROM PRODUCT WHERE PRO_INV_NUMBER = :INV_NUMBER')
    Left = 88
    Top = 144
    ParamData = <
      item
        Name = 'INV_NUMBER'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
    object ProductPRO_SKU: TStringField
      DisplayLabel = 'SKU'
      FieldName = 'PRO_SKU'
      Origin = 'PRO_SKU'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object ProductPRO_NAME: TStringField
      DisplayLabel = 'Name'
      FieldName = 'PRO_NAME'
      Origin = 'PRO_NAME'
      ProviderFlags = [pfInUpdate]
      Required = True
      Size = 60
    end
    object ProductPRO_PRICE: TBCDField
      DisplayLabel = 'Price'
      FieldName = 'PRO_PRICE'
      Origin = 'PRO_PRICE'
      ProviderFlags = [pfInUpdate]
      Required = True
      Precision = 15
      Size = 2
    end
    object ProductPRO_INV_NUMBER: TIntegerField
      DisplayLabel = 'Invoice'
      FieldName = 'PRO_INV_NUMBER'
      Origin = 'PRO_INV_NUMBER'
      ProviderFlags = [pfInUpdate]
      Required = True
    end
  end
end
