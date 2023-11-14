# View Controller Lificycle


### View Did Load 
``` swift 
override func viewDidLoad() {
	super.viewDidLoad() 
	// always let super have a chance in lifecycle methods
	// good time to update my View using Model, because outlets are set
}
```

**Do not do geometry-related setup here. Your bounds are not yet set!**

### View Will Appear

``` swift 
override func viewWillAppear(_ animated: Bool) {
	super.viewWillAppear() 
	// catch my View up to date with what went while i was off-screen
}

// Note that this method can be called repeatedly (vs. viewDidLoad which is only called once)

```

### View Did Appear

``` swift

override func viewDidAppear(_ animated: Bool) {
	super.viewDidAppear(animated)
	// maybe start a timer or an animation or start observing something (e.g. GPS position)
```

This is also a good place to start something expensive (e.g. network fetch) going.
Why kick off expensive things here instead of in viewDidLoad?
Because we know we're on screen so it won't be a waste.
By "expensive" we usually meen "time consuming" but could also mean battery or storage.

We must never block out UI from user interaction (thus background fetching, etc.).
Our UI might need to come up incomplete and later fill in when expensive operation is done.
We use "spinning wheels" and such to let the user know we're fetching somethimg expensive. 

### View Will Disappear

You MVC is still on screen, but it's about to go off screen.
Maybe the user hit "back" in a UINavigationController?
Or they switched to another tab in a UITabBarController?


``` swift
override func viewWillDisappear(_ animated: Bool) {
	super.viewWilDisappear(animated)
	// often you undo what you did in viewDidAppear 
	// for example, stop a timer that you started there or stop observing something
```

### View Did Disappear

Your MVC went off screen.
Somewhat rare to do something here, but occasionally you might want to "clean up" your MVC.
For example you could save some state or release some large, recreatable resourse.


``` swift
override func viewDidDisappear(_ animated: Bool) {
	super.viewDidDisappear(animated)
	// clean up MVC
}
```

### Geometry

You get notified when your top-level view's bounds change (or otherwise needs a re-layout).
In other words, when ot receives layoutSubviews you get to find out (before and after).

``` swift 
override func viewWillLayoutSubviews()
override func viewDidLayoutSubviews()
```

** Usually you don't need to do anything here because of Autolayout. **

But if you do have geometry-related setup to do, this is the place to do it (not in viewDidLoad)

These can be called often (just as layoutSubviews () in UIView can be called often)
Be prepared for that.
Don't do anything here that can't be properly (and efficiently) done repeatedly.
It doesn't always mean your view's bounds actually changed.

### View Will Transition

When your device rotates, theres a lot going on.
Of course your view's bounds change (and thus you'll get viewWill/DidLayoutSubviews)
But the resultant changes are also automatically animated.
You get to find out about that and even participate in the animation if you want

``` swift

override func viewWillTransition(
	to size: CGSize,
	with coordinator: UIViewControllerTransitionCoordinator
)
```
You goin in using the coordinator's animate(alongsideTransition:) metgods.
Check the docs!!! 

### Low Memory

``` swift
override func didReceiveMemoryWarning() {
	super.didReceiveMemoryWarning()
	// stop pointing to any large-memory things (i.e. let them go from my heap)
	// that i'm not currently using(e.g. displaying on screen or processing somehow)
	// and that i can recreate as needed (by refreshing from network)
}
```

** If you application persists in using an unfair amount of memory, you can get killed by iOS" **

### Waking up from an storyboard

``` swift
override func awakeFromNib() {
	super.awakeFromNib()
}
	// can initialize stuff here, bur it's very early
	// it happens way before outlets a set and before you're prepared as part of a segue 
```

This is pretty much a place a last of resort. Use the other View Controller Lifecycle methods first if it all possible.
It's primarily for situations where code has to be executed VERY EARLY in the lifecycle.


### Summary
	
	1. Instantiated
	2. awakeFromNib (only from storyboard)
	3. segue preparation happens
	4. outlets get set
	5. viewDidLoad
	6. viewWillAppear
	7. ViewIsAppearing
	7. viewDidAppear
	8. viewWillDisappear
	9. viewDidDisappear

These "geometry chnged" methods might be called at any time after viewDidLoad

**viewWillLayoutSubviews** and **viewDidLayoutSubviews**

At any time if memory gets low, you might get

https://developer.apple.com/documentation/uikit/uiviewcontroller/4195485-viewisappearing

**didReceiveMemoryWarning**


