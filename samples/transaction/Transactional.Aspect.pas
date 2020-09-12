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

unit Transactional.Aspect;

interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect,
  Aspect.Core,
  Transactional.Attribute,
  DB.Connection;

type

  ETransactionalAspectException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TTransactionalAspect = class(TAspectObject, IAspect)
  private
    { private declarations }
  protected
    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      ); override;

    procedure OnAfter(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      var result: TValue
      ); override;

    procedure OnException(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out raiseException: Boolean;
      theException: Exception;
      out result: TValue
      ); override;
  public
    { public declarations }
  end;

implementation

{ TTransactionalAspect }

procedure TTransactionalAspect.OnAfter(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>; var result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is TransactionalAttribute then
    begin
      DBConnection.FDConnection.Commit;
      Break;
    end;
end;

procedure TTransactionalAspect.OnBefore(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is TransactionalAttribute then
    begin
      DBConnection.FDConnection.StartTransaction;
      Break;
    end;
end;

procedure TTransactionalAspect.OnException(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>;
  out raiseException: Boolean; theException: Exception;
  out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is TransactionalAttribute then
    begin
      DBConnection.FDConnection.Rollback;
      Break;
    end;
end;

end.
