unit App.Context;

interface

uses

  Aspect,
  Aspect.Context;

var

  CurrentSecurityRole: string = '';

function AspectContext: IAspectContext;

implementation

uses

  RequiredRole.Aspect;

var

  AspectContextInstance: IAspectContext = nil;

function AspectContext: IAspectContext;
begin
  if (AspectContextInstance = nil) then
  begin
    AspectContextInstance := TAspectContext.Create;
    AspectContextInstance.RegisterAspect(TRequiredRoleAspect.Create);
  end;
  Result := AspectContextInstance;
end;

end.
