unit RequiredRole.Aspect;

interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect,
  Aspect.Core,
  RequiredRole.Attribute,
  App.Context;

type

  ERequiredRoleAspectException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TRequiredRoleAspect = class(TAspectObject, IAspect)
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
  public
    { public declarations }
  end;

implementation

{ TRequiredRoleAspect }

procedure TRequiredRoleAspect.OnBefore(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is RequiredRoleAttribute then
    begin
      if (CurrentSecurityRole <> 'ROLE_ADMIN') then
        if (CurrentSecurityRole <> RequiredRoleAttribute(attribute).Role) then
          raise ERequiredRoleAspectException.Create('You do not have permission.');
    end;
end;

end.
