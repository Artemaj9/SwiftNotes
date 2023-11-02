#Custom counted set
## Generic wrapper around NSCountedSet
```swift
struct CustomCountedSet<T: Any> {
	let internalSet = NSCountedSet()
	
	mutating func add(_ obj: T) {
		internalSet.add(obj
	} 
	
	mutating func remove(_ obj: T) {
		internalSet.remove(obj)
	} 
		
   func count(for obj: T) -> Int {
      return internalSet.count(for: obj)
	}
}

var countedSet = CustomCountedSet<String>()
countedSet.add("Hello")
countedSet.add("Hello")
countedSet.count(for: "Hello")

var countedSet2 = CustomCountedSet<Int>()
countedSet2.add(5)
countedSet2.count(for: 5)
```