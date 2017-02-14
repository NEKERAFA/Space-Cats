# Collection types for Lua

A collection is an abstract data type which contents elements inside it, like numbers, functions, strings, etc. It was programed in **Lua pure** (5.x), so you can use in **LÖVE** or PSP and NDS **LuaPlayers** also.

## Features:

- **object**: Generic object abstraction that all types extends. This is added because all types are programmed using object oriented paradigm.
- **list**: Generic non typed collection that you can use like a polymorphic list.
- **stack**: Implementation of *LIFO* structure using generic collection.
- **queue**: Implementation of *FIFO* structure using generic collection.
- **set**: Implementation of mathematic set with mainly algebraic set operations.
- **vector**: Implementation of mathematic vector with mainly vectorial operations.
- **byte**: Implementation of byte numeric type

## Building:

- **hashmap**: Implementation of pure associative polymorphic array that overwrite values with same key.
- **arraymap**: Implementation of associative polymorphic array that save all (key, value) elements.
- **matrix**: Implementation of mathematic matrix with mainly matrix operations.
- **graph**: Implementation of polymorphic graph type.
- **tree**: Implementation of polymorphic tree type.
- **bintree**: Implementation of polymorphic binary tree.
- **heap**: Implementation of polymorphic complete binary tree (heap).

## Changes:

I reprogrammed all code because I prefer a object oriented pure programming. I continue to use the old sing methods, so the code that uses old version doesn't need to changes so much. This is the most important changes:

- I created Object module, that is a generic object abstraction that implements mainly methods to manipulate objects.
- Old collection type has change to list module. All methods are still working.

## Examples:

You can find more examples in the examples folder

#### Using a stack
```lua
-- Load stack type
stack = require 'src/stack'

mystack = stack()

mystack:push(1)
mystack:push(2)
mystack:push(3)

mystack:pop() -- It returns 3
mystack:peek() -- It returns 2
```

#### Using a set
```lua
-- Load set type
set = require 'src/math.set'

set1 = set {1,2,3}
set2 = set {3,4,5}

-- Return a set with {1,2,3,4,5}
set1 + set2

-- Return a set with {1,2}
set1 - set2

-- Return a set with {3}
set1 * set2

-- Return a array map with {1,2,4,5}
set1 / set2
```

## License
Libraries are licensed by Creative Commons Attribution-ShareAlike 4.0.
Show [more](http://creativecommons.org/licenses/by-sa/4.0/).
