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

Instead, use the Map function like this:

```
NewList := _.Map<TThing, TNewThing>(List, 
  function(const Item: TThing): TNewThing
  begin
    Result := TNewThing.Create;
    Result.Value := Item.Value;
  end);
```

## Creating a summary of items in a list

For code that looks like this:

```
for Item in List do
begin
  TotalVAT := TotalVAT + Item.Value * 0.21;
  TotalInclVAT := TotalInclVAT + Item.Value * 1.21;
end;

Instead, use Reduce:

```
...
```


## Other kinds of for each element in a list, do something
