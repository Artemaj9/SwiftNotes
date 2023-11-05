# UIColor

### Colors are set using UIColor
There are type(aka static) vars for standarts colors, e.g. 
<span style="color:green"> **let green = UIColor.green** </span>

You can also create them from RGB, HSB, or even a pattern (using UIImage)

### Background color of a UIView

**var backgroundColor: UIColor** 

### Colors can have alpha (transparency)
``` swift
let semitransparentYellow = UIColor.yellow.withAlphaComponent(0.5)
```
ALpha is between 0.0 (fully transparent) and 1.0 (fully opaque)

### If you want to draw in your view with transparency

You musr let the system know by setting UIView 

``` swift
var opaque = false
```
### You can make entire UIView transparent
``` swift
var alpha: CGFloat
```

### Underneath UIView is a drawing mechanism CALayer
``` swift
var layer: CAlayer
var cornerRadius: CGFloat // make the background a rounded rect
var borderWidth: CGFloat // draw a border around the view
var borderColor: CGColor? // the color of the border (if any)

// You can get a CGColor from a UIColor using UIColor's **cgcolor** var
```