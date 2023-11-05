#Views

##A view(i.e. UIView subclass) represent a rectangular area

 * Defines a coordinate space for drawing and for handling touch events
 
## Hierarchical
 * A view has only one superview ... var superview: UIView?
 * But it can have many (or zero) subviews ... var subviews: [UIView]
 * The order in the subviews array matters: those later in the array are on top of those earlier
 * A view can clip its subview to its own bounds or not (the default is not to)

##UIWindow
 *The UIView at the very, very top of the view hierarchy (even inxludes status bar)
 Usually only one UIWindow in an entire iOS application ... it's all about views, not windows
 
## Can be constructed in code
``` swift
func addSubview(_ view: UIView) // sent to view's (soon to be) superview
func removeFromSuperview() // sent to the view you want to remove (not its superview)
```
## Where does the view hierarchy start?
 * The top of the(useable) view hierarchy is the Controller's var view: UIView
 * This view is the one whose bounds will change on rotation, for example
 * This view is likely the one you will programmatically add subviews to (if you ever do that)
 * All of you MVC's View's UIViews will have this as an ancestor
 * It's automatically hokked up for you when you create an MVC in Xcode

## As always, try to avoid an initializer if possipble
But having on in UIView is slightly more common than having a UIViewController initializer

## A UIView's initializer is different if it comes out of a storyboard
``` swift
init(frame: CGRect) // initializer if the UIView is created in code
init(coder: NSCoder) // initializer if the UIView comes out of a storyboard

```
Two initializer: init with frame and init from coder

##If you need an initializer, implement them both

``` swift
func setup () {...}

override init(frame: CGRect) {  // a designated initializer
	super.init(frame: frame)
	setup()   //might have to be before super.init
}
required init?(coder aDecoder: NSCoder) { //a require, failable initializer
	super.init(cader: aDecoder)
	setup()
}
```
##Another alternative to initializers in UIView
``` swift
	awakeFromNib() 
	// This is only called if the UIView came out of a storyboard.
	// This is not an initializer (it's called immediately after initialization complete)
	// All objects that inherit from NSObject in a storyboard are sent this
	// Order is not guaranteed, so you cannot message any other objects in the storyboard here
```


#Coordinate System Data Structure

##CGFloat
Always use this instead of Double or Float for anything to do with a uIView coordinate system. You can convert to/from a Double or Float using initializers, e.g.

``` swift 
let cgf = CGFloat(aDouble)
```

##CGPoint

Simply a struct with two CGFloats in it: x and y.

``` swift
var point = CGPoint(x: 37.0, y: 55.2)
point.y -= 30
point.x += 20
```

##CGSize

Also a struct with two CGFloats in it: width and height

``` swift
var size = CGSize(width: 100.0, height: 50.0)
size.width += 42.5
size.height += 75
```
##CGRect
A struct with a CGPoint and SGSize in it

```swift
struct CGRect {
	var origin: CGPoint
	var size: CGSize
}
let rect = CGRect(origin: aCGPoint, size: aSGSize) // there are other inits as well
```
Lots of convenient properties and functions on CGRect like ...

``` swift
var minX: CGFloat	//left edge
var midY: CGFloat	// midpoint vertically
intersects(CGRect) -> Bool // does this CGRect intersect this other one
intersect(CGRect)	// clip the CGRect to the intersection with the other one
contains(CGPoint) -> Bool // does the CGRect contain the given CGPoint?
//... and many more (make yourself a CGRect and type . after it to see more) 
```
## View Coordinate system

* Origin is upper left
* Units are points, not pixels
	
 
 - Pixels are minimum-sized unit of drawing your device is capable of
 - Points are the units in the coordinate system
 - Most of the time there are 2-4 pixels per point, but it could be only 1 or even 3
 - How many pixels per point are there? UIView's **var contentScaleFactor: CGFloat**

### The boundaries of where drawing happens

* var bounds: CGRect

// A view's internal space's origin and size. This is rectangle containing the drawing space *in its own coordinate system*. It's up to your view's implementation what bounds.origin means (often nothing) 

