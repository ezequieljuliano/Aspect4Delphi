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

unit Invoice.Dto;

interface

uses

  System.Generics.Collections;

type

  TProductDto = class
  private
    fSKU: string;
    fName: string;
    fPrice: Double;
  protected
    { protected declarations }
  public
    constructor Create; overload;
    constructor Create(sku: string; name: string; price: Double); overload;

    property SKU: string read fSKU write fSKU;
    property Name: string read fName write fName;
    property Price: Double read fPrice write fPrice;
  end;

  TInvoiceDto = class
  private
    fNumber: Integer;
    fDate: TDate;
    fCustomer: string;
    fProducts: TObjectList<TProductDto>;
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    property Number: Integer read fNumber write fNumber;
    property Date: TDate read fDate write fDate;
    property Customer: string read fCustomer write fCustomer;
    property Products: TObjectList<TProductDto> read fProducts;
  end;

implementation

{ TInvoiceDto }

constructor TInvoiceDto.Create;
begin
  inherited Create;
  fProducts := TObjectList<TProductDto>.Create(True);
end;

destructor TInvoiceDto.Destroy;
begin
  fProducts.Free;
  inherited Destroy;
end;

{ TProductDto }

constructor TProductDto.Create(sku, name: string; price: Double);
begin
  Create;
  fSKU := sku;
  fName := name;
  fPrice := price;
end;

constructor TProductDto.Create;
begin
  inherited Create;
end;

end.
