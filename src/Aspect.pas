unit Aspect;

interface

uses

  System.SysUtils,
  System.Rtti;

type

  IAspect = interface
    ['{7647B37E-7BEA-42BD-ADEE-E719AF3C6CE9}']
    function GetName: string;

    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      );

    procedure OnAfter(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      var result: TValue
      );

    procedure OnException(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out raiseException: Boolean;
      theException: Exception;
      out result: TValue
      );

    property Name: string read GetName;
  end;

  IAspectWeaver = interface
    ['{211E40BC-753F-4865-BB35-9CF81F1435C7}']
    procedure Proxify(instance: TObject);
    procedure Unproxify(instance: TObject);
  end;

  IAspectContext = interface
    ['{962E0295-9091-41CA-AF39-F6FD41174231}']
    procedure RegisterAspect(aspect: IAspect);
    function Weaver: IAspectWeaver;
  end;

implementation

end.
