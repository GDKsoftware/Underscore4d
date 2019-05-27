unit Underscore.Delphi.Test;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TUnderscoreDelphiTest = class
  public
    [Test]
    procedure MapEmptyList;

    [Test]
    procedure MapEmptySpringList;

    [Test]
    procedure MapIntToStringList;

    [Test]
    procedure MapIntEnumerable;

    [Test]
    procedure MapPInt;

    [Test]
    procedure ReduceEmptyList;

    [Test]
    procedure ReduceIntList;

    [Test]
    procedure ReduceIntListToString;

    [Test]
    procedure ReduceIntDictionary;

    [Test]
    procedure Zip;

    [Test]
    procedure Test123;

    [Test]
    procedure IntersectionEmpty;

    [Test]
    procedure Intersection;
  end;

implementation

uses
  Underscore.Delphi,
  Variants,
  Spring.Collections,
  System.Generics.Collections,
  System.SysUtils;

{ TUnderscoreDelphiTest }

procedure TUnderscoreDelphiTest.IntersectionEmpty;
var
  ListOne: IList<Integer>;
  ListTwo: IList<Integer>;
  Intersected: IList<Integer>;
begin
  ListOne := TCollections.CreateList<Integer>;
  ListTwo := TCollections.CreateList<Integer>;

  Intersected := _.Intersection<Integer>(ListOne, ListTwo);

  Assert.AreEqual(0, Intersected.Count);
end;

procedure TUnderscoreDelphiTest.Intersection;
var
  ListOne: IList<Integer>;
  ListTwo: IList<Integer>;
  Intersected: IList<Integer>;
begin
  ListOne := TCollections.CreateList<Integer>;
  ListOne.Add(101);
  ListOne.Add(2);
  ListOne.Add(1);
  ListOne.Add(10);

  ListTwo := TCollections.CreateList<Integer>;
  ListTwo.Add(2);
  ListTwo.Add(1);

  Intersected := _.Intersection<Integer>(ListOne, ListTwo);

  Assert.AreEqual(2, Intersected.Count);
  Assert.IsTrue(Intersected.Contains(1));
  Assert.IsTrue(Intersected.Contains(2));
end;

procedure TUnderscoreDelphiTest.MapEmptyList;
var
  ListOne: TList<Integer>;
  ListTwo: TList<string>;
begin
  ListOne := TList<Integer>.Create;

  ListTwo := _.Map<Integer, string>(ListOne,
    function(Item: Integer): string
    begin
      Result := Item.ToString;
    end);

  Assert.AreEqual(ListTwo.Count, 0);
end;

procedure TUnderscoreDelphiTest.MapEmptySpringList;
var
  ListOne: IList<Integer>;
  ListTwo: IList<string>;
begin
  ListOne := TCollections.CreateList<Integer>;

  ListTwo := _.Map<Integer, string>(ListOne,
    function(Item: Integer): string
    begin
      Result := Item.ToString;
    end);

  Assert.AreEqual(ListTwo.Count, 0);
end;

procedure TUnderscoreDelphiTest.MapIntToStringList;
var
  ListOne: TList<Integer>;
  ListTwo: TList<string>;
begin
  ListOne := TList<Integer>.Create;
  ListOne.Add(1);
  ListOne.Add(2);

  ListTwo := _.Map<Integer, string>(ListOne,
    function(Item: Integer): string
    begin
      Result := Item.ToString;
    end);

  Assert.AreEqual(ListTwo.Count, 2);
  Assert.AreEqual(ListTwo[0], '1');
  Assert.AreEqual(ListTwo[1], '2');
end;

procedure TUnderscoreDelphiTest.MapPInt;
var
  ListOne: IList<Integer>;
  ListTwo: IList<string>;
  Idx: Integer;
begin
  ListOne := TCollections.CreateList<Integer>;
  for Idx := 0 to 65535 do
  begin
    ListOne.Add(Idx);
  end;

  ListTwo := _.MapP<Integer, string>(ListOne,
    function(Item: Integer): string
    begin
      Result := Item.ToString;
    end);

  Assert.AreEqual(ListTwo.Count, ListOne.Count);
  Assert.AreEqual(ListTwo[0], '0');
  Assert.AreEqual(ListTwo[1], '1');
  Assert.AreEqual(ListTwo[3333], '3333');
  Assert.AreEqual(ListTwo[9999], '9999');
  Assert.AreEqual(ListTwo[ListTwo.Count - 1], (ListTwo.Count - 1).ToString);
