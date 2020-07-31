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

unit Aspect.Weaver;

interface

uses

  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  Aspect.Interceptor;

type

  IAspectWeaver = interface
    ['{211E40BC-753F-4865-BB35-9CF81F1435C7}']
    procedure Proxify(instance: TObject);
    procedure Unproxify(instance: TObject);
  end;

  TAspectWeaverFactory = record
  public
    class function NewAspectWeaver(interceptor: TAspectInterceptor): IAspectWeaver; static;
  end;

implementation

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
    methodInterceptor.OnBefore := fAspectInterceptor.Before;
    methodInterceptor.OnAfter := fAspectInterceptor.After;
    methodInterceptor.OnException := fAspectInterceptor.Exception;
    fMethodsInterceptor.Add(registrationClass.QualifiedClassName, methodInterceptor);
  end;
end;

procedure TAspectWeaver.Unproxify(instance: TObject);
begin
  if fMethodsInterceptor.ContainsKey(instance.QualifiedClassName) then
    fMethodsInterceptor.Items[instance.QualifiedClassName].Unproxify(instance);
end;

{ TAspectWeaverFactory }

class function TAspectWeaverFactory.NewAspectWeaver(interceptor: TAspectInterceptor): IAspectWeaver;
begin
  Result := TAspectWeaver.Create(interceptor);
end;

end.
