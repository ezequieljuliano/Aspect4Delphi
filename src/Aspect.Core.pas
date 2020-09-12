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

unit Aspect.Core;

interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect;

type

  EAspectException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  AspectAttribute = class(TCustomAttribute)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TAspectObject = class abstract(TInterfacedObject, IAspect)
  private
    { private declarations }
  protected
    function GetName: string;

    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      ); virtual;

    procedure OnAfter(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      var result: TValue
      ); virtual;

    procedure OnException(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out raiseException: Boolean;
      theException: Exception;
      out result: TValue
      ); virtual;
  public
    { public declarations }
  end;

implementation

{ TAspectObject }

procedure TAspectObject.OnAfter(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; var result: TValue);
begin
  // implemented if necessary in the aspects
end;

procedure TAspectObject.OnBefore(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out invoke: Boolean; out result: TValue);
begin
  // implemented if necessary in the aspects
end;

procedure TAspectObject.OnException(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out raiseException: Boolean;
  theException: Exception; out result: TValue);
begin
  // implemented if necessary in the aspects
end;

function TAspectObject.GetName: string;
begin
  Result := Self.QualifiedClassName;
end;

end.
