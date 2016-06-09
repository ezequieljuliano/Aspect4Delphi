unit Aspect4D.UnitTest.Logging;

interface

uses
  Aspect4D,
  System.Rtti,
  System.SysUtils,
  System.Classes;

type

  ELoggingException = class(Exception);

  LoggingAttribute = class(AspectAttribute);

  TLoggingAspect = class(TAspect, IAspect)
  public
    procedure DoBefore(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out invoke: Boolean; out result: TValue);

    procedure DoAfter(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; var result: TValue);

    procedure DoException(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out raiseException: Boolean;
      theException: Exception; out result: TValue);
  end;

function GlobalLoggingList: TStringList;

implementation

var
  _LoggingList: TStringList;

function GlobalLoggingList: TStringList;
begin
  Result := _LoggingList;
end;

{ TLoggingAspect }

procedure TLoggingAspect.DoAfter(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; var result: TValue);
var
  att: TCustomAttribute;
begin
  for att in method.GetAttributes do
    if att is LoggingAttribute then
      GlobalLoggingList.Add('After ' + instance.QualifiedClassName + ' - ' + method.Name);
end;

procedure TLoggingAspect.DoBefore(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  att: TCustomAttribute;
begin
  for att in method.GetAttributes do
    if att is LoggingAttribute then
      GlobalLoggingList.Add('Before ' + instance.QualifiedClassName + ' - ' + method.Name);
end;

procedure TLoggingAspect.DoException(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out raiseException: Boolean;
  theException: Exception; out result: TValue);
var
  att: TCustomAttribute;
begin
  for att in method.GetAttributes do
    if att is LoggingAttribute then
      GlobalLoggingList.Add('Exception ' + instance.QualifiedClassName + ' - ' + method.Name + ' - ' + theException.Message);
end;

initialization

_LoggingList := TStringList.Create;

finalization

_LoggingList.Free;

end.
