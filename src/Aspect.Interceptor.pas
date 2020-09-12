// ***************************************************************************
//
// Aspect For Delphi
//
// Copyright (c) 2015-2020 Ezequiel Juliano Müller
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

unit Aspect.Interceptor;

interface

uses

  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  Aspect;

type

  TAspectInterceptor = class
  private
    fAspects: TDictionary<string, IAspect>;
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const name: string; aspect: IAspect);
    function Contains(const name: string): Boolean;

    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      );

    procedure OnAfter(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      var result: TValue
      );

    procedure OnException(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out raiseException: Boolean;
      theException: Exception;
      out result: TValue
      );
  end;

implementation

{ TAspectInterceptor }

procedure TAspectInterceptor.Add(const name: string; aspect: IAspect);
begin
  fAspects.AddOrSetValue(name, aspect);
end;

procedure TAspectInterceptor.OnAfter(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; var result: TValue);
var
  aspectPair: TPair<string, IAspect>;
begin
  for aspectPair in fAspects do
    aspectPair.Value.OnAfter(instance, method, args, result);
end;

procedure TAspectInterceptor.OnBefore(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out invoke: Boolean; out result: TValue);
var
  aspectPair: TPair<string, IAspect>;
begin
  for aspectPair in fAspects do
    aspectPair.Value.OnBefore(instance, method, args, invoke, result);
end;

function TAspectInterceptor.Contains(const name: string): Boolean;
begin
  Result := fAspects.ContainsKey(name);
end;

constructor TAspectInterceptor.Create;
begin
  inherited Create;
  fAspects := TDictionary<string, IAspect>.Create;
end;

destructor TAspectInterceptor.Destroy;
begin
  fAspects.Free;
  inherited Destroy;
end;

procedure TAspectInterceptor.OnException(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>;
  out raiseException: Boolean; theException: Exception;
  out result: TValue);
var
  aspectPair: TPair<string, IAspect>;
begin
  for aspectPair in fAspects do
    aspectPair.Value.OnException(instance, method, args, raiseException, theException, result);
end;

end.
