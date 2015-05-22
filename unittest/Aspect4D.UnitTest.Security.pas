unit Aspect4D.UnitTest.Security;

interface

uses
  Aspect4D,
  System.Rtti,
  System.SysUtils;

type

  ESecurityException = class(Exception);

  SecurityAttribute = class(AspectAttribute)
  strict private
    FPassword: string;
  public
    constructor Create(const pPassword: string);

    property Password: string read FPassword;
  end;

  TSecurityAspect = class(TAspect, IAspect)
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

var
  GlobalPasswordSystem: string;

implementation

{ SecurityAttribute }

constructor SecurityAttribute.Create(const pPassword: string);
begin
  FPassword := pPassword;
end;

{ TSecurityAspect }

procedure TSecurityAspect.DoAfter(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; var pResult: TValue);
begin
  //
end;

procedure TSecurityAspect.DoBefore(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pDoInvoke: Boolean; out pResult: TValue);
var
  vAtt: TCustomAttribute;
begin
  for vAtt in pMethod.GetAttributes do
    if vAtt is SecurityAttribute then
      if (GlobalPasswordSystem <> SecurityAttribute(vAtt).Password) then
        raise ESecurityException.Create('The password is invalid!');
end;

procedure TSecurityAspect.DoException(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pRaiseException: Boolean; pTheException: Exception;
  out pResult: TValue);
begin
  //
end;

initialization

Aspect.Register(TSecurityAspect);

end.
