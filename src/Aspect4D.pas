unit Aspect4D;

interface

uses
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections;

type

  EAspectException = class(Exception);
  EAspectDoesNotImplementInterface = class(EAspectException);
  EAspectDoesNotInherited = class(EAspectException);

  AspectAttribute = class(TCustomAttribute);

  IAspect = interface
    ['{A4CD99F5-6374-47F2-B893-EEDD2C4FE24B}']
    procedure DoBefore(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pDoInvoke: Boolean;
      out pResult: TValue);

    procedure DoAfter(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; var pResult: TValue);

    procedure DoException(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pRaiseException: Boolean;
      pTheException: Exception; out pResult: TValue);
  end;

  TAspect = class abstract(TInterfacedObject)
  strict private
    { private declarations }
  strict protected
    { protected declarations }
  public
    { public declarations }
  end;

  TAspectClass = class of TAspect;

  IAspectWeaver = interface
    ['{45C3A48D-92DB-4993-BCD6-C8597C5700C2}']
    procedure Proxify(pInstance: TObject);
    procedure Unproxify(pInstance: TObject);
  end;

  Aspect = class sealed
  strict private
  const
    CanNotBeInstantiatedException = 'This class can not be instantiated!';
  strict private

    {$HINTS OFF}

    constructor Create;

    {$HINTS ON}

  public
    class function Weaver(): IAspectWeaver; static;
    class procedure &Register(pClass: TAspectClass); static;
  end;

implementation

type

  TAspectInterceptor = class sealed
  strict private
    FAspects: TDictionary<string, IAspect>;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure Add(const pQualifiedClassName: string; pAspect: IAspect);
    function Contains(const pQualifiedClassName: string): Boolean;

    procedure DoBefore(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pDoInvoke: Boolean;
      out pResult: TValue);

    procedure DoAfter(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; var pResult: TValue);

    procedure DoException(pInstance: TObject;
      pMethod: TRttiMethod; const pArgs: TArray<TValue>; out pRaiseException: Boolean;
      pTheException: Exception; out pResult: TValue);
  end;

  TAspectWeaver = class(TInterfacedObject, IAspectWeaver)
  strict private
    FVMIs: TObjectDictionary<string, TVirtualMethodInterceptor>;
    FInterceptor: TAspectInterceptor;
    procedure RegisterClass(pClass: TClass);
  public
    constructor Create(pInterceptor: TAspectInterceptor);
    destructor Destroy(); override;

    procedure Proxify(pInstance: TObject);
    procedure Unproxify(pInstance: TObject);
  end;

  TAspectContext = class sealed
  strict private
  const
    DoesNotImplementInterface = 'Aspect Class does not implement interface IAspect!';
    DoesNotInherited = 'Aspect Class does not inherited TAspect!';
  strict private
    FInterceptor: TAspectInterceptor;
    FWeaver: IAspectWeaver;
    function GetWeaver(): IAspectWeaver;
  public
    constructor Create();
    destructor Destroy(); override;

    procedure RegisterAspect(pClass: TAspectClass);

    property Weaver: IAspectWeaver read GetWeaver;
  end;

  TSingletonAspectContext = class sealed
  strict private
    class var Instance: TAspectContext;
    class constructor Create;
    class destructor Destroy;
  public
    class function GetInstance: TAspectContext; static;
  end;

  { TAspectInterceptor }

procedure TAspectInterceptor.Add(const pQualifiedClassName: string; pAspect: IAspect);
begin
  if not Contains(pQualifiedClassName) then
    FAspects.Add(pQualifiedClassName, pAspect);
end;

function TAspectInterceptor.Contains(const pQualifiedClassName: string): Boolean;
begin
  Result := FAspects.ContainsKey(pQualifiedClassName);
end;

constructor TAspectInterceptor.Create;
begin
  FAspects := TDictionary<string, IAspect>.Create;
end;

destructor TAspectInterceptor.Destroy;
begin
  FreeAndNil(FAspects);
  inherited;
end;

procedure TAspectInterceptor.DoAfter(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; var pResult: TValue);
var
  vAspectPair: TPair<string, IAspect>;
