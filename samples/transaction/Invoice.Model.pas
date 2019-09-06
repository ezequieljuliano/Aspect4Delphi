// ***************************************************************************
//
// Aspect For Delphi
//
// Copyright (c) 2015-2019 Ezequiel Juliano Müller
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

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
