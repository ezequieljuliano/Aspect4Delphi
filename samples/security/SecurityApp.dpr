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
