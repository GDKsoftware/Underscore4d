unit Underscore.Delphi.Springless.Test;

interface

{$ifdef FPC}
uses
  fpcunit;
{$else}
uses
  DUnitX.TestFramework;
{$endif}

type
{$ifndef FPC}
  [TestFixture]
  TUnderscoreDelphiTest = class
  public
    [Test]
    procedure MapEmptyList;

    [Test]
    procedure Filter;

    [Test]
    procedure MapIntToStringList;

    [Test]
    procedure MapIntEnumerable;

    [Test]
    procedure ReduceEmptyList;

    [Test]
    procedure ReduceIntList;

    [Test]
    procedure ReduceIntListToString;

    [Test]
    procedure ReduceIntDictionary;

    [Test]
    procedure Find;

    [Test]
    procedure FindNothing;

    [Test]
    procedure FindOrDefault;

    [Test]
    procedure Join;

    [Test]
    procedure Intersection;

    [Test]
    procedure Difference;

    [Test]
    procedure Union;

    [Test]
    procedure EveryFalse;

    [Test]
    procedure EveryTrue;

    [Test]
    procedure EveryFalseTList;

    [Test]
    procedure Min;

    [Test]
    procedure Max;

    [Test]
    procedure Uniq;

    [Test]
    procedure MapDictionary;
  end;
{$else}
  TUnderscoreDelphiTest = class(TTestCase)
  published
    procedure MapEmptyList;
    procedure Filter;
    procedure MapIntToStringList;
    procedure MapIntEnumerable;
    procedure ReduceEmptyList;
    procedure ReduceIntList;
    procedure ReduceIntListToString;
    procedure ReduceIntDictionary;
    procedure Find;
    procedure FindNothing;
    procedure FindOrDefault;
    procedure Join;
    procedure Intersection;
    procedure Difference;
    procedure Union;
    procedure EveryFalse;
    procedure EveryTrue;
    procedure EveryFalseTList;
    procedure Min;
    procedure Max;
    procedure Uniq;
    procedure MapDictionary;
  end;

type
{$endif}

  TMyRec = record
    Id: Integer;
    SomeValue: Integer;

    class function New(const A, B: Integer): TMyRec; static;
  end;

implementation

{$ifdef FPC}
uses
  Underscore.Delphi.Springless,
  DUnitX.Stub,
  testregistry,
  Variants,
  Generics.Collections,
  SysUtils;
{$else}
uses
  Underscore.Delphi.Springless,
  Variants,
  System.Generics.Collections,
  System.SysUtils;
{$endif}

type
  TIntPair = TPair<Integer, Integer>;

{ Functions used as callbacks }

function IsEven(const Value: Integer): Boolean;
begin
  Result := Value mod 2 = 0;
end;

function ConstIntToStr(const Value: Integer): string;
begin
  Result := IntToStr(Value);
end;

function FormatPair(const Item: TPair<string, TMyRec>): string;
begin
  Result := Format('%s = (%2d,%2d)', [Item.Key, Item.Value.Id, Item.Value.SomeValue]);
end;

function AddAB(const A, B: Integer): Integer;
begin
  Result := A + B;
end;

function AddIntToCsvStr(const Current: string; const Item: Integer): string;
begin
  if Current.IsEmpty then
    Result := Item.ToString
  else
    Result := Current + ';' + Item.ToString;
end;

function IntPairAdd(const Current, Item: TIntPair): TIntPair;
begin
  Result.Value := Current.Value + Item.Value;
end;

function IsThree(const Value: Integer): Boolean;
begin
  Result := Value = 3;
end;

function SomeValueOfRec(const Item: TMyRec): Integer;
begin
  Result := Item.SomeValue;
end;

{ TUnderscoreDelphiTest }

procedure TUnderscoreDelphiTest.EveryFalse;
var
  List: TList<Integer>;
begin
  List := TList<Integer>.Create;
  List.Add(2);
  List.Add(4);
  List.Add(5);

  Assert.IsFalse(
    _.Every<Integer>(List, IsEven)
  );
end;

procedure TUnderscoreDelphiTest.EveryFalseTList;
var
  List: TList<Integer>;
begin
  List := TList<Integer>.Create;
  List.Add(2);
  List.Add(4);
  List.Add(5);

  Assert.IsFalse(
    _.Every<Integer>(List, IsEven)
  );
end;

procedure TUnderscoreDelphiTest.EveryTrue;
var
  List: TList<Integer>;
begin
  List := TList<Integer>.Create;
  List.Add(2);
  List.Add(4);
  List.Add(6);

  Assert.IsTrue(
    _.Every<Integer>(List, IsEven)
  );
end;

procedure TUnderscoreDelphiTest.Intersection;
var
  ListOne: TList<Integer>;
  ListTwo: TList<Integer>;
  Intersected: TList<Integer>;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(101);
  ListOne.Add(2);
  ListOne.Add(1);
  ListOne.Add(10);

  ListTwo := TList<Integer>.Create;
  ListTwo.Add(2);
  ListTwo.Add(1);

  Intersected := _.Intersection<Integer>(ListOne, ListTwo);

  Assert.AreEqual(2, Intersected.Count);
  Assert.IsTrue(Intersected.Contains(1));
  Assert.IsTrue(Intersected.Contains(2));
