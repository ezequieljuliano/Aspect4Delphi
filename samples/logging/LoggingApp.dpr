program LoggingApp;

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView},
  App.Context in 'App.Context.pas',
  Logging.Attribute in 'Logging.Attribute.pas',
  Logging.Aspect in 'Logging.Aspect.pas',
  Email.Message in 'Email.Message.pas',
  WhatsApp.Message in 'WhatsApp.Message.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;

end.
