program Underscore.Delphi.Tests;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DUnitX.TestRunner,
  DUnitX.TestFramework,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.XML.NUnit,
  Underscore.Delphi.Test in 'Underscore.Delphi.Test.pas',
  Underscore.Delphi in '..\Underscore.Delphi.pas';

var
  runner: ITestRunner;
  results: IRunResults;
  logger: ITestLogger;
  xmlLogger: ITestLogger;

begin
  try
    runner := TDUnitX.CreateRunner;
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);

    xmlLogger := TDUnitXXMLNUnitFileLogger.Create;
    runner.AddLogger(xmlLogger);

    results := runner.Execute;

{$IFDEF CI}
    if not results.AllPassed then
      System.ExitCode := 1;
{$ELSE}
    System.Write('Done.. press <enter> key to quit.');
    System.Readln;
{$ENDIF}
  except
    on E: Exception do
    begin
      System.Writeln(E.ClassName, ': ', E.Message);
      System.ExitCode := 2;
    end;
  end;

end.