end;

procedure TUnderscoreDelphiTest.MapDictionary;
var
  Dict: TDictionary<string, TMyRec>;
  Mapped: TList<string>;
begin
  Dict := TDictionary<string, TMyRec>.Create;
  Dict.AddOrSetValue('hello', TMyRec.New(1, 2));
  Dict.AddOrSetValue('world', TMyRec.New(2, 3));
  Dict.AddOrSetValue('etc 123', TMyRec.New(4, 5));

  Mapped := _.Map<string, TMyRec, string>(Dict, FormatPair);

  // the order is not guaranteed, so we sort before testing
  Mapped.Sort;

  Assert.AreEqual('etc 123 = ( 4, 5)', Mapped[0]);
  Assert.AreEqual('hello = ( 1, 2)', Mapped[1]);
  Assert.AreEqual('world = ( 2, 3)', Mapped[2]);
end;

procedure TUnderscoreDelphiTest.MapEmptyList;
var
  ListOne: TList<Integer>;
  ListTwo: TList<string>;
begin
  ListOne := TList<Integer>.Create;

  ListTwo := _.Map<Integer, string>(ListOne, ConstIntToStr);

  Assert.AreEqual(ListTwo.Count, 0);
end;

procedure TUnderscoreDelphiTest.Filter;
var
  ListIn: TList<Integer>;
  ListOut: TList<Integer>;
begin
  ListIn := TList<Integer>.Create;
  ListIn.Add(101);
  ListIn.Add(2);
  ListIn.Add(1);
  ListIn.Add(10);

  ListOut := _.Filter<Integer>(ListIn, IsEven);

  Assert.AreEqual(2, ListOut.Count);
  Assert.IsTrue(ListOut.Contains(2));
  Assert.IsTrue(ListOut.Contains(10));
end;

procedure TUnderscoreDelphiTest.MapIntToStringList;
var
  ListOne: TList<Integer>;
  ListTwo: TList<string>;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(1);
  ListOne.Add(2);

  ListTwo := _.Map<Integer, string>(ListOne, ConstIntToStr);

  Assert.AreEqual(ListTwo.Count, 2);
  Assert.AreEqual(ListTwo[0], '1');
  Assert.AreEqual(ListTwo[1], '2');
end;

procedure TUnderscoreDelphiTest.MapIntEnumerable;
var
  ListOne: TStack<Integer>;
  ListTwo: TList<string>;
begin
  ListOne := TStack<Integer>.Create;
  ListOne.Push(1);
  ListOne.Push(2);

  ListTwo := _.Map<Integer, string>(ListOne, ConstIntToStr);

  Assert.AreEqual(ListTwo.Count, 2);
  Assert.AreEqual(ListTwo[0], '1');
  Assert.AreEqual(ListTwo[1], '2');
end;

procedure TUnderscoreDelphiTest.ReduceEmptyList;
var
  ListOne: TList<Integer>;
  Value: Integer;
begin
  ListOne := TList<Integer>.Create;

  Value := _.Reduce<Integer>(ListOne, AddAB, 0);

  Assert.AreEqual(Value, 0);
end;

procedure TUnderscoreDelphiTest.ReduceIntList;
var
  ListOne: TList<Integer>;
  Value: Integer;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(1);
  ListOne.Add(3);
  ListOne.Add(9);

  Value := _.Reduce<Integer>(ListOne, AddAB, 0);

  Assert.AreEqual(Value, 13);
end;

procedure TUnderscoreDelphiTest.ReduceIntListToString;
var
  ListOne: TList<Integer>;
  Value: string;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(1);
  ListOne.Add(3);
  ListOne.Add(9);

  Value := _.Reduce<Integer, string>(ListOne,
    AddIntToCsvStr,
    String.Empty);

  Assert.AreEqual(Value, '1;3;9');
end;

procedure TUnderscoreDelphiTest.ReduceIntDictionary;
var
  ListOne: TDictionary<Integer, Integer>;
  Value: TPair<Integer, Integer>;
begin
  ListOne := TDictionary<Integer, Integer>.Create;
  ListOne.AddOrSetValue(0, 4);
  ListOne.AddOrSetValue(1, 5);
  ListOne.AddOrSetValue(2, 2);

  Value := _.Reduce<Integer, Integer, TIntPair>(ListOne,
    IntPairAdd,
    TIntPair.Create(0, 0));

  Assert.AreEqual(Value.Value, 11);
end;

