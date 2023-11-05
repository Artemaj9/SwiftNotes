#Computed Properties

## The value of a property can be computed rathen than sorted

#### A typical stored property looks like ths:
``` swift
var a: Double
```

#### A computed property looks like this:
``` swift
var a: Double {
	get {
		// return calculated value
	}
	set(newValue) {
		// do something on the fact that a has changed to newValue
	} 
}
```
You don't have to implement the *set* side of it if you don't want to.
The property then becomes "read only".