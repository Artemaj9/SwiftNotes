# Timer

## Used to execute code periodically


``` swift
// Fire one off with this method

class func scheduledTimer(
	withTimeInterval: TimeInterval,
	repeats: Bool,
	block: (Timer) -> Void
) -> Timer

// Example

private weak var timer: Timer?
timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { timer in
	// your code here
}

// Every 2 seconds (approximately), the closure will be executed.
// Note that the var we stored the timer is weak.
// That's okay because the run loop will keep a strong pointer to this as long as it's scheduled!
// timer is running when it's !- nil
```

####Stoping a repeating timer

timer.invalidate()

####Tolerance
It might help system perfomance to set a tolerance for "late firing".

myOneMinuteTimer.tolerance = 10 //in seconds

not microseconds timers!

**Once app in suspended state - nothing runs in you app!**

## Kinds of Animation

 * Animating UIView properties
   - Changing things like the frame or transparency
 * Animating Controller transitions (as in a UINavigationController)
 * Core Animation
   - Underlying powerful animation framework 
 * OpenGL and Metal
   - 3D
 * SpriteKit
   - "2.5 D" animation (overlapping images around over each other, etc.)
 * Dynamic Animation
   - "Physics"- based animation  

## UIView Animation

 * **frame/center**
 * **bounds** (transient size, doesn't conflict with animating center)
 * **transform** (translation, rotation and scale)
 * **alpha** (opacity)
 * **backgroundColor**
 
#### Done with UIViewPropertyAnimator using closures

``` swift 
class func runningPropertyAnimator(
	withDuration: TimeInterval,
	delay: TimeInterval,
	options: UIViewAnimationOptions,
	animations: () -> Void,
	completion: ((position: UIViewAnimatingPosition) -> Void)? = nil
)

// Not that is static (class) function. Yoy send it to the UIVIewPropertyAnimator type.
// The animations argument is a closure containing that changes center, transform, etc.
// The completion argument wil get executed when the animation finishes or is interrupted.
```

#### Example

``` swift
if myView.alpha == 1.0 {
	UIviewPropertyAnimator.runningPropertyAnimator(
		withDuration: 3.0,
		delay: 2.0,
		options: [.allowUserInteraction],
		animations: { myView.alpha = 0.0 }.
		completion: ( if $0 == .end { myView.removeFromSuperView() }
	)
	print("alpha = \(myView.alpha)")
}
```
This would cause myView to "fade" out over 3 seconds (starting 2s from now). 
Then it would remove myView from view hierarchy (but only if the fade completed). 
If, within 5s, someone animated the alpha to non-zero, the removal would *not* happen. 
The output on the console would immediatele be **alpha = 0.0**
Even though the alpha on the screen won't be zero for 5 more seconds!

#### UIVIewAnimationsOptions

```
beginFromCurrentState // pick up from the other, in-progress animations of these properties
allowUserInteraction // allow gestures to get processed while animation is in progress
layoutSubviews // animate the relayout of sunviews with a parent's animation
repeat // repeat idefinitely
autoreverse // play animation forwards, then backwards
overrrideInheritedDuration // if not set, use duration of any in-progress animation
overrideInheritedCurve // if not set, use curve(e.g. ease-in/out) of in-progres animation
allowAnimatedConted // if not set, just interpolate between current and end "bits"
curveEaseInEaseOut // slower at the beginning, normal throughout, then slow at end
curveEaseIn // slower at the beginning, but then constant through the rest
curveLinear // same speed throughout
```
Flip the entire view over **UIViewAnimationOptions.transitionFlipFrom{Left,Right,Top,Bottom}**
Dissolve from old to new state **.transitionCrossDissolve**
Curling up or down **.transitionCurl{Uo, Down}**

## Example Transition

Flipping a playing card over 

```swift
UIView.transition(withPlayingCardView,
					duration: 0.75,
					options: [.transitionFlipFromLeft],
					animations: { cardsIsFaceUP = !cardIsFaceUp }
					completion: nil)
```
## Dynamic Animation
  * Create a UIDynamicAnimator 
  - var animator = UIDynamicAnimator(referenceView: UIView)
  If animating views, all views must be in a view hierarchy with referenceView at the top.
  * Create and add UIDynamicBehavior instances
  - e.g., let gravity = UIGravityBehavior()
  animator.addBehavior(gravity)
  -e.g., collider = UICollisionBehavior()
  animator.addBehavior(collider)
  * Add UIDynamicItems to a UIDynamicBehavior

``` swift
let item1: UIDynamicItem = ... // usually a UIView
let item2: UIDynamicItem = ... // usually a UIView
gravity.addItem(item1)
collider.addItem(item1)
gravity.addItem(item2)
``` 

Item1 and item2 will both be affect by gravity 

Item1 will collide with collider's other items or boundaries, but not with item2

#### UIDynamicItem protocol

Any animatable item must implement this

``` swift

protocol UIDynamicItem {
	var bounds: CGRect { get } // essentially the size
	var center: CGPoint { get set } // and the position
	var transform: CGAffineTransform { get set } // rotation usually
	var collisionBoundsType: UIDynamicItemCollisionBoundsType { get set }
	var collisionBoundingPath: UIBezierPath { get set }
}
```

UIView implements this protocol
If you change center or transform while the animator is running, you must call this method in UIDynamicAnimator 

``` swift
func updateItemUsingCurrentState(item: UIDynamicItem)
```

#### Behaviors

 * UIGravityBehavior
 
``` swift
var angle: CGFloat // in radians; 0 is to the right; positive numbers are clockwise
var magnitude: CGFloat // 1.0 is 1000 point/s^2
```

* UIAttachmentBehavior

``` swift
init(item: UIDynamicItem, attachedToAnchor: CGPoint)
init(item: UIDynamicItem, attachedTo: UIDynamicItem)
init(item: UIDynamicItem, offsetFromCenter: CGPoint, attachedTo[Anchor]...)
var length: CGFloat // distanse between attached things (this is settable while animating!)
var anchorPoint: CGPoint // can also be set at any time, even while animating
// The attachment can oscillate(i.e. like a spring) and you can control frequency and damping
```

* UICollisionBehavior

``` swift 
var collisionMode: UICollisionBehaviorMode // .items, .boundaries or .everything

// If .items, any items you add to a UICollisionBehavior will bounce off of each other.
// If .boundaries, then you add UIBezierPath boundaries for items to bounce off of

func addBoundary(withIdentifier: NSCopyng, for: UIBezierPath)
func addBoundary(withIdentifier: NSCopyng, fron: CGPoint, to: CGPoint)
func removeBoundary(withIdentifier: NSCopying)
var translatesReferenceBoundsIntoBoundary: Bool // reference View's edges
```
NSCopyng means NSString or NSNumber, but remember you can **as** to String, Int, etc. 

How do you find when a colision happens?

``` swift 
var collisionDelegate: UICollisionBehaviorDelegate

// this delegate will be sent methods like:

func collisionBehavior(behavior: UICollisionBehavior,
		began/endedContactFor: UIDynamicItem,
		withBoundaryIdentifier: NSCopying // with: UIDynamicItem too
		at: CGPoint) 
		
// The withBoundaryIdentifier is the one you pass to addBoundary(withIdentifier:)
```

* UISnapBehavior
init(item: UIDynamicItem, snapTo: CGPoint)
var damping: CGFloat

* UIPushBehavior

``` swift
var mode: UIPusgBehaviorMode // .continuous or .instantaneous
var pushDirection: CGVector

var angle: CGFloat // .continuous or .instantaneous
var magnitude: CGFloat
var angle: CGFloat // in radians and positive numbers are clockwise
var magnitude: CGFloat // magnitude 1.0 moves a 100*100 view at 100 pts/s^2
```

Interesting aspect to this behavior
If you push .instantaneous, what happens after it's done?
It just sits there wasting memory
We'll talk about how to clear that up in a moment.

* UIDynamicBehavior 

Sort of a special "meta" behavior. Controls the behavior of it's items as they are affected by other behaviors.
Any item added to this behaviour (with addItem) will be affected by

``` swift
var allowsRotation: Bool
var friction: CGFloat
var elasticity: CGFloat

// Can also get information about items with this behavior

func linearVelocity(for: UIDynamicItem) -> CGPoint
func addLinearVelocity(CGPoint, for: UIDynamicItem)
func angularVelocity(for: UIDynamicItem) -> CGFloat
```

**UIDynamicBehavior superclass of behaviors.**
You can create your own subclass which is a combination of other behaviors.
Usually you override init method(s) and addItem and removeItem to call...

func addChildBehavior(UIDynamicBehavior)
This is a good way to encapsulate  physics behavior that is a composite of other behaviors.
You might also add some API which helps your subclass configure its children.

#### All behaviors know the UIDynamicAnimator they are part of
They can only be part of one at a time

``` swift
var dynamicAnimator: UIDynamicAnimator? { get }

// And the behavior will be sent this message whem it's animator changes

func willMove(to: UIDynamicAnimator?)
```

#### Action property

Every time the behavior acts on items, this block of code that you can set is executed

``` swift
var action: (() -> Void)?

// you can set this to do anything you want.
// but it will be called a lot so make it very efficient
// if the action refers to properties in the behavior itself, watch. out for memory cycles 
```

#### Memory cycle avoidance

 * EExample of using action and avoiding a memory cycle

Let's go back to the case of an .instantaneous UIPushBehavior
When it is done acting on its items, it would be nice to remove it from its animator
We can do this with the action var which takes a closure

``` swift
if let pushBehaviour = UIPuchBehavior(items: [...], mode: .instantaneous) {
	pushBehavior.magnitude = ...
	pushBehavior.angle = ...
	pushBehavior.action = {
		pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
	}
	animator.addBehavior(pushBehavior) // will push right away
}
```

But the above has a memory cycle because its action captures a pointer back to itself.
**Se neither the action closure nor the pushBehavior can ever leave the heap!** 

#### Example of using action and avoiding a memory cycle
Even more dramatically, we could use unowned to break a cycle.
The best example of this is back in our push behavior

``` swift
if let pushBehaviour = UIPuchBehavior(items: [...], mode: .instantaneous) {
	pushBehavior.magnitude = ...
	pushBehavior.angle = ...
	pushBehavior.action = { [unowned pushBehavior] in
		pushBehavior.dynamicAnimator!.removeBehavior(pushBehavior)
	}
	animator.addBehavior(pushBehavior) // will push right away
}
```
The action closure no longer captures pushBehavior.
And we can use this local pushBehavior without any Optional chaining (it's not Optional).
It is safe to mark it unowned because if the action closure exists, so does the pushBehavior.
But we'd better be right!