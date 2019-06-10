# Underscore4d

This project makes an effort to add functional algorithms that are available in most modern languages (JS, C#, C++) but not yet in Delphi. Spring4d adds a lot of these things, but are still not available directly for builtin Delphi types.

Underscore4d adds functions in the style of UnderscoreJS, using the _ namespace and passing both list/enumerable and the (anonymous) function to perform.

(Be aware that there's a performance penalty when using this library, as the supplied anonymous functions will not be inlined into the algorithm.)


UnderscoreJS |Spring4d      |Delphi       |Underscore4d
-------------|--------------|-------------|------------
each         |ForEach       |x            |
map T        |CastTo?       |x            |Map
map T,S      |x             |OfType?      |Map
reduce T     |Aggregate T   |Sum?         |Reduce
reduce T,S   |x             |x            |Reduce
reduceRight  |x             |x            |
find         |First         |x            |
filter       |Where         |             |Filter
where        |
findWhere    |
reject       |
every        |All
some         |Any
contains     |Contains      |Contains
pluck
max
min
sortBy
groupBy
indexBy
countBy
shuffle
sample
toArray
size
partition
first        |[0]           |First
initial
last         |              |Last
rest
compact
flatten
without
union       |Union          |x       |Union
intersection|IntersectWith  |x       |Intersection
difference  |               |x       |Difference
uniq
zip         |               |x       |Zip
unzip
object
chunk
indexOf
lastIndexOf
sortedIndex
findIndex
findLastIndex
range
