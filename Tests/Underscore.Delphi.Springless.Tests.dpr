program Underscore.Delphi.Springless.Tests;

{$APPTYPE CONSOLE}

uses
  SysUtils,
{$ifdef FPC}
  consoletestrunner,
  DUnitX.Stub in './DUnitX.Stub.pas',
{$else}
  DUnitX.TestRunner,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.XML.NUnit,
{$endif}
  Underscore.Delphi.Springless in '../Underscore.Delphi.Springless.pas',
  Underscore.Delphi.Springless.Test;

var
{$ifdef FPC}
  App: TTestRunner;
{$else}
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  xmlLogger: ITestLogger;
{$endif}

begin
{$ifdef FPC}
  App := TTestRunner.Create(nil);
  App.Initialize;
  App.Title := 'FPCUnit Console runner.';
  App.Run;
  App.Free;
{$else}
  try
    runner := TDUnitX.CreateRunner;
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);

    xmlLogger := TDUnitXXMLNUnitFileLogger.Create;
    runner.AddLogger(xmlLogger);

    results := runner.Execute;

    if not results.AllPassed then
      System.ExitCode := 1;
  except
    on E: Exception do
    begin
      System.Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := 2;
    end;
  end;
{$endif}
end.
