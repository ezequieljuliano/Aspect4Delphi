unit Aspect.Context;

interface

uses

  Aspect,
  Aspect.Weaver,
  Aspect.Interceptor;

type

  TAspectContext = class(TInterfacedObject, IAspectContext)
  private
    fInterceptor: TAspectInterceptor;
    fWeaver: IAspectWeaver;
  protected
    procedure RegisterAspect(aspect: IAspect);
    function Weaver: IAspectWeaver;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAspectContext }

constructor TAspectContext.Create;
begin
  inherited Create;
  fInterceptor := TAspectInterceptor.Create;
  fWeaver := TAspectWeaver.Create(fInterceptor);
end;

destructor TAspectContext.Destroy;
begin
  fInterceptor.Free;
  inherited Destroy;
end;

procedure TAspectContext.RegisterAspect(aspect: IAspect);
begin
  if not fInterceptor.Contains(aspect.Name) then
    fInterceptor.Add(aspect.Name, aspect);
end;

function TAspectContext.Weaver: IAspectWeaver;
begin
  Result := fWeaver;
end;

end.
