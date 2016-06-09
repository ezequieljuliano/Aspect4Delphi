unit Aspect4D;

interface

uses
  System.SysUtils,
  System.Rtti;

type

  EAspectException = class(Exception);

  AspectAttribute = class(TCustomAttribute);

  TAspect = class abstract(TInterfacedObject)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TAspectClass = class of TAspect;

  IAspect = interface
    ['{7647B37E-7BEA-42BD-ADEE-E719AF3C6CE9}']
    procedure DoBefore(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out invoke: Boolean; out result: TValue);

    procedure DoAfter(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; var result: TValue);

    procedure DoException(instance: TObject; method: TRttiMethod;
      const args: TArray<TValue>; out raiseException: Boolean;
      theException: Exception; out result: TValue);
  end;

  IAspectWeaver = interface
    ['{211E40BC-753F-4865-BB35-9CF81F1435C7}']
    procedure Proxify(instance: TObject);
    procedure Unproxify(instance: TObject);
  end;

  IAspectContext = interface
    ['{962E0295-9091-41CA-AF39-F6FD41174231}']
    procedure &Register(aspectClass: TAspectClass);
    function Weaver: IAspectWeaver;
  end;

implementation

end.
