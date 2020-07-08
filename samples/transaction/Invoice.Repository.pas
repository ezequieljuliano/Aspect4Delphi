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

unit Invoice.Repository;

interface

uses

  Invoice.Dto,
  Invoice.Model,
  Transactional.Attribute,
  App.Context;

type

  TInvoiceRepository = class
  private
    fInvoiceModel: TInvoiceModel;
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [Transactional]
    procedure Save(invoice: TInvoiceDto); virtual;
  end;

implementation

{ TInvoiceRepository }

constructor TInvoiceRepository.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
  fInvoiceModel := TInvoiceModel.Create(nil);
end;

destructor TInvoiceRepository.Destroy;
begin
  fInvoiceModel.Free;
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

procedure TInvoiceRepository.Save(invoice: TInvoiceDto);
var
  product: TProductDto;
begin
  fInvoiceModel.Invoice.Insert;
  fInvoiceModel.InvoiceINV_NUMBER.AsInteger := invoice.Number;
  fInvoiceModel.InvoiceINV_DATE.AsDateTime := invoice.Date;
  fInvoiceModel.InvoiceINV_CUSTOMER.AsString := invoice.Customer;
  fInvoiceModel.Invoice.Post;

  for product in invoice.Products do
  begin
    fInvoiceModel.Product.Insert;
    fInvoiceModel.ProductPRO_SKU.AsString := product.SKU;
    fInvoiceModel.ProductPRO_NAME.AsString := product.Name;
    fInvoiceModel.ProductPRO_PRICE.AsFloat := product.Price;
    fInvoiceModel.ProductPRO_INV_NUMBER.AsInteger := invoice.Number;
    fInvoiceModel.Product.Post;
  end;
end;

end.
