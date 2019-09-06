// ***************************************************************************
//
// Aspect For Delphi
//
// Copyright (c) 2015-2019 Ezequiel Juliano Müller
//
// ***************************************************************************
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// ***************************************************************************

unit Global.Context;

interface

uses

  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Aspect.Context;

function LoggingFile: TStringList;
function AspectContext: IAspectContext;

implementation

uses

  Logging.Aspect;

const

  LoggingFileName = 'Logging.log';

var

  CurrentLoggingFile: TStringList;
  CurrentAspectContext: IAspectContext = nil;

function LoggingFile: TStringList;
begin
  Result := CurrentLoggingFile;
end;

function AspectContext: IAspectContext;
begin
  if (CurrentAspectContext = nil) then
  begin
    CurrentAspectContext := TAspectContextFactory.New;
    CurrentAspectContext.Register(TLoggingAspect.Create);
  end;
  Result := CurrentAspectContext;
end;

function GetLoggingFileName: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + LoggingFileName;
end;

procedure InitializeLoggingFile;
begin
  CurrentLoggingFile := TStringList.Create;
  if TFile.Exists(GetLoggingFileName) then
    CurrentLoggingFile.LoadFromFile(GetLoggingFileName);
end;

procedure FinalizeLoggingFile;
begin
  if TFile.Exists(GetLoggingFileName) then
    TFile.Delete(GetLoggingFileName);
  CurrentLoggingFile.SaveToFile(GetLoggingFileName);
  CurrentLoggingFile.Free;
end;

initialization

InitializeLoggingFile;

finalization

FinalizeLoggingFile;

end.
