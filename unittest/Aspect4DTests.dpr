program Aspect4DTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  Aspect4D.UnitTest in 'Aspect4D.UnitTest.pas',
  Aspect4D in '..\src\Aspect4D.pas',
  Aspect4D.UnitTest.Security in 'Aspect4D.UnitTest.Security.pas',
  Aspect4D.UnitTest.Logging in 'Aspect4D.UnitTest.Logging.pas';

{$R *.RES}

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
