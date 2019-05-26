unit Underscore.Delphi;

interface

uses
  System.Generics.Collections,
  Spring.Collections,
  System.SysUtils;

type
  _ = class
  public
    class function Map<T, S>(const List: TList<T>; const MapFunc: TFunc<T, S>): TList<S>; overload;
    class function Map<T, S>(const List: TEnumerable<T>; const MapFunc: TFunc<T, S>): TList<S>; overload;
    class function Map<T, S>(const List: IEnumerable<T>; const MapFunc: TFunc<T, S>): IList<S>; overload;

    class function MapP<T, S>(const List: IEnumerable<T>; const MapFunc: TFunc<T, S>): IList<S>;

    class function Reduce<T>(const List: TEnumerable<T>; const ReduceFunc: TFunc<T, T, T>; const InitialValue: T): T; overload;
    class function Reduce<T,S>(const List: TEnumerable<T>; const ReduceFunc: TFunc<S, T, S>; const InitialValue: S): S; overload;
    class function Reduce<T>(const List: IEnumerable<T>; const ReduceFunc: TFunc<T, T, T>; const InitialValue: T): T; overload;
    class function Reduce<T,S>(const List: IEnumerable<T>; const ReduceFunc: TFunc<S, T, S>; const InitialValue: S): S; overload;

    class function Zip<T>(const Lists: TList<TList<T>>): TList<TList<T>>; overload;
    class function Zip<T>(const Lists: IEnumerable<IEnumerable<T>>): IList<IList<T>>; overload;
  end;

implementation

uses
  System.Types,
  System.TypInfo,
  System.Threading;

class function _.Map<T, S>(const List: TList<T>; const MapFunc: TFunc<T, S>): TList<S>;
var
  Item: T;
begin
  Result := TList<S>.Create;
  Result.Capacity := List.Count;
  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.Map<T, S>(const List: TEnumerable<T>; const MapFunc: TFunc<T, S>): TList<S>;
var
  Item: T;
begin
  Result := TList<S>.Create;
  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.Map<T, S>(const List: IEnumerable<T>; const MapFunc: TFunc<T, S>): IList<S>;
var
  Item: T;
begin
  Result := TCollections.CreateList<S>;
  Result.Capacity := List.Count;

  for Item in List do
    Result.Add(MapFunc(Item));
end;

class function _.MapP<T, S>(const List: IEnumerable<T>; const MapFunc: TFunc<T, S>): IList<S>;
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

class function _.Reduce<T, S>(const List: TEnumerable<T>; const ReduceFunc: TFunc<S, T, S>; const InitialValue: S): S;
var
  Item: T;
begin
  Result := InitialValue;
  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Reduce<T>(const List: TEnumerable<T>; const ReduceFunc: TFunc<T, T, T>; const InitialValue: T): T;
var
  Item: T;
begin
  Result := InitialValue;
  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Reduce<T>(const List: IEnumerable<T>; const ReduceFunc: TFunc<T, T, T>; const InitialValue: T): T;
var
  Item: T;
begin
  Result := InitialValue;

  for Item in List do
    Result := ReduceFunc(Result, Item);
end;

class function _.Reduce<T, S>(const List: IEnumerable<T>; const ReduceFunc: TFunc<S, T, S>; const InitialValue: S): S;
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

end.
