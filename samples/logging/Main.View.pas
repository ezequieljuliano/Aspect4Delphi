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

unit Main.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Email.Message, WhatsApp.Message,
  Vcl.StdCtrls;

type

  TMainView = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    fEmailMessage: TEmailMessage;
    fWhatsAppMessage: TWhatsAppMessage;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

{$R *.dfm}

procedure TMainView.Button1Click(Sender: TObject);
begin
  fEmailMessage.Send;
end;

procedure TMainView.Button2Click(Sender: TObject);
begin
  fWhatsAppMessage.Send;
end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  fEmailMessage := TEmailMessage.Create;
  fWhatsAppMessage := TWhatsAppMessage.Create;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  fEmailMessage.Free;
  fWhatsAppMessage.Free;
end;

end.
