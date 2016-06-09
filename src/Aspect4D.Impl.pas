unit Aspect4D.Impl;

interface

uses
  System.SysUtils,
  System.Rtti,
  System.Generics.Collections,
  Aspect4D;

type

  TAspectInterceptor = class
  private
    fAspects: TDictionary<string, IAspect>;
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(const qualifiedClassName: string; aspect: IAspect);
    function Contains(const qualifiedClassName: string): Boolean;

    procedure DoBefore(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out invoke: Boolean; out result: TValue);

    procedure DoAfter(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; var result: TValue);

    procedure DoException(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out raiseException: Boolean;
      theException: Exception; out result: TValue);
  end;

  TAspectWeaver = class(TInterfacedObject, IAspectWeaver)
  private
    fVMIs: TObjectDictionary<string, TVirtualMethodInterceptor>;
    fInterceptor: TAspectInterceptor;
    procedure RegisterObjectClass(objectClass: TClass);
  protected
    procedure Proxify(instance: TObject);
    procedure Unproxify(instance: TObject);
  public
    constructor Create(interceptor: TAspectInterceptor);
    destructor Destroy; override;
  end;

  TAspectContext = class(TInterfacedObject, IAspectContext)
  private
    const
    DOES_NOT_IMPLEMENT_INTERFACE = 'Aspect Class does not implement interface IAspect.';
  private
    fInterceptor: TAspectInterceptor;
    fWeaver: IAspectWeaver;
  protected
    procedure &Register(aspectClass: TAspectClass);
    function Weaver: IAspectWeaver;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAspectInterceptor }

procedure TAspectInterceptor.Add(const qualifiedClassName: string; aspect: IAspect);
begin
  fAspects.AddOrSetValue(qualifiedClassName, aspect);
end;

function TAspectInterceptor.Contains(const qualifiedClassName: string): Boolean;
begin
  Result := fAspects.ContainsKey(qualifiedClassName);
end;

constructor TAspectInterceptor.Create;
begin
  inherited Create;
  fAspects := TDictionary<string, IAspect>.Create;
end;

destructor TAspectInterceptor.Destroy;
begin
  fAspects.Free;
  inherited Destroy;
end;

procedure TAspectInterceptor.DoAfter(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; var result: TValue);
var
  aspectPair: TPair<string, IAspect>;
begin
  for aspectPair in fAspects do
    aspectPair.Value.DoAfter(instance, method, args, result);
end;

procedure TAspectInterceptor.DoBefore(instance: TObject; method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  aspectPair: TPair<string, IAspect>;
begin
  for aspectPair in fAspects do
    aspectPair.Value.DoBefore(instance, method, args, invoke, result);
end;

procedure TAspectInterceptor.DoException(instance: TObject; method: TRttiMethod; const args: TArray<TValue>;
  out raiseException: Boolean; theException: Exception; out result: TValue);
var
  aspectPair: TPair<string, IAspect>;
begin
  for aspectPair in fAspects do
    aspectPair.Value.DoException(instance, method, args, raiseException, theException, result);
end;

{ TAspectWeaver }

constructor TAspectWeaver.Create(interceptor: TAspectInterceptor);
begin
  inherited Create;
  fVMIs := TObjectDictionary<string, TVirtualMethodInterceptor>.Create([doOwnsValues]);
  fInterceptor := interceptor;
end;

destructor TAspectWeaver.Destroy;
begin
  fVMIs.Free;
  inherited;
end;

procedure TAspectWeaver.Proxify(instance: TObject);
begin
  RegisterObjectClass(instance.ClassType);
  fVMIs.Items[instance.QualifiedClassName].Proxify(instance);
end;

procedure TAspectWeaver.RegisterObjectClass(objectClass: TClass);
var
  newVMI: TVirtualMethodInterceptor;
begin
  if not fVMIs.ContainsKey(objectClass.QualifiedClassName) then
  begin
    newVMI := TVirtualMethodInterceptor.Create(objectClass);
    newVMI.OnBefore := fInterceptor.DoBefore;
    newVMI.OnAfter := fInterceptor.DoAfter;
    newVMI.OnException := fInterceptor.DoException;
    fVMIs.Add(objectClass.QualifiedClassName, newVMI);
  end;
end;

procedure TAspectWeaver.Unproxify(instance: TObject);
begin
  if fVMIs.ContainsKey(instance.QualifiedClassName) then
    fVMIs.Items[instance.QualifiedClassName].Unproxify(instance);
end;

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

procedure TAspectContext.Register(aspectClass: TAspectClass);
begin
  if not Supports(aspectClass, IAspect) then
    raise EAspectException.Create(DOES_NOT_IMPLEMENT_INTERFACE);

  if not fInterceptor.Contains(aspectClass.QualifiedClassName) then
    fInterceptor.Add(aspectClass.QualifiedClassName, (aspectClass.Create as IAspect));
end;

function TAspectContext.Weaver: IAspectWeaver;
begin
  Result := fWeaver;
end;

end.
