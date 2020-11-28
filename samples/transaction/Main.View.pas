unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Invoice.Dto, Invoice.Repository,
  Vcl.StdCtrls;

type

  TMainView = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fInvoiceRepository: TInvoiceRepository;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.Button1Click(Sender: TObject);
var
  invoice: TInvoiceDto;
  I: Integer;
begin
  invoice := TInvoiceDto.Create;
  try
    invoice.Number := Random(5000);
    invoice.Date := Date;
    invoice.Customer := 'Ezequiel';

    for I := 1 to 10 do
      invoice.Products.Add(TProductDto.Create('SKU' + Random(5000).ToString, 'Product ' + I.ToString, 5.00));

    fInvoiceRepository.Save(invoice);
  finally
    invoice.Free;
  end;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  fInvoiceRepository := TInvoiceRepository.Create;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fInvoiceRepository.Free;
end;

end.
