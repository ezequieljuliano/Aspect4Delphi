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
    procedure DoBefore(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pDoInvoke: Boolean;
      out pResult: TValue);

    procedure DoAfter(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; var pResult: TValue);

    procedure DoException(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pRaiseException: Boolean;
      pTheException: Exception; out pResult: TValue);
  end;

function GlobalLoggingList: TStringList;

implementation

var
  _vLoggingList: TStringList;

function GlobalLoggingList: TStringList;
begin
  Result := _vLoggingList;
end;

{ TLoggingAspect }

procedure TLoggingAspect.DoAfter(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; var pResult: TValue);
var
  vAtt: TCustomAttribute;
begin
  for vAtt in pMethod.GetAttributes do
    if vAtt is LoggingAttribute then
      GlobalLoggingList.Add('After ' + pInstance.QualifiedClassName + ' - ' + pMethod.Name);
end;

procedure TLoggingAspect.DoBefore(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pDoInvoke: Boolean; out pResult: TValue);
var
  vAtt: TCustomAttribute;
begin
  for vAtt in pMethod.GetAttributes do
    if vAtt is LoggingAttribute then
      GlobalLoggingList.Add('Before ' + pInstance.QualifiedClassName + ' - ' + pMethod.Name);
end;

procedure TLoggingAspect.DoException(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pRaiseException: Boolean; pTheException: Exception;
  out pResult: TValue);
var
  vAtt: TCustomAttribute;
begin
  for vAtt in pMethod.GetAttributes do
    if vAtt is LoggingAttribute then
      GlobalLoggingList.Add('Exception ' + pInstance.QualifiedClassName + ' - ' + pMethod.Name + ' - ' + pTheException.Message);
end;

initialization

Aspect.Register(TLoggingAspect);

_vLoggingList := TStringList.Create;

finalization

FreeAndNil(_vLoggingList);

end.
