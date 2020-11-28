unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Email.Message, WhatsApp.Message,
  Vcl.StdCtrls;

type

  TMainView = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    fEmailMessage: TEmailMessage;
    fWhatsAppMessage: TWhatsAppMessage;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.Button1Click(Sender: TObject);
begin
  fEmailMessage.Send;
end;

procedure TMainView.Button2Click(Sender: TObject);
begin
  fWhatsAppMessage.Send;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  fEmailMessage := TEmailMessage.Create;
  fWhatsAppMessage := TWhatsAppMessage.Create;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fEmailMessage.Free;
  fWhatsAppMessage.Free;
end;

end.
