# Closure Capturing

### You can define local variables on the fly at the start of a closure

``` swift

var foo = { [x = someInstanceOfaClass, y = "hello"] in 
	// use x and y there
	}
```

### These locals can be declared weak

``` swift
var foo = { [weak x = someInstanceOfaClass, y = "hello"] in
	// use x and y here, but x is now Optional because it's weak
	}
``` 

### Or they cann even be declared "unowned"

**unowned** means that the reference counting system doesn't count them (or check the count)

``` swift
var foo = { [unowed x = someInstanceOfaClass, y = "hello"] in 
	// use x and y here, x is not an Optional
	// if you use x here and it is not in the heap, you will crash
}
```

### Closure Capture

** This is all primarily used to prevent a memory cycle

``` swift
class Zerg {
	private var foo = {
		self.bar
	}
	private func bar() { ... }
}
```

This, too, is a memory cycle. Why?

The **closure** assigned to foo keeps self in the heap.

Thats because closures are reference types and live in the heap and they "capture" variables in their surroundings and keep them in the heap with them.
Meanwhile self's var foo is keeping the closure in the heap.
So foo points to the closure which points back to self which points to the closure.
A cycle.
Neither can leave the heap: there's always going to be a pointer to each (from the other).


``` swift
class Zerg {
	private var foo = { [weak self] in
		self?.bar // need Optional chaining now because weakSelf is an Optional
	}
	private func bar() { ... }
}
```

Now the closure no longer has a strong pointer to self.
So it is not keeping self in the heap with it.
The cycle is broken.