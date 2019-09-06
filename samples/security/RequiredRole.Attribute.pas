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

unit RequiredRole.Attribute;

interface

uses

  Aspect.Core;

type

  RequiredRoleAttribute = class(AspectAttribute)
  private
    fRole: string;
  protected
    { protected declarations }
  public
    constructor Create(const role: string);

    property Role: string read fRole;
  end;

implementation

{ RequiredRoleAttribute }

constructor RequiredRoleAttribute.Create(const role: string);
begin
  inherited Create;
  fRole := role;
end;

end.
