unit Email.Message;

interface

uses

  Logging.Attribute,
  App.Context;

type

  TEmailMessage = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [Logging]
    procedure Send; virtual;
  end;

implementation

{ TEmailMessage }

constructor TEmailMessage.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
end;

destructor TEmailMessage.Destroy;
begin
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

procedure TEmailMessage.Send;
begin
  // Message sent successfully.
end;

end.
