unit App.Context;

interface

uses

  Aspect,
  Aspect.Context;

function AspectContext: IAspectContext;

implementation

uses

  Transactional.Aspect;

var

  AspectContextInstance: IAspectContext = nil;

function AspectContext: IAspectContext;
begin
  if (AspectContextInstance = nil) then
  begin
    AspectContextInstance := TAspectContext.Create;
    AspectContextInstance.RegisterAspect(TTransactionalAspect.Create);
  end;
  Result := AspectContextInstance;
end;

end.
