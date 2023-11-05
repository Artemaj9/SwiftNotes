#Gestures

## UIGestureRecognizer

The base class is "abstract". We only actually use concrete sunclases to recognize.

## There are two sides to using a gesture recognizer
 1. Adding a gesture recognizer to a UIView (asking the UIView to "recognize" that gesture)
 2. Providing a method to "handle" that gesture (not necessarily handled by the UIView) 
 
## Usually the first is done by a controller
Though occasionally a UIView will do this itself if the gesture isintegral to its existence

## The second is provided either by UIView or a Controller
Depending on the situation. We'll see an example of both in our demo.

## Adding a gesture recognizer to a UIView 
Imagine we wanted a UIView in our Controller's View to recognize a "pan" gesture.
We can configure it to do so in the property observer for the outlet to that UIView

``` swift
@IBOutlet weak var pannableView: UIView {
	didSet {
		let panGestureRecognizer = UIPanGestureRecognizer(
			target: self, action: #selector(ViewController.pan(recognizer:))
			)
			pannableView.addGestureRecognizer(panGestureRecognizer)
	}
}
```
## A handler for a gesture needs gesture specific information

For example UIPanGestureRecognizer provides 3 methods

``` swift
func translation(in: UIView?) -> CGPoint // cumukative since start of recognition
func velocity(in: UIView?) -> CGPoint // how fast the finger is moving points/s
func setTranslation(CGPoint, in: UIView?)
// The last one is interesting because it allows you to reset the translation so far.
// By reseting the translation to zero all the time, you end up getting "incremental" translation.
```
## The abstract superclass also provides state informaton

``` swift
var state: UIGestureRecognizerState { get }
```
This sits around in .possible until recognition starts
For a continuous gesture(e.g. pan) it moves from **.began** thru repeated **.changed** to **.ended**
For a discrete (e.g. a swipe) gesture, it goes staright to **.ended** or **.recognized**
It can go to **.failed** or **.cancelled** too, so watch out for those!

## Pan handler 

``` swift
func pan(recognizer: UIPanGestureRecognizer) {
	switch recognizer.state {
	 case .changed: fallthrough
	 case .ended: 
	 	 let translation = recognizer.translation(in: pannableView)
	 	 // update anything that depends on the pan gesture using translation.x and .y
	 	 recognizer.setTranslation(CGPoint.zero, in: pannableView)
	 default: break
	}
}
```
Remember that the action was pan(recognizer:) 
We are only going to do anything when the the finger moves or lifts up off the device's surface fallthrough is "execute the code for the next case down"
(case .changed, .ended: ok too)
Here we get the location of the pan in the pannableView's coordinate system
Now we do whatever we want with that information.
By reseting the translation, the next one we get will be incremental movement

## UIPinchGestureRecognizer
var scale: CGFloat // not read-onle(can reset)
var velocity: CGFloat { get } // scale factor per second

## UIRotationGestureRecognizer
var rotation: CGFloat // not read-only (can reset) in radians
var velocity: CGFloat { get } // radians per second

## UISwipeGestureRecognizer
Set up the direction and number of fingers you want

var direction: UISwipeGestureRecognizerDirection // which swipe directions you want
var numberOfTouchesRequired: Int // finger count

## UITapGestureRecognizer

This is discrete, but you should check for .ended to actually do something.
Set up the number of taps and fingers you want

```swift
var numberOfTapsRequired: Int // single tap, double tap, etc
var numberOfTouchesRequired: Int // finger count
```

## UILongPressRecognizer
This is a continuous (not discrete) gesture (i.e. you'll get .changed if the finger moves)
You stil configure it up-front

```swift
var minimumPressDuration: TimeInterval // how long to hold before it recognized
var numberOfTouchesRequired: Int //finger count
var allowableMovement: CGFloat // how far finger can move and still recognize
```

Very important to pat attention to .cancelled because of drag and drop

