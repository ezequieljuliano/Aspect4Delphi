unit App.Context;

interface

uses

  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Aspect,
  Aspect.Context;

function LoggingFile: TStringList;
function AspectContext: IAspectContext;

implementation

uses

  Logging.Aspect;

const

  LoggingFileName = 'Logging.log';

var

  LoggingFileInstance: TStringList;
  AspectContextInstance: IAspectContext = nil;

function LoggingFile: TStringList;
begin
  Result := LoggingFileInstance;
end;

function AspectContext: IAspectContext;
begin
  if (AspectContextInstance = nil) then
  begin
    AspectContextInstance := TAspectContext.Create;
    AspectContextInstance.RegisterAspect(TLoggingAspect.Create);
  end;
  Result := AspectContextInstance;
end;

function GetLoggingFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + LoggingFileName;
end;

procedure InitializeLoggingFile;
begin
  LoggingFileInstance := TStringList.Create;
  if TFile.Exists(GetLoggingFileName) then
    LoggingFileInstance.LoadFromFile(GetLoggingFileName);
end;

procedure FinalizeLoggingFile;
begin
  if TFile.Exists(GetLoggingFileName) then
    TFile.Delete(GetLoggingFileName);
  LoggingFileInstance.SaveToFile(GetLoggingFileName);
  LoggingFileInstance.Free;
end;

initialization

InitializeLoggingFile;

finalization

FinalizeLoggingFile;

end.