begin
  for vAspectPair in FAspects do
    vAspectPair.Value.DoAfter(pInstance, pMethod, pArgs, pResult);
end;

procedure TAspectInterceptor.DoBefore(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pDoInvoke: Boolean; out pResult: TValue);
var
  vAspectPair: TPair<string, IAspect>;
begin
  for vAspectPair in FAspects do
    vAspectPair.Value.DoBefore(pInstance, pMethod, pArgs, pDoInvoke, pResult);
end;

procedure TAspectInterceptor.DoException(pInstance: TObject; pMethod: TRttiMethod;
  const pArgs: TArray<TValue>; out pRaiseException: Boolean; pTheException: Exception;
  out pResult: TValue);
var
  vAspectPair: TPair<string, IAspect>;
begin
  for vAspectPair in FAspects do
    vAspectPair.Value.DoException(pInstance, pMethod, pArgs, pRaiseException, pTheException, pResult);
end;

{ TAspectWeaver }

constructor TAspectWeaver.Create(pInterceptor: TAspectInterceptor);
begin
  FVMIs := TObjectDictionary<string, TVirtualMethodInterceptor>.Create([doOwnsValues]);
  FInterceptor := pInterceptor;
end;

destructor TAspectWeaver.Destroy;
begin
  FreeAndNil(FVMIs);
  inherited;
end;

procedure TAspectWeaver.Proxify(pInstance: TObject);
begin
  RegisterClass(pInstance.ClassType);
  FVMIs.Items[pInstance.QualifiedClassName].Proxify(pInstance);
end;

procedure TAspectWeaver.RegisterClass(pClass: TClass);
var
  vVMI: TVirtualMethodInterceptor;
begin
  if not FVMIs.ContainsKey(pClass.QualifiedClassName) then
  begin
    vVMI := TVirtualMethodInterceptor.Create(pClass);
    vVMI.OnBefore := FInterceptor.DoBefore;
    vVMI.OnAfter := FInterceptor.DoAfter;
    vVMI.OnException := FInterceptor.DoException;
    FVMIs.Add(pClass.QualifiedClassName, vVMI);
  end;
end;

procedure TAspectWeaver.Unproxify(pInstance: TObject);
begin
  if FVMIs.ContainsKey(pInstance.QualifiedClassName) then
    FVMIs.Items[pInstance.QualifiedClassName].Unproxify(pInstance);
end;

{ TAspectContext }

constructor TAspectContext.Create;
begin
  FInterceptor := TAspectInterceptor.Create;
  FWeaver := TAspectWeaver.Create(FInterceptor);
end;

destructor TAspectContext.Destroy;
begin
  FWeaver := nil;
  FreeAndNil(FInterceptor);
  inherited;
end;

function TAspectContext.GetWeaver: IAspectWeaver;
begin
  Result := FWeaver;
end;

procedure TAspectContext.RegisterAspect(pClass: TAspectClass);
begin
  if not Supports(pClass, IAspect) then
    raise EAspectDoesNotImplementInterface.Create(DoesNotImplementInterface);

  if not FInterceptor.Contains(pClass.QualifiedClassName) then
    FInterceptor.Add(pClass.QualifiedClassName, (pClass.Create as IAspect));
end;

{ TSingletonAspectContext }

class constructor TSingletonAspectContext.Create;
begin
  Instance := TAspectContext.Create();
end;

class destructor TSingletonAspectContext.Destroy;
begin
  FreeAndNil(Instance);
end;

class function TSingletonAspectContext.GetInstance: TAspectContext;
begin
  Result := Instance;
end;

{ Aspect }

constructor Aspect.Create;
begin
  raise EAspectException.Create(CanNotBeInstantiatedException);
end;

class procedure Aspect.Register(pClass: TAspectClass);
begin
  TSingletonAspectContext.GetInstance.RegisterAspect(pClass);
end;

class function Aspect.Weaver: IAspectWeaver;
begin
  Result := TSingletonAspectContext.GetInstance.Weaver;
end;

end.