Place you drawing

## Where is the UIView?

``` swift
var center: CGPoint // the center of UIView *in it's superview coordinate system
var frame: CGRect // the recr containing a UIView in *its superview's coordinate system*
``` 
Where you are in superview coordinate system

**Use a frame to position you View!**
**Use bounds for drawing!**

#### frame.size and bounds.size are different!
example: rotated view

## Creating Views

``` swift
// You can use the frame initializer ...
let newView = UIView(frame: myViewFrame)
// Or you can just use 
let newView = UIView() (frame wil be CGRect.zero) 
```
### Example

``` swift
let labelRect = CGRect(x: 20, y: 20, width: 100, height: 50)
let label = UILabel(frame: labelRect) //UILabel is a subclass of UIView
lavel.text = "Hello"
view.addSubview(label)
```

# Custom Views

## To draw, just create a UIView subclass and override draw (CGRect)
```swift
override func draw(_ rect: CGRect)
```
* You can draw outside the rect, but it's never required to do so.

* The rect is purely an optimization.

* It is our UIView's bounds that describe the entire drawing area (the **rect** is a subarea)

### -*Never call draw(CGRect)!! Ever! Or Else!*-

Instead, if you view needs to be redrawn, let the system know that by calling

``` swift
setNeedsDisplay()
setNeedsDisplay(_ rect: CGRect)
// rect is the area that needs to be redrawn iOS will then call your draw(CGRect) at an appropriate time
```
## Core Graphics Concepts
  1. You get a context to draw into (other context include printing, off-screen buffer, etc.)
  The function *UIGraphicsGetCurrentContext()* gives a context you can use in draw(CGRect)
  2. Create path (out of lines, arcs, etc.)
  3. Set drawing attributes like colors, fonts, textures, linewidths, linecaps, etc.
  4. Stroke or fill the above-created path with the given attributes 
  
## UIBezierPath

 * Same as above, but captures all the drawing with a UIBezierPath instance 
 * UIBezierPath automatically draws in the "current" context (preset up for you in drawRect))
 * UIBezierPath has methods to draw (lineto, arcs, etc.) and to set attributes (linewidth, etc.)
 * Use **UIColor** to set stroke and fill colors
 * UIBezierPath has methods to stroke and/or fill 

## Defining a Path
 
 ``` swift
 // Create a UIBezierPath
 
 let path = UIBezierPath()
 
 // Move around, add lines or arcs to the path
 
 path.move(to: CGPoint(80,50))
 path.addLine(to: CGPoint(140,150))
 path.addLine(to: CGPoint(10, 150))
 
 // Close the path (if you want)
 
 path.close()
 
 // Now that you have a path, set attributes and stroke/fill
 
 UIColor.green.setFill() // note setFill is a method in UIColor, not UIBezierPath
 UIColor.red.setStroke() // note setStroke is a method in UIColor, not UIBezierPath
 path.lineWidth = 3.0 // linewidth is a property in UIBezierPath, not UIColor
 path.fill() // fill is a method in UIBezierPath
 path.stroke() // stroke method in UIBezierPath
 ```
### You can also draw common shapes with UIBezierPath

``` swift
let roundedRect = UIBezierPath(roundedRect: CGRect, cornerRadius: CGFloat)
let oval = UIBezierPath(ovalIn: CGRect)
// ... and others
```
### Clipping your drawing to a UIBezierPath's path

``` swift
addClip()
// For example, you could clip to a rounded rect to enforce the edges of a playing card
``` 
### Hit detection
``` swift 
func contains(_ point: CGPoint) -> Bool 
// returns whether the point is inside the path. The path must be closed. The winding rule can be set with **usesEvenOddFillRule** property.
```
### Completely hiding a view without removing it from hierarchy 

``` swift
var isHidden: Bool
```
An isHidden view will draw nothing on screen and get no events either
Not as uncommon as you might think to temporarily hide a view

#### Usually we use a UILabel to put text on screen
#### To draw in draw(CGRect), use NSAttributedString

