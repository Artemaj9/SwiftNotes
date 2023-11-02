# Sets 

## A set is an unordered collection of elements, with each element appearing only once.
------
Testing a value for membership in a set is a constant-time operation, and set elements must be Hashable, just like dictionary keys.

Checking whether a set contains an item has the complexity O(1)

Set conforms to the **ExpressibleByArrayLiteral**  protocol

### Definition
``` swift
	 * let set1: Set = [1, 2, 3, 2]
 	 * var set2 = Set<Int>([1, 2, 3, 4, 5])
 	 * var set3 = Set(1...100)
```

### Methods

* contains(element)
* forEach()
* insert(element)
* remove(element)
* removeFirst() 
* max()
* min()
* randomElement()
* allSatisfy()
* popFirst() `array haven't this method!`
- - Methods of sets that return array
	* sorted()
	* map()
	* flatMap()
	* compactMap()
	* filter()
	
### Set Algebra 
	* subtracting()
	* intersection()
	* union()
	* symmetricDifference()
	* formUnion()
	* formIntersection()
	* formSymmetricDifference()
	* A.isSubset(of: B) 
	* A.isSuperset(of: B)
	* A.isDisjoint(with: B)
	* A.isStrictSubset(of: B)
	* A.isStrictSuperset(of: B)
For even more set operations, check out the SetAlgebra protocol.
______________________________________________________

``` swift
extension Sequence where Element: Hashable {
	func unique() -> [Element] {
		var seen: Set<Element> = []
		return filter { element in 
			if seen.contains(element) {
				return false
			} else {
				seen.insert(element)
				return true
			}
		}		
	}
}

```

The method above allows us to find all unique elements in a sequence while still maintaining the original order (with the constraint that the elements must be Hashable).