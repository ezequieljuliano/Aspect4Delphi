unit Aspect4D.UnitTest.Security;

interface

uses
  Aspect4D,
  System.Rtti,
  System.SysUtils;

type

  ESecurityException = class(Exception);

  SecurityAttribute = class(AspectAttribute)
  private
    fPassword: string;
  protected
    { protected declarations }
  public
    constructor Create(const password: string);
    property Password: string read fPassword;
  end;

  TSecurityAspect = class(TAspect, IAspect)
  private
    { private declarations }
  protected
    function GetName: string;

    procedure DoBefore(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out invoke: Boolean; out result: TValue);

    procedure DoAfter(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; var result: TValue);

    procedure DoException(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out raiseException: Boolean;
      theException: Exception; out result: TValue);
  public
    { public declarations }
  end;

var
  GlobalPasswordSystem: string = '';

implementation

{ SecurityAttribute }

constructor SecurityAttribute.Create(const password: string);
begin
  fPassword := password;
end;

{ TSecurityAspect }

procedure TSecurityAspect.DoAfter(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; var result: TValue);
begin
  // Method unused
end;

procedure TSecurityAspect.DoBefore(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  att: TCustomAttribute;
begin
  for att in method.GetAttributes do
    if att is SecurityAttribute then
      if (GlobalPasswordSystem <> SecurityAttribute(att).Password) then
        raise ESecurityException.Create('The password is invalid!');
end;

procedure TSecurityAspect.DoException(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out raiseException: Boolean;
  theException: Exception; out result: TValue);
begin
  // Method unused
end;

function TSecurityAspect.GetName: string;
begin
  Result := Self.QualifiedClassName;
end;

end.