``` swift
let text = NSAttributedString(string: "hello") // probably would set some attributes too
text.draw(at: aCGPoint) // or draw(in: CGRect)
let textSize: CGSize = text.size // how much space the string will take up
``` 

### Accesiing a range of characters in an NSAttributedString
NSRange has an init which can handle the <span style="color:purple"> **String vs NSSTring weirdness <span>

``` swift
let pizzaJoint = "cafe pesto"
var attrString = NSMutableAttributedString(string: pizzaJoint)
let firstWordRange = pizzaJoint.startIndex..<pizzaJoint.indexOf(" ")!
let nsrange = NSRange(firstWordRange, in: pizzaJoint) // convert Range<String.Index>
attrString.addAttribute(.strokeColor, value: UIColor.orange, range: nsrange)
```

### Simple way to get a font in code

``` swift
// Get preferred font for a given text style(e.g. body, etc.) using this UIFont type method
static func preferredFont(forTextStyle: UIFontTextStyle) -> UIFont
// Some of the style (see UIFondDescriptor documentation for more)
UIFontTextStyle.headline
UIFontTextStyle.body
UIFontTextStyle.footnote
// Importamtly, the size of the font you get is determined by user settings (esp, for Accessibility).
// You'll want to make sure you UI looks good with all size fonts!
``` 
#### More advanced way

``` swift
let font = UIFont(name: "Helvetica", size: 36.0)
// You can also use UIFontDescriptor class to get the font you want.
```
Now get metrics for the text style you want and scale font to the user's desired size 

``` swift
let metrics = UIFontMetrics(forTextStyle: .body) // or UIFontMetrics.default
let fontToUse = metrics.scaledFont(for: font)
```
#### There are also system fonts
These appear usually on things like buttons

``` swift
static func systemFont(ofSize: CGFloat) -> UIFont
static finc boldSystemFont(ofSize: CGFloat) -> UIFont
```
But again, don't use these for your user's _content_. Use preferred fonts for that.

## Drawing Images

``` swift
let image: UIImage? = UIImage(named: "zvezdopad")
// failable initializer

let image: UIImage? = UIImage(contentsOfFile: pathString)
let image: UIImage? = UIImage(data: aData) // raw, jpg, png, tiff, etc. image data
```
//you add "zvezdopad.jpg" to your project in the <mark>Assets.xcassets</mark> 

You can even create one by drawing with Core Graphics
See documentation for UIGraphicsBeginImageContext(CGSize)

#### Once you have UIImage, you can blast its bits on screen
``` swift 
let image: UIImage = ...
image.draw(at pait: aCGPoint) // the upper left corner put at aCGPoint
image.draw(in rect: aCGRect) // scales the image to fit aCGRect
image.drawAsPattern(in rect: aCGRect) // tiles the image into aCGRect
```

## Redraw on bounds change?

 * By default, when UIViews bounds changes, there is __no redraw__
	- Instead, the "bits" of the existing image are scaled to the new bounds size.
 * This is often __not__ what you want
 	- Luckily, there is a UIView property to control this! It can be set in Xcode too.
 	
 	``` swift
 	var contentMode: UIViewContentMode
 	```
 * UIViewContentMode
  - Dont scale the view, just place the bits (intact) somewhere
  *.left/.right/.top/.top/.bottom/.topRight/.topLeft/.bottomRoght/.bottomLeft/.center*
  - Scale the "bits" of the view
  *.scaleToFill/.scaleAspectFill/.scaleAspectFit* // **.scaleToFill is the default!**
   Redraw by calynf dra(CGRect) afain (costly, but for certain content, better results)
   
   <mark>.redraw</mark>
## Layout on bounds change?
#### What about you subview on a bouns change?
If your *bounds* change, you may want to reposition some of your *subviews* 
Usually you would set this up using **Autolayout constraints**
Or you can *manualy* reposition your views when your bounds change by overriding

``` swift
override func layoutSubviews() {
	super.layoutSubviews()
	// reposition my subviews's frames based on my new bounds
	// where not using autolayout
}

```
 
 
 
  
 
