# Multiple MVCs

**Ios provide some Controllers whose View is "other MVCs":**

``` swift
UITabBarController
UISplitViewController
UINavigationController
```

## UITabBarController

Recommend no more than 5 MVC's

var tabBarItem: UITabBarItem

##UISplitViewController

left - Master
right - Detail
Works for iPad!

## NavigationController

Pushes and pop MVC's off of a stack (like stack of cards) 

Each MVC communicates these contents via its UIViewController's **navigationItem** property

**toolBarItems** at the botom
**rootViewController**

## Accessing the sub-MVCs

You can get the sub-MVCs via the viewControllers property

``` swift
var viewControllers: [UIViewController]? { get set } // can be optional (e.g. for tab bar)
// for a tab bar, they are in order, left to right in the array
// for a split view, [0] is the master and [1] is the detail
// for the navigation controller [0] is the root and the rest are in order on the stack
// even though this is setable, usually setting happens via storyboard, segues, or other
// for example, navigation controller's push and pop methods
``` 
## But how do you get ahold of the SVC, TBC or NC itself?
Every UIViewController knows the Split View, Tab Bar o Navigation Controller it is currently in
These are UIViewController properties 

``` swift
var tabBarController: UITabBarController? { get }
var splitViewController: UISplitViewController? { get }
var navigationController: UINavigationController? { get }
// For example, to get the detail of the split view controller you are in
if let detail: UIViewController? = splitViewController?.viewControllers[1] { ... }
```

Adding (or removing) MVCs from a UINavigationController

``` swift
func pushViewController(_ vc: UIViewController, animated: Bool)
func popViewController(animated: Bool)
// But we usually don't do this. Instead we use Segues. More on this in a moment.
```
## Segues

 * Show Segue (will push in a Navigation Controller, else Modal)
 * Show Detail Segue (will show a detail of a Split View or will push in a Navigation Controller)
 * Modal Segue (take over the entire screen while MVC is up)
 * Popover Segue (make the MVC appear in a little popover window)

### Segues always create a new instance of an MVC!!!

Back button in Navigation Controller is not a segue!!
Segue has Identifiers!

``` swift
func perfornSegue(withIdentifier: String, sender: Any?)
// The sender can be whatever you want (you'll see where it shows up in a moment)
// You can ctr-drag from the Controller itself to another Controller if you're segueing via code
// because in tha case, you'll be specifying the sebder above)  
```

Most important use of the identifier: preparing for a segue

``` swift
func prepare(for swgue: UIStoryBoardSegue, sender: Any?) {
	if let identifier = segue.identifier {
		switch identifier {
		 case "Show Graph":
		 	if let vc = segue.destination as? GraphController? {
		 		vc.property1 = ...
		 		vc.callMethodToSetItUp(...)
		 	}
		 default: break
		}
	}
}
```
**It's crucial to understand that this preparation is happening BEFORE outlets get set!** 

It's a very common bug to prepare an MVC thinking its outlets are set

### Preventing Segues
``` swift
func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool
```
The identifier is one in the storyboard.
The sender is the instigating object(e.g. the button that causing the segue) 
 