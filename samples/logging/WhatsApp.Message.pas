unit WhatsApp.Message;

interface

uses

  System.SysUtils,
  Logging.Attribute,
  App.Context;

type

  EWhatsAppMessageException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TWhatsAppMessage = class
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

{ TWhatsAppMessage }

constructor TWhatsAppMessage.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
end;

destructor TWhatsAppMessage.Destroy;
begin
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

procedure TWhatsAppMessage.Send;
begin
  raise EWhatsAppMessageException.Create('Error sending message with WhatsApp.');
end;

end.
