unit DUnitX.Stub;

interface

uses
  fpcunit;

type
  Assert = class
  public
    class procedure IsTrue(const Value: Boolean);
    class procedure IsFalse(const Value: Boolean);
    class procedure AreEqual(const Expected, Value: Integer); overload;
    class procedure AreEqual(const Expected, Value: string); overload;
    class procedure Pass;
    class procedure Fail;
  end;

implementation

uses
  testutils,
  SysUtils;

class procedure Assert.IsTrue(const Value: Boolean);
begin
  TAssert.AssertTrue(Value);
end;

class procedure Assert.IsFalse(const Value: Boolean);
begin
  TAssert.AssertFalse(Value);
end;

class procedure Assert.AreEqual(const Expected, Value: Integer); overload;
begin
  TAssert.AssertEquals(Expected, Value);
end;

class procedure Assert.AreEqual(const Expected, Value: string); overload;
begin
  TAssert.AssertEquals(Expected, Value);
end;

class procedure Assert.Pass;
begin
  // do nothing
end;

class procedure Assert.Fail;
begin
  TAssert.Fail('Failed');
end;

end.