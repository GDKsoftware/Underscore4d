# Underscore4d

This project makes an effort to add functional algorithms that are available in most modern languages (JS, C#, C++) and native in functional languages, but are generally not available in Delphi yet.
Spring4d adds a lot of this functionality for IEnumerable<T>, but are still not available for builtin Delphi types like TList<T>.

Underscore4d adds functions in the style of UnderscoreJS, using the _ namespace and passing both list/enumerable and the (anonymous) function to perform.

(Be aware that there's a performance penalty when using this library, as the supplied anonymous functions will not be inlined into the algorithm.)


UnderscoreJS |Spring4d      |Delphi       |Underscore4d
-------------|--------------|-------------|------------
each         |ForEach       |x            |
map T        |x             |x            |Map
map T,S      |OfType?       |x            |Map
reduce T     |Aggregate T   |x            |Reduce
reduce T,S   |x             |x            |Reduce
reduceRight  |x             |x            |
find         |First         |x            |Find*
filter       |Where         |x            |Filter
where        |
findWhere    |
reject       |
every        |All           |x            |Every
some         |Any
contains     |Contains      |Contains     |x
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

*) will throw exception on failure

## Extra functions
* Join

