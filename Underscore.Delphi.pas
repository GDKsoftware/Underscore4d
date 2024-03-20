unit Underscore.Delphi;

interface

uses
  System.Generics.Collections,
  Spring,
  Spring.Collections,
  System.SysUtils;

type
  _Func<T, TResult> = reference to function(const arg: T): TResult;
  _Func<A, B, TResult> = reference to function(const arga: A; const argb: B): TResult;
  _Predicate<T> = reference to function(const arg: T): Boolean;

  _ = class
  public
    class function Map<T, S>(const List: TList<T>; const MapFunc: _Func<T, S>): TList<S>; overload;
    class function Map<T, S>(const List: TEnumerable<T>; const MapFunc: _Func<T, S>): TList<S>; overload;
    class function Map<T, S>(const List: IEnumerable<T>; const MapFunc: _Func<T, S>): IList<S>; overload;
    class function Map<T, V, S>(const List: TDictionary<T, V>; const MapFunc: _Func<TPair<T,V>, S>): TList<S>; overload;
    class function Map<T, V, S>(const List: IDictionary<T, V>; const MapFunc: _Func<TPair<T,V>, S>): IList<S>; overload;

    class function MapP<T, S>(const List: IEnumerable<T>; const MapFunc: _Func<T, S>): IList<S>;

    class function Reduce<T>(const List: TEnumerable<T>; const ReduceFunc: _Func<T, T, T>; const InitialValue: T): T; overload;
    class function Reduce<T,S>(const List: TEnumerable<T>; const ReduceFunc: _Func<S, T, S>; const InitialValue: S): S; overload;
    class function Reduce<T>(const List: IEnumerable<T>; const ReduceFunc: _Func<T, T, T>; const InitialValue: T): T; overload;
    class function Reduce<T,S>(const List: IEnumerable<T>; const ReduceFunc: _Func<S, T, S>; const InitialValue: S): S; overload;

    class function Zip<T>(const Lists: TList<TList<T>>): TList<TList<T>>; overload;
    class function Zip<T>(const Lists: IEnumerable<IEnumerable<T>>): IList<IList<T>>; overload;

    class function Intersection<T: record>(const A, B: IEnumerable<T>): IList<T>;
    class function Difference<T: record>(const A, B: IEnumerable<T>): IList<T>;
    class function Union<T: record>(const A, B: IEnumerable<T>): IList<T>;

    class function Every<T>(const List: TList<T>; const Predicate: _Predicate<T>): Boolean;

    class function Filter<T>(const List: TList<T>; const Predicate: _Predicate<T>): TList<T>; overload;
    class function Filter<T>(const List: TArray<T>; const Predicate: _Predicate<T>): IList<T>; overload;

    class function Join<T>(const List: IEnumerable<T>; const JoinFunc: _Func<T, string>; const Separator: string): string; overload;
    class function Join<T>(const List: TList<T>; const JoinFunc: _Func<T, string>; const Separator: string): string; overload;
    class function Join(const List: IEnumerable<string>; const Separator: string): string; overload;

    class function Find<T>(const List: TList<T>; const Predicate: _Predicate<T>): T;
    class function FindOrDefault<T>(const List: TList<T>; const Predicate: _Predicate<T>; const Default: T): T;

    class function Min<T>(const List: TList<T>; const ValueFunc: _Func<T, Integer>): T;
    class function Max<T>(const List: TList<T>; const ValueFunc: _Func<T, Integer>): T;

    class function Uniq<T>(const List: IEnumerable<T>): IList<T>; overload;
    class function Uniq<T>(const List: TList<T>): TList<T>; overload;
  end;

implementation

uses
  System.Threading;

class function _.Map<T, S>(const List: TList<T>; const MapFunc: _Func<T, S>): TList<S>;
var
  Item: T;
begin
  Result := TList<S>.Create;
  Result.Capacity := List.Count;
  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.Map<T, S>(const List: TEnumerable<T>; const MapFunc: _Func<T, S>): TList<S>;
var
  Item: T;
begin
  Result := TList<S>.Create;
  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.Difference<T>(const A, B: IEnumerable<T>): IList<T>;
var
  Item: T;
