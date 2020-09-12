// ***************************************************************************
//
// Aspect For Delphi
//
// Copyright (c) 2015-2020 Ezequiel Juliano Müller
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

unit Aspect.Context;

interface

uses

  Aspect,
  Aspect.Weaver,
  Aspect.Interceptor;

type

  TAspectContext = class(TInterfacedObject, IAspectContext)
  private
    fInterceptor: TAspectInterceptor;
    fWeaver: IAspectWeaver;
  protected
    procedure RegisterAspect(aspect: IAspect);
    function Weaver: IAspectWeaver;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TAspectContext }

constructor TAspectContext.Create;
begin
  inherited Create;
  fInterceptor := TAspectInterceptor.Create;
  fWeaver := TAspectWeaver.Create(fInterceptor);
end;

destructor TAspectContext.Destroy;
begin
  fInterceptor.Free;
  inherited Destroy;
end;

procedure TAspectContext.RegisterAspect(aspect: IAspect);
begin
  if not fInterceptor.Contains(aspect.Name) then
    fInterceptor.Add(aspect.Name, aspect);
end;

function TAspectContext.Weaver: IAspectWeaver;
begin
  Result := fWeaver;
end;

end.
