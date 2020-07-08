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

unit WhatsApp.Message;

interface

uses

  System.SysUtils,
  Logging.Attribute,
  App.Context;

type

  EWhatsAppMessageException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TWhatsAppMessage = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    constructor Create;
    destructor Destroy; override;

    [Logging]
    procedure Send; virtual;
  end;

implementation

{ TWhatsAppMessage }

constructor TWhatsAppMessage.Create;
begin
  inherited Create;
  AspectContext.Weaver.Proxify(Self);
end;

destructor TWhatsAppMessage.Destroy;
begin
  AspectContext.Weaver.Unproxify(Self);
  inherited Destroy;
end;

procedure TWhatsAppMessage.Send;
begin
  raise EWhatsAppMessageException.Create('Error sending message with WhatsApp.');
end;

end.
