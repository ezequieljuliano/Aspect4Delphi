unit Aspect4D.UnitTest.Entity;

interface

uses
  System.SysUtils,
  Aspect4D.UnitTest.Security,
  Aspect4D.UnitTest.Logging;

type

  TCarEntity = class
  private
    fAction: string;
  protected
    { protected declarations }
  public
    [Security('123')]
    procedure Insert; virtual;

    [Logging]
    [Security('123')]
    procedure Update; virtual;

    [Logging]
    [Security('123')]
    procedure Delete; virtual;

    [Logging]
    procedure View; virtual;

    [Logging]
    procedure ViewException; virtual;

    property Action: string read fAction;
  end;

implementation

{ TCarEntity }

procedure TCarEntity.Delete;
begin
  fAction := 'Car Deleted';
end;

procedure TCarEntity.Insert;
begin
  fAction := 'Car Inserted';
end;

procedure TCarEntity.Update;
begin
  fAction := 'Car Updated';
end;

procedure TCarEntity.View;
begin
  fAction := 'Car Viewed';
end;

procedure TCarEntity.ViewException;
begin
  raise Exception.Create('Error Message');
end;

end.
