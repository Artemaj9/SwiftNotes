#Deque 
## Array based implementation
### Examples
```swift
struct Deque<T> {
	var array = [T]()

	mutating func pushBack(_ obj: T) {
		array.append(obj)
	}
	
	mutating func pushFront(_ obj: T) {
		array.insert(obj, at: 0)
	}
	
	mutating func popBack() -> T? {
		return array.popLast()
	}
	
	mutating func popFront() -> T? {
		if array.isEmpty {
			return nil
		} else {
			return array.removeFirst()
		}
}

var testDeque = deque<Int>()
testDeque.pushBack(7)
testDeque.pushFront(4)
testDeque.pushFront(3)
testDeque.popBack()
```