begin
  Result := TCollections.CreateList<T>;
  Result.Capacity := A.Count + B.Count;

  for Item in A do
  begin
    if not B.Contains(Item) then
      Result.Add(Item);
  end;
end;

class function _.Every<T>(const List: TList<T>; const Predicate: _Predicate<T>): Boolean;
var
  Item: T;
begin
  Result := True;

  for Item in list do
  begin
    if not Predicate(Item) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

class function _.Filter<T>(const List: TArray<T>; const Predicate: _Predicate<T>): IList<T>;
var
  Item: T;
begin
  Result := TCollections.CreateList<T>;
  Result.Capacity := Length(List);

  for Item in List do
  begin
    if Predicate(Item) then
      Result.Add(Item);
  end;
end;

class function _.Find<T>(const List: TList<T>; const Predicate: _Predicate<T>): T;
var
  Item: T;
begin
  for Item in List do
  begin
    if Predicate(Item) then
    begin
      Result := Item;
      Exit;
    end;
  end;

  raise EInvalidOperationException.Create('No item found');
end;

class function _.FindOrDefault<T>(const List: TList<T>; const Predicate: _Predicate<T>; const Default: T): T;
var
  Item: T;
begin
  Result := Default;

  for Item in List do
  begin
    if Predicate(Item) then
    begin
      Result := Item;
      Exit;
    end;
  end;
end;

class function _.Filter<T>(const List: TList<T>; const Predicate: _Predicate<T>): TList<T>;
var
  Item: T;
begin
  Result := TList<T>.Create;
  Result.Capacity := List.Count;

  for Item in List do
  begin
    if Predicate(Item) then
      Result.Add(Item);
  end;
end;

class function _.Intersection<T>(const A, B: IEnumerable<T>): IList<T>;
var
  Item: T;
begin
  Result := TCollections.CreateList<T>;
  Result.Capacity := A.Count + B.Count;

  for Item in A do
  begin
    if B.Contains(Item) then
      Result.Add(Item);
  end;
end;

class function _.Join(const List: IEnumerable<string>; const Separator: string): string;
var
  Value: string;
begin
  Result := String.Empty;

  for Value in List do
  begin
    if Result.IsEmpty then
      Result := Value
    else
      Result := Result + Separator + Value;
  end;
end;

class function _.Join<T>(const List: TList<T>; const JoinFunc: _Func<T, string>; const Separator: string): string;
var
  Value: string;
  Item: T;
begin
  Result := String.Empty;

  for Item in List do
  begin
    Value := JoinFunc(Item);
    if Result.IsEmpty then
      Result := Value
    else
      Result := Result + Separator + Value;
  end;
end;

class function _.Join<T>(const List: IEnumerable<T>; const JoinFunc: _Func<T, string>; const Separator: string): string;
var
  Value: string;
  Item: T;
begin
  Result := String.Empty;

  for Item in List do
  begin
    Value := JoinFunc(Item);
    if Result.IsEmpty then
      Result := Value
    else
      Result := Result + Separator + Value;
  end;
end;

class function _.Union<T>(const A, B: IEnumerable<T>): IList<T>;
var
  Item: T;
begin
  Result := TCollections.CreateList<T>;
  Result.Capacity := A.Count + B.Count;

  for Item in A do
  begin
    if not Result.Contains(Item) then
      Result.Add(Item);
  end;

  for Item in B do
  begin
    if not Result.Contains(Item) then
      Result.Add(Item);
  end;
end;

class function _.Uniq<T>(const List: TList<T>): TList<T>;
begin
  Result := TList<T>.Create;
  Result.Capacity := List.Count;
  for var Item in List do
  begin
    if not Result.Contains(Item) then
      Result.Add(Item);
  end;
end;

class function _.Uniq<T>(const List: IEnumerable<T>): IList<T>;
begin
  Result := TCollections.CreateList<T>;
  Result.Capacity := List.Count;
  for var Item in List do
  begin
    if not Result.Contains(Item) then
      Result.Add(Item);
  end;
end;

class function _.Map<T, S>(const List: IEnumerable<T>; const MapFunc: _Func<T, S>): IList<S>;
var
  Item: T;
