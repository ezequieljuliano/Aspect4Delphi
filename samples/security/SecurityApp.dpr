program SecurityApp;

uses
  Vcl.Forms,
  Main.View in 'Main.View.pas' {MainView},
  Person.Repository in 'Person.Repository.pas',
  Person in 'Person.pas',
  RequiredRole.Attribute in 'RequiredRole.Attribute.pas',
  RequiredRole.Aspect in 'RequiredRole.Aspect.pas',
  App.Context in 'App.Context.pas';

{$R *.res}

begin

  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;

end.
