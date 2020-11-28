unit Invoice.Repository;

interface

uses

  Invoice.Dto,
  Invoice.Model,
  Transactional.Attribute,
  App.Context;

type

  TInvoiceRepository = class
  private
    fInvoiceModel: TInvoiceModel;
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [Transactional]
    procedure Save(invoice: TInvoiceDto); virtual;
  end;

implementation

{ TInvoiceRepository }

constructor TInvoiceRepository.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
  fInvoiceModel := TInvoiceModel.Create(nil);
end;

destructor TInvoiceRepository.Destroy;
begin
  fInvoiceModel.Free;
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

procedure TInvoiceRepository.Save(invoice: TInvoiceDto);
var
  product: TProductDto;
begin
  fInvoiceModel.Invoice.Insert;
  fInvoiceModel.InvoiceINV_NUMBER.AsInteger := invoice.Number;
  fInvoiceModel.InvoiceINV_DATE.AsDateTime := invoice.Date;
  fInvoiceModel.InvoiceINV_CUSTOMER.AsString := invoice.Customer;
  fInvoiceModel.Invoice.Post;

  for product in invoice.Products do
  begin
    fInvoiceModel.Product.Insert;
    fInvoiceModel.ProductPRO_SKU.AsString := product.SKU;
    fInvoiceModel.ProductPRO_NAME.AsString := product.Name;
    fInvoiceModel.ProductPRO_PRICE.AsFloat := product.Price;
    fInvoiceModel.ProductPRO_INV_NUMBER.AsInteger := invoice.Number;
    fInvoiceModel.Product.Post;
  end;
end;

end.
