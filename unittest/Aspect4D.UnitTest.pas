unit Aspect4D.UnitTest;

interface

uses
  TestFramework,
  System.Classes,
  System.SysUtils,
  Aspect4D,
  Aspect4D.Impl,
  Aspect4D.UnitTest.Security,
  Aspect4D.UnitTest.Logging,
  Aspect4D.UnitTest.Entity;

type

  TTestAspect4D = class(TTestCase)
  private
    fAspectContext: IAspectContext;
    fCarEntity: TCarEntity;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSecurityAspect;
    procedure TestLoggingAspect;
    procedure TestSecurityAndLoggingAspect;
  end;

implementation

{ TTestAspect4D }

procedure TTestAspect4D.SetUp;
begin
  inherited;
  fAspectContext := TAspectContext.Create;
  fAspectContext.Register(TLoggingAspect);
  fAspectContext.Register(TSecurityAspect);

  fCarEntity := TCarEntity.Create;
  fAspectContext.Weaver.Proxify(fCarEntity);
end;

procedure TTestAspect4D.TearDown;
begin
  inherited;
  fAspectContext.Weaver.Unproxify(fCarEntity);
  fCarEntity.Free;
end;

procedure TTestAspect4D.TestLoggingAspect;
const
  EXPECTED = 'Before Aspect4D.UnitTest.Entity.TCarEntity - View' + sLineBreak +
    'After Aspect4D.UnitTest.Entity.TCarEntity - View' + sLineBreak;

  EXPECTED_EXCEPTION = 'Before Aspect4D.UnitTest.Entity.TCarEntity - ViewException' + sLineBreak +
    'Exception Aspect4D.UnitTest.Entity.TCarEntity - ViewException - Error Message' + sLineBreak;
begin
  GlobalLoggingList.Clear;
  fCarEntity.View;
  CheckEqualsString(EXPECTED, GlobalLoggingList.Text);

  GlobalLoggingList.Clear;
  CheckException(fCarEntity.ViewException, Exception);
  CheckEqualsString(EXPECTED_EXCEPTION, GlobalLoggingList.Text);
end;

procedure TTestAspect4D.TestSecurityAndLoggingAspect;
const
  EXPECTED_UPDATE = 'Before Aspect4D.UnitTest.Entity.TCarEntity - Update' + sLineBreak +
    'After Aspect4D.UnitTest.Entity.TCarEntity - Update' + sLineBreak;

  EXPECTED_DELETE = 'Before Aspect4D.UnitTest.Entity.TCarEntity - Delete' + sLineBreak +
    'After Aspect4D.UnitTest.Entity.TCarEntity - Delete' + sLineBreak;
begin
  GlobalPasswordSystem := '123';

  GlobalLoggingList.Clear;
  fCarEntity.Update;
  CheckEqualsString(EXPECTED_UPDATE, GlobalLoggingList.Text);

  GlobalLoggingList.Clear;
  fCarEntity.Delete;
  CheckEqualsString(EXPECTED_DELETE, GlobalLoggingList.Text);
end;

procedure TTestAspect4D.TestSecurityAspect;
begin
  GlobalPasswordSystem := '321';
  CheckException(fCarEntity.Insert, ESecurityException);

  GlobalPasswordSystem := '123';
  fCarEntity.Insert;
end;

initialization

RegisterTest(TTestAspect4D.Suite);

end.