end;

procedure TUnderscoreDelphiTest.MapIntEnumerable;
var
  ListOne: TStack<Integer>;
  ListTwo: TList<string>;
begin
  ListOne := TStack<Integer>.Create;
  ListOne.Push(1);
  ListOne.Push(2);

  ListTwo := _.Map<Integer, string>(ListOne,
    function(Item: Integer): string
    begin
      Result := Item.ToString;
    end);

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

  Value := _.Reduce<Integer>(ListOne,
    function(Current, Item: Integer): Integer
    begin
      Result := Current + Item;
    end,
    0);

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

  Value := _.Reduce<Integer>(ListOne,
    function(Current, Item: Integer): Integer
    begin
      Result := Current + Item;
    end,
    0);

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
    function(Current: string; Item: Integer): string
    begin
      if Current.IsEmpty then
        Result := Item.ToString
      else
        Result := Current + ';' + Item.ToString;
    end,
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

  Value := _.Reduce<TPair<Integer, Integer>>(ListOne,
    function(Current, Item: TPair<Integer, Integer>): TPair<Integer, Integer>
    begin
      Current.Value := Current.Value + Item.Value;
      Result := Current;
    end,
    TPair<Integer, Integer>.Create(0, 0));

  Assert.AreEqual(Value.Value, 11);
end;

procedure TUnderscoreDelphiTest.Zip;
var
  Lists: TList<TList<Variant>>;
  ZippedList: TList<TList<Variant>>;
begin
  Lists := TList<TList<Variant>>.Create;
  Lists.Add(TList<Variant>.Create);
  Lists.Add(TList<Variant>.Create);
  Lists.Add(TList<Variant>.Create);
  Lists.Add(TList<Variant>.Create);

  Lists[0].AddRange(['moe', 'larry', 'curly']);
  Lists[1].AddRange([30, 40, 50]);
  Lists[2].AddRange([true, false, false]);
  Lists[3].AddRange(['perry', 'mary', 'zeke']);

  ZippedList := _.Zip<Variant>(Lists);
  Assert.AreEqual(3, ZippedList.Count);

  Assert.AreEqual('moe', VarToStr(ZippedList[0][0]));
  Assert.AreEqual('30', VarToStr(ZippedList[0][1]));
  Assert.AreEqual('True', VarToStr(ZippedList[0][2]));
  Assert.AreEqual('perry', VarToStr(ZippedList[0][3]));

  Assert.AreEqual('larry', VarToStr(ZippedList[1][0]));
  Assert.AreEqual('40', VarToStr(ZippedList[1][1]));
  Assert.AreEqual('False', VarToStr(ZippedList[1][2]));
  Assert.AreEqual('mary', VarToStr(ZippedList[1][3]));

  Assert.AreEqual('curly', VarToStr(ZippedList[2][0]));
  Assert.AreEqual('50', VarToStr(ZippedList[2][1]));
  Assert.AreEqual('False', VarToStr(ZippedList[2][2]));
  Assert.AreEqual('zeke', VarToStr(ZippedList[2][3]));
end;

procedure TUnderscoreDelphiTest.Test123;
var
  InList: IList<Integer>;
  OutValue: string;
  MappedList: IList<String>;
begin
  InList := TCollections.CreateList<Integer>;
  InList.Add(2);
  InList.Add(6);
  InList.Add(1);

  MappedList := _.Map<Integer, string>(
    InList,
    function(Value: Integer): string
    begin
      Result := Value.ToString;
    end);

  OutValue := _.Reduce<string>(MappedList,
    function(Current, Value: string): string
    begin
      if Current.IsEmpty then
        Result := Value
      else
        Result := Current + ';' + Value;
    end,
    String.Empty);

  Assert.AreEqual('2;6;1', OutValue);
end;

initialization
  TDUnitX.RegisterTestFixture(TUnderscoreDelphiTest);
end.
