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

unit Aspect.Weaver;

interface

uses

  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  Aspect,
  Aspect.Interceptor;

type

  TAspectWeaver = class(TInterfacedObject, IAspectWeaver)
  private
    fMethodsInterceptor: TObjectDictionary<string, TVirtualMethodInterceptor>;
    fAspectInterceptor: TAspectInterceptor;
    procedure RegisterClass(registrationClass: TClass);
  protected
    procedure Proxify(instance: TObject);
    procedure Unproxify(instance: TObject);
  public
    constructor Create(interceptor: TAspectInterceptor);
    destructor Destroy; override;
  end;

implementation

{ TAspectWeaver }

constructor TAspectWeaver.Create(interceptor: TAspectInterceptor);
begin
  inherited Create;
  fMethodsInterceptor := TObjectDictionary<string, TVirtualMethodInterceptor>.Create([doOwnsValues]);
  fAspectInterceptor := interceptor;
end;

destructor TAspectWeaver.Destroy;
begin
  fMethodsInterceptor.Free;
  inherited Destroy;
end;

procedure TAspectWeaver.Proxify(instance: TObject);
begin
  RegisterClass(instance.ClassType);
  fMethodsInterceptor.Items[instance.QualifiedClassName].Proxify(instance);
end;

procedure TAspectWeaver.RegisterClass(registrationClass: TClass);
var
  methodInterceptor: TVirtualMethodInterceptor;
begin
  if not fMethodsInterceptor.ContainsKey(registrationClass.QualifiedClassName) then
  begin
    methodInterceptor := TVirtualMethodInterceptor.Create(registrationClass);
    methodInterceptor.OnBefore := fAspectInterceptor.OnBefore;
    methodInterceptor.OnAfter := fAspectInterceptor.OnAfter;
    methodInterceptor.OnException := fAspectInterceptor.OnException;
    fMethodsInterceptor.Add(registrationClass.QualifiedClassName, methodInterceptor);
  end;
end;

procedure TAspectWeaver.Unproxify(instance: TObject);
begin
  if fMethodsInterceptor.ContainsKey(instance.QualifiedClassName) then
    fMethodsInterceptor.Items[instance.QualifiedClassName].Unproxify(instance);
end;

end.
