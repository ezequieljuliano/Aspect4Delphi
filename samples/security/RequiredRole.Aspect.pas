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

unit RequiredRole.Aspect;

interface

uses

  System.SysUtils,
  System.Rtti,
  Aspect,
  Aspect.Core,
  RequiredRole.Attribute,
  App.Context;

type

  ERequiredRoleAspectException = class(Exception)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

  TRequiredRoleAspect = class(TAspectObject, IAspect)
  private
    { private declarations }
  protected
    procedure OnBefore(
      instance: TObject;
      method: TRttiMethod;
      const args: TArray<TValue>;
      out invoke: Boolean;
      out result: TValue
      ); override;
  public
    { public declarations }
  end;

implementation

{ TRequiredRoleAspect }

procedure TRequiredRoleAspect.OnBefore(instance: TObject;
  method: TRttiMethod; const args: TArray<TValue>; out invoke: Boolean;
  out result: TValue);
var
  attribute: TCustomAttribute;
begin
  inherited;
  for attribute in method.GetAttributes do
    if attribute is RequiredRoleAttribute then
    begin
      if (CurrentSecurityRole <> 'ROLE_ADMIN') then
        if (CurrentSecurityRole <> RequiredRoleAttribute(attribute).Role) then
          raise ERequiredRoleAspectException.Create('You do not have permission.');
    end;
end;

end.
