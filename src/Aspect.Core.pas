unit Aspect.Core;

interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect;

type

  EAspectException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  AspectAttribute = class(TCustomAttribute)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TAspectObject = class abstract(TInterfacedObject, IAspect)
  private
    { private declarations }
  protected
    function GetName: string;

    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      ); virtual;

    procedure OnAfter(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      var result: TValue
      ); virtual;

    procedure OnException(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out raiseException: Boolean;
      theException: Exception;
      out result: TValue
      ); virtual;
  public
    { public declarations }
  end;

implementation

{ TAspectObject }

procedure TAspectObject.OnAfter(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; var result: TValue);
begin
  // implemented if necessary in the aspects
end;

procedure TAspectObject.OnBefore(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out invoke: Boolean; out result: TValue);
begin
  // implemented if necessary in the aspects
end;

procedure TAspectObject.OnException(instance: TObject; method: TRttiMethod;
  const args: TArray<TValue>; out raiseException: Boolean;
  theException: Exception; out result: TValue);
begin
  // implemented if necessary in the aspects
end;

function TAspectObject.GetName: string;
begin
  Result := Self.QualifiedClassName;
end;

end.