begin
  Result := TCollections.CreateList<S>;
  Result.Capacity := List.Count;

  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.Map<T, V, S>(const List: TDictionary<T, V>; const MapFunc: _Func<TPair<T, V>, S>): TList<S>;
var
  Item: TPair<T, V>;
begin
  Result := TList<S>.Create;
  Result.Capacity := List.Count;

  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.Map<T, V, S>(const List: IDictionary<T, V>; const MapFunc: _Func<TPair<T, V>, S>): IList<S>;
var
  Item: TPair<T, V>;
begin
  Result := TCollections.CreateList<S>;
  Result.Capacity := List.Count;

  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.MapP<T, S>(const List: IEnumerable<T>; const MapFunc: _Func<T, S>): IList<S>;
var
  Item: T;
  Idx: Integer;
  ResultList: IList<S>;
begin
  Result := TCollections.CreateList<S>;
  Result.Capacity := List.Count;

  ResultList := Result;

  for Item in List do
    Result.Add(Default(S));

  TParallel.For(0, List.Count - 1,
    procedure(Idx: Integer)
    begin
      ResultList[Idx] := MapFunc(List.ElementAt(Idx));
    end);
end;

class function _.Reduce<T, S>(const List: TEnumerable<T>; const ReduceFunc: _Func<S, T, S>; const InitialValue: S): S;
var
  Item: T;
begin
  Result := InitialValue;
  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Reduce<T>(const List: TEnumerable<T>; const ReduceFunc: _Func<T, T, T>; const InitialValue: T): T;
var
  Item: T;
begin
  Result := InitialValue;
  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Reduce<T>(const List: IEnumerable<T>; const ReduceFunc: _Func<T, T, T>; const InitialValue: T): T;
var
  Item: T;
begin
  Result := InitialValue;

  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Reduce<T, S>(const List: IEnumerable<T>; const ReduceFunc: _Func<S, T, S>; const InitialValue: S): S;
var
  Item: T;
begin
  Result := InitialValue;

  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Zip<T>(const Lists: TList<TList<T>>): TList<TList<T>>;
var
  List: TList<T>;
  Idx: Integer;
begin
  Result := TList<TList<T>>.Create();

  if Lists.Count = 0 then
    Exit;

  Result.Capacity := Lists[0].Count;

  for List in Lists do
  begin
    for Idx := 0 to Lists[0].Count - 1 do
    begin
      if Idx >= Result.Count then
        Result.Add(TList<T>.Create);

      Result[Idx].Add(List[Idx]);
    end;
  end;
end;

class function _.Zip<T>(const Lists: IEnumerable<IEnumerable<T>>): IList<IList<T>>;
var
  List: IEnumerable<T>;
  Idx: Integer;
  Item: T;
begin
  Result := TCollections.CreateList<IList<T>>;

  if Lists.Count = 0 then
    Exit;

  Idx := 0;
  for List in Lists do
  begin
    for Item in List do
    begin
      if Idx >= Result.Count then
        Result.Add(TCollections.CreateList<T>);

      Result[Idx].Add(Item);

      Inc(Idx);
    end;
  end;
end;

class function _.Min<T>(const List: TList<T>; const ValueFunc: _Func<T, Integer>): T;
var
  Item: T;
  ItemValue: Integer;
  MinValue: Integer;
begin
  MinValue := MaxInt;

  if List.Count = 0 then
    raise ENotSupportedException.Create('No items found');

  for Item in List do
  begin
    ItemValue := ValueFunc(Item);
    if ItemValue < MinValue then
    begin
      MinValue := ItemValue;
      Result := Item;
    end;
  end;
end;

class function _.Max<T>(const List: TList<T>; const ValueFunc: _Func<T, Integer>): T;
var
  Item: T;
  ItemValue: Integer;
  MaxValue: Integer;
begin
  MaxValue := -MaxInt;

  if List.Count = 0 then
    raise ENotSupportedException.Create('No items found');

  for Item in List do
  begin
    ItemValue := ValueFunc(Item);
    if ItemValue > MaxValue then
    begin
      MaxValue := ItemValue;
      Result := Item;
    end;
  end;
end;

end.
