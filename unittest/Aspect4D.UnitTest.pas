unit Aspect4D.UnitTest;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  Aspect4D,
  Aspect4D.UnitTest.Security,
  Aspect4D.UnitTest.Logging;

type

  TCar = class
  strict private
    FAction: string;
  public
    constructor Create;
    destructor Destroy; override;

    [Security('123')]
    procedure Insert(); virtual;

    [Logging]
    [Security('123')]
    procedure Update(); virtual;

    [Logging]
    [Security('123')]
    procedure Delete(); virtual;

    [Logging]
    procedure View(); virtual;

    [Logging]
    procedure ViewException(); virtual;

    property Action: string read FAction;
  end;

  TTestAspect4D = class(TTestCase)
  private
    procedure CarInsert();
    procedure CarUpdate();
    procedure CarDelete();
    procedure CarView();
    procedure CarViewException();
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSecurityAspect();
    procedure TestLoggingAspect();
    procedure TestSecurityAndLoggingAspect();
  end;

implementation

{ TTestAspect4D }

procedure TTestAspect4D.CarDelete;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.Delete;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestAspect4D.CarInsert;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.Insert;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestAspect4D.CarUpdate;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.Update;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestAspect4D.CarView;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.View;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestAspect4D.CarViewException;
var
  vCar: TCar;
begin
  vCar := TCar.Create;
  try
    vCar.ViewException;
  finally
    FreeAndNil(vCar);
  end;
end;

procedure TTestAspect4D.SetUp;
begin
  inherited;

end;

procedure TTestAspect4D.TearDown;
begin
  inherited;

end;

procedure TTestAspect4D.TestLoggingAspect;
const
  cExpected = 'Before Aspect4D.UnitTest.TCar - View' + sLineBreak +
    'After Aspect4D.UnitTest.TCar - View' + sLineBreak;

  cExpectedException = 'Before Aspect4D.UnitTest.TCar - ViewException' + sLineBreak +
    'Exception Aspect4D.UnitTest.TCar - ViewException - Error Message' + sLineBreak;
begin
  GlobalLoggingList.Clear;
  CarView();
  CheckEqualsString(cExpected, GlobalLoggingList.Text);

  GlobalLoggingList.Clear;
  CheckException(CarViewException, Exception);
  CheckEqualsString(cExpectedException, GlobalLoggingList.Text);
end;

procedure TTestAspect4D.TestSecurityAndLoggingAspect;
const
  cExpectedUpdate = 'Before Aspect4D.UnitTest.TCar - Update' + sLineBreak +
    'After Aspect4D.UnitTest.TCar - Update' + sLineBreak;

  cExpectedDelete = 'Before Aspect4D.UnitTest.TCar - Delete' + sLineBreak +
    'After Aspect4D.UnitTest.TCar - Delete' + sLineBreak;
begin
  GlobalPasswordSystem := '123';

  GlobalLoggingList.Clear;
  CarUpdate();
  CheckEqualsString(cExpectedUpdate, GlobalLoggingList.Text);

  GlobalLoggingList.Clear;
  CarDelete();
  CheckEqualsString(cExpectedDelete, GlobalLoggingList.Text);
end;

procedure TTestAspect4D.TestSecurityAspect;
begin
  GlobalPasswordSystem := '321';
  CheckException(CarInsert, ESecurityException);

  GlobalPasswordSystem := '123';
  CarInsert();
end;

{ TCar }

constructor TCar.Create;
begin
  Aspect.Weaver.Proxify(Self);
end;

destructor TCar.Destroy;
begin
  Aspect.Weaver.Unproxify(Self);
  inherited;
end;

procedure TCar.Delete;
begin
  FAction := 'Car Deleted';
end;

procedure TCar.Insert;
begin
  FAction := 'Car Inserted';
end;

procedure TCar.Update;
begin
  FAction := 'Car Updated';
end;

procedure TCar.View;
begin
  FAction := 'Car Viewed';
end;

procedure TCar.ViewException;
begin
  raise Exception.Create('Error Message');
end;

initialization

RegisterTest(TTestAspect4D.Suite);

end.
