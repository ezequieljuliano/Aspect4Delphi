unit Invoice.Model;

interface

uses
  System.SysUtils, System.Classes, DB.Connection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type

  TInvoiceModel = class(TDataModule)
    Invoice: TFDQuery;
    InvoiceINV_NUMBER: TIntegerField;
    InvoiceINV_DATE: TDateField;
    InvoiceINV_CUSTOMER: TStringField;
    DsInvoice: TDataSource;
    Product: TFDQuery;
    ProductPRO_SKU: TStringField;
    ProductPRO_NAME: TStringField;
    ProductPRO_PRICE: TBCDField;
    ProductPRO_INV_NUMBER: TIntegerField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ClearDatabasesRecords;
  public
    { Public declarations }
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TInvoiceModel.ClearDatabasesRecords;
begin
  Product.First;
  while not Product.Eof do
    Product.Delete;

  Invoice.First;
  while not Invoice.Eof do
    Invoice.Delete;
end;

procedure TInvoiceModel.DataModuleCreate(Sender: TObject);
begin
  Invoice.Connection := DBConnection.FDConnection;
  Product.Connection := DBConnection.FDConnection;

  Invoice.Open();
  Product.Open();

  ClearDatabasesRecords;
end;

procedure TInvoiceModel.DataModuleDestroy(Sender: TObject);
begin
  Invoice.Close;
  Product.Close;
end;

end.
