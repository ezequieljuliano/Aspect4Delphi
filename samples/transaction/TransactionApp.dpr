program TransactionApp;

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView},
  DB.Connection in 'DB.Connection.pas' {DBConnection: TDataModule},
  Invoice.Model in 'Invoice.Model.pas' {InvoiceModel: TDataModule},
  Transactional.Attribute in 'Transactional.Attribute.pas',
  Transactional.Aspect in 'Transactional.Aspect.pas',
  App.Context in 'App.Context.pas',
  Invoice.Dto in 'Invoice.Dto.pas',
  Invoice.Repository in 'Invoice.Repository.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDBConnection, DBConnection);
  Application.CreateForm(TMainView, MainView);
  Application.Run;

end.
