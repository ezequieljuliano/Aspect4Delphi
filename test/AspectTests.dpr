program AspectTests;

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
  Aspect in '..\src\Aspect.pas',
  Aspect.Core in '..\src\Aspect.Core.pas',
  Aspect.Weaver in '..\src\Aspect.Weaver.pas',
  Aspect.Interceptor in '..\src\Aspect.Interceptor.pas',
  Aspect.Context in '..\src\Aspect.Context.pas',
  Aspect.Test in 'Aspect.Test.pas';

{$R *.RES}

begin

  ReportMemoryLeaksOnShutdown := True;

  DUnitTestRunner.RunRegisteredTests;

end.