procedure TUnderscoreDelphiTest.Difference;
var
  ListOne: TList<Integer>;
  ListTwo: TList<Integer>;
  ResultSet: TList<Integer>;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(101);
  ListOne.Add(2);
  ListOne.Add(1);
  ListOne.Add(10);

  ListTwo := TList<Integer>.Create;
  ListTwo.Add(3);
  ListTwo.Add(2);
  ListTwo.Add(1);

  ResultSet := _.Difference<Integer>(ListOne, ListTwo);

  Assert.AreEqual(2, ResultSet.Count);
  Assert.IsTrue(ResultSet.Contains(101));
  Assert.IsTrue(ResultSet.Contains(10));
end;

procedure TUnderscoreDelphiTest.Union;
var
  ListOne: TList<Integer>;
  ListTwo: TList<Integer>;
  ResultSet: TList<Integer>;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(101);
  ListOne.Add(2);
  ListOne.Add(1);
  ListOne.Add(10);

  ListTwo := TList<Integer>.Create;
  ListTwo.Add(3);
  ListTwo.Add(2);
  ListTwo.Add(1);

  ResultSet := _.Union<Integer>(ListOne, ListTwo);

  Assert.AreEqual(5, ResultSet.Count);
  Assert.IsTrue(ResultSet.Contains(101));
  Assert.IsTrue(ResultSet.Contains(2));
  Assert.IsTrue(ResultSet.Contains(1));
  Assert.IsTrue(ResultSet.Contains(10));
  Assert.IsTrue(ResultSet.Contains(3));
end;

procedure TUnderscoreDelphiTest.Uniq;
var
  List: TList<Integer>;
  OutList: TList<Integer>;
begin
  List := TList<Integer>.Create;
  List.Add(1);
  List.Add(4);
  List.Add(4);
  List.Add(5);

  OutList := _.Uniq<Integer>(List);

  Assert.AreEqual(3, OutList.Count);
  Assert.AreEqual(1, OutList[0]);
  Assert.AreEqual(4, OutList[1]);
  Assert.AreEqual(5, OutList[2]);
end;

procedure TUnderscoreDelphiTest.Find;
var
  List: TList<Integer>;
  OutValue: Integer;
begin
  List := TList<Integer>.Create;
  List.Add(1);
  List.Add(4);
  List.Add(5);

  OutValue := _.Find<Integer>(List, IsEven);

  Assert.AreEqual(4, OutValue);
end;

procedure TUnderscoreDelphiTest.FindNothing;
var
  List: TList<Integer>;
begin
  List := TList<Integer>.Create;
  List.Add(1);
  List.Add(3);
  List.Add(5);

  try
    _.Find<Integer>(List, IsEven);
    Assert.Fail;
  except
    on E: Exception do
    begin
      Assert.Pass;
    end
  end;
end;

procedure TUnderscoreDelphiTest.FindOrDefault;
var
  List: TList<Integer>;
begin
  List := TList<Integer>.Create;
  List.Add(1);
  List.Add(3);
  List.Add(5);

  Assert.AreEqual(3,
    _.FindOrDefault<Integer>(List, IsThree, -1));

  Assert.AreEqual(-1,
    _.FindOrDefault<Integer>(List, IsEven, -1));
end;

procedure TUnderscoreDelphiTest.Join;
var
  InList: TList<Integer>;
  OutValue: string;
begin
  InList := TList<Integer>.Create;
  InList.Add(2);
  InList.Add(6);
  InList.Add(1);

  OutValue := _.Join<Integer>(InList, ConstIntToStr, ';');

  Assert.AreEqual('2;6;1', OutValue);
end;

procedure TUnderscoreDelphiTest.Max;
var
  List: TList<TMyRec>;
  OutValue: TMyRec;
  A, B, C: TMyRec;
begin
  A.Id := 1;
  A.SomeValue := 2;
  B.Id := 2;
  B.SomeValue := 6;
  C.Id := 3;
  C.SomeValue := 1;

  List := TList<TMyRec>.Create;
  List.Add(A);
  List.Add(B);
  List.Add(C);

  OutValue := _.Max<TMyRec>(List, SomeValueOfRec);

  Assert.AreEqual(B.Id, OutValue.Id);
  Assert.AreEqual(B.SomeValue, OutValue.SomeValue);
end;

procedure TUnderscoreDelphiTest.Min;
var
  List: TList<TMyRec>;
  OutValue: TMyRec;
  A, B, C: TMyRec;
begin
  A.Id := 1;
  A.SomeValue := 2;
  B.Id := 2;
  B.SomeValue := 6;
  C.Id := 3;
  C.SomeValue := 1;

  List := TList<TMyRec>.Create;
  List.Add(A);
  List.Add(B);
  List.Add(C);

  OutValue := _.Min<TMyRec>(List, SomeValueOfRec);

  Assert.AreEqual(C.Id, OutValue.Id);
  Assert.AreEqual(C.SomeValue, OutValue.SomeValue);
end;

{ TMyRec }

class function TMyRec.New(const A, B: Integer): TMyRec;
begin
  Result.Id := A;
  Result.SomeValue := B;
end;

initialization
{$ifdef FPC}
  RegisterTest(TUnderscoreDelphiTest);
{$else}
  TDUnitX.RegisterTestFixture(TUnderscoreDelphiTest);
{$endif}
end.
