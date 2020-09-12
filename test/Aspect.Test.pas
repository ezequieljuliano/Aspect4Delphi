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

unit Aspect.Test;

interface

uses

  Aspect,
  Aspect.Core,
  Aspect.Context,
  TestFramework,
  System.Rtti,
  System.SysUtils,
  System.Classes;

type

  TTestAspect = class(TTestCase)
  private type

    EMockAspectException = class(Exception)
    private
      { private declarations }
    protected
      { protected declarations }
    public
      { public declarations }
    end;

    MockAspectAttribute = class(AspectAttribute)
    private
      { private declarations }
    protected
      { protected declarations }
    public
      { public declarations }
    end;

    TMockAspect = class(TAspectObject, IAspect)
    private
      fAspectTestCase: TTestAspect;
    protected
      constructor Create(aspectTestCase: TTestAspect);

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

    TMockObject = class
    private
      { private declarations }
    protected
      { protected declarations }
    public
      [MockAspect]
      procedure Execute; virtual;

      [MockAspect]
      procedure ExecuteWithException; virtual;

      procedure ExecuteWithoutAspect; virtual;
    end;

  private
    fAspectContext: IAspectContext;
    fMockObject: TMockObject;
  protected
    fAspectCurrentEvent: string;
    fAspectAfterEvent: Boolean;
    fAspectBeforeEvent: Boolean;
    fAspectExceptionEvent: Boolean;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMockedExecute;
    procedure TestMockedExecuteWithException;
    procedure TestMockedExecuteWithoutAspect;
  end;

implementation

{ TTestAspect }

procedure TTestAspect.SetUp;
begin
  inherited;
  fAspectCurrentEvent := '';
  fAspectAfterEvent := False;
  fAspectBeforeEvent := False;
  fAspectExceptionEvent := False;

  fAspectContext := TAspectContext.Create;
  fAspectContext.RegisterAspect(TMockAspect.Create(Self));
  fMockObject := TMockObject.Create;
  fAspectContext.Weaver.Proxify(fMockObject);
end;

procedure TTestAspect.TearDown;
begin
  inherited;
  fAspectContext.Weaver.Unproxify(fMockObject);
  fMockObject.Free;
  fAspectContext := nil;
end;

procedure TTestAspect.TestMockedExecute;
begin
  fMockObject.Execute;
  CheckTrue(fAspectAfterEvent);
  CheckTrue(fAspectBeforeEvent);
  CheckFalse(fAspectExceptionEvent);
  CheckEqualsString('After the execution of Aspect.Test.TTestAspect.TMockObject.Execute', fAspectCurrentEvent);
end;

procedure TTestAspect.TestMockedExecuteWithException;
begin
  CheckException(fMockObject.ExecuteWithException, TTestAspect.EMockAspectException);
  CheckFalse(fAspectAfterEvent);
  CheckTrue(fAspectBeforeEvent);
  CheckTrue(fAspectExceptionEvent);
  CheckEqualsString('Exception in executing Aspect.Test.TTestAspect.TMockObject.ExecuteWithException: Mock aspect exception', fAspectCurrentEvent);
end;

procedure TTestAspect.TestMockedExecuteWithoutAspect;
begin
  fMockObject.ExecuteWithoutAspect;
  CheckFalse(fAspectAfterEvent);
  CheckFalse(fAspectBeforeEvent);
  CheckFalse(fAspectExceptionEvent);
  CheckEqualsString('', fAspectCurrentEvent);
end;

{ TTestAspect.TMockAspect }

procedure TTestAspect.TMockAspect.OnAfter(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>; var result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is MockAspectAttribute then
    begin
      fAspectTestCase.fAspectAfterEvent := True;
      fAspectTestCase.fAspectCurrentEvent := 'After the execution of ' + instance.QualifiedClassName + '.' + method.Name;
      Break;
    end;
end;

procedure TTestAspect.TMockAspect.OnBefore(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is MockAspectAttribute then
    begin
      fAspectTestCase.fAspectBeforeEvent := True;
      fAspectTestCase.fAspectCurrentEvent := 'Before the execution of ' + instance.QualifiedClassName + '.' + method.Name;
      Break;
    end;
end;

constructor TTestAspect.TMockAspect.Create(aspectTestCase: TTestAspect);
begin
  fAspectTestCase := aspectTestCase;
end;

procedure TTestAspect.TMockAspect.OnException(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>;
  out raiseException: Boolean; theException: Exception;
  out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is MockAspectAttribute then
    begin
      fAspectTestCase.fAspectExceptionEvent := True;
      fAspectTestCase.fAspectCurrentEvent := 'Exception in executing ' + instance.QualifiedClassName + '.' + method.Name + ': ' + theException.Message;
      Break;
    end;
end;

{ TTestAspect.TMockObject }

procedure TTestAspect.TMockObject.Execute;
begin
end;

procedure TTestAspect.TMockObject.ExecuteWithException;
begin
  raise EMockAspectException.Create('Mock aspect exception');
end;

procedure TTestAspect.TMockObject.ExecuteWithoutAspect;
begin
end;

initialization

RegisterTest(TTestAspect.Suite);

end.
