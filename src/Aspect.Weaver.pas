unit Aspect.Weaver;

interface

uses

  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  Aspect,
  Aspect.Interceptor;

type

  TAspectWeaver = class(TInterfacedObject, IAspectWeaver)
  private
    fMethodsInterceptor: TObjectDictionary<string, TVirtualMethodInterceptor>;
    fAspectInterceptor: TAspectInterceptor;
    procedure RegisterClass(registrationClass: TClass);
  protected
    procedure Proxify(instance: TObject);
    procedure Unproxify(instance: TObject);
  public
    constructor Create(interceptor: TAspectInterceptor);
    destructor Destroy; override;
  end;

implementation

{ TAspectWeaver }

constructor TAspectWeaver.Create(interceptor: TAspectInterceptor);
begin
  inherited Create;
  fMethodsInterceptor := TObjectDictionary<string, TVirtualMethodInterceptor>.Create([doOwnsValues]);
  fAspectInterceptor := interceptor;
end;

destructor TAspectWeaver.Destroy;
begin
  fMethodsInterceptor.Free;
  inherited Destroy;
end;

procedure TAspectWeaver.Proxify(instance: TObject);
begin
  RegisterClass(instance.ClassType);
  fMethodsInterceptor.Items[instance.QualifiedClassName].Proxify(instance);
end;

procedure TAspectWeaver.RegisterClass(registrationClass: TClass);
var
  methodInterceptor: TVirtualMethodInterceptor;
begin
  if not fMethodsInterceptor.ContainsKey(registrationClass.QualifiedClassName) then
  begin
    methodInterceptor := TVirtualMethodInterceptor.Create(registrationClass);
    methodInterceptor.OnBefore := fAspectInterceptor.OnBefore;
    methodInterceptor.OnAfter := fAspectInterceptor.OnAfter;
    methodInterceptor.OnException := fAspectInterceptor.OnException;
    fMethodsInterceptor.Add(registrationClass.QualifiedClassName, methodInterceptor);
  end;
end;

procedure TAspectWeaver.Unproxify(instance: TObject);
begin
  if fMethodsInterceptor.ContainsKey(instance.QualifiedClassName) then
    fMethodsInterceptor.Items[instance.QualifiedClassName].Unproxify(instance);
end;

end.
