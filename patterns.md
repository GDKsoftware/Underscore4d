# Common patterns and their functional equivalent

## Creating new items for each element in a list

For code that looks like this:

```
for Item in List do
begin
  NewThing := TNewThing.Create;
  NewThing.Value := Item.Value;
  NewList.Add(NewThing);
end;
```

Instead, use the **Map** function like this:

```
NewList := _.Map<TThing, TNewThing>(List, 
  function(const Item: TThing): TNewThing
  begin
    Result := TNewThing.Create;
    Result.Value := Item.Value;
  end);
```

## Filtering a list

For code that looks like this:

```
for Item in List do
begin
  if Item.ShouldFilter then
  begin
    NewList.Add(Item);
  end;
end;
```

Instead, use **Filter**:

```
NewList := _.Filter<TThing>(List,
  function(const Item: TThing): Boolean
  begin
    Result := Item.ShouldFilter;
  end);
```

## Find an item in a list

For code that looks like this:

```
for Item in List do
begin
  if (Item.Value = 5) and Item.OtherValue then
  begin
    Result := Item;
    Exit;
  end;
end;
```

Instead, use **Find** *(First in Spring4d)*:

```
Result := _.FindOrDefault<TThing>(List,
  function(const Item: TThing): Boolean
  begin
    Result := (Item.Value = 5) and Item.OtherValue;
  end, nil);
```

## Creating a summary of items in a list

For code that looks like this:

```
for Item in List do
begin
  TotalVAT := TotalVAT + Item.Value * 0.21;
  TotalInclVAT := TotalInclVAT + Item.Value * 1.21;
end;
```

Instead, use **Reduce**:

```
Totals := _.Reduce<TThing, TVATTotals>(List,
  function(const Current: TVATTotals; const Item: TThing): TVATTotals
  begin
    Result.TotalVAT := Current.TotalVAT + Item.Value * 0.21;
    Result.TotalInclVAT := Current.TotalInclVAT + Item.Value * 1.21;
  end, EmptyTotals);
```

## Other kinds of for each element in a list, do something
