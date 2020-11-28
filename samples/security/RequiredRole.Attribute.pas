unit RequiredRole.Attribute;

interface

uses

  Aspect.Core;

type

  RequiredRoleAttribute = class(AspectAttribute)
  private
    fRole: string;
  protected
    { protected declarations }
  public
    constructor Create(const role: string);

    property Role: string read fRole;
  end;

implementation

{ RequiredRoleAttribute }

constructor RequiredRoleAttribute.Create(const role: string);
begin
  inherited Create;
  fRole := role;
end;

end.
