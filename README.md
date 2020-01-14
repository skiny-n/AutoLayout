![Logo](./Resources/Logo.png "AutoLayout")

# About

**AutoLayout** is a very light-weight layout framework wrapping Apple's Auto Layout API with super easy chainable syntax to speed up everyday autolayouting tasks.  
Since this framework is just a wrapper, there are no dependencies whatsoever 😊  

Anything Auto Layout can do - AutoLayout can do too - **but with waaaay shorter syntax**. All classes, extensions and functions are documented for autocomplete quick overview. I've been using this library in my personal projects and it saved me tons of time and constraints headache 😩 (looking at you **_Unable to simultaneously satisfy constraints_...**)  

So perhaps it will save you some time as well. **Enjoy!** ❤️  


### Requirements

- iOS 11.0+
- Xcode 10.0+
- Swift 4.0+

### To illustrate the ease of use, here's an example:

![alt text](./Resources/AutoLayout.mov "AutoLayout")

Code for this layout is super simple (whole view is in [example](./AutoLayout/Examples/Examples/VCs/ViewControllerView.swift)):


```swift
// ...in the view controller's view

// Create a container that's constrained to view's safe area
private let container = UIView()
container.autoLayout(in: self).fill(in: safeAreaLayoutGuide, margin: 8).activate()

// Create 5 views
let view1 = BaseView.colored(to: .color1)
let view2 = BaseView.colored(to: .color2)
let view3 = BaseView.colored(to: .color3)
let view4 = BaseView.colored(to: .color4)
let view5 = BaseView.colored(to: .color5)

// Layout the views
let spacing: CGFloat = 8
view1.autoLayout(in: container).top().left().right()
                               .height(to: container, multiplier: 0.2).activate()

view2.autoLayout(in: container).below(spacing, to: view1).left()
                               .widthToParent(multiplier: 1.0/3, constant: -spacing).activate()

view3.autoLayout(in: container).top(to: view2).right().width(to: view2)
                               .height(to: view2).activate()

view4.autoLayout(in: container).centerVertically(to: view2)
                               .horizontallyBetween(view2, and: view3, margin: spacing)
                               .height(to: view2, multiplier: 0.75).activate()

view5.autoLayout(in: container).below(spacing, to: view3).left().right().bottom(48)
                               .height(to: view1).activate()

// And add buttons
let buttonsContainer = UIView()
buttonsContainer.autoLayout(in: container).left().bottom().right().height(40).activate()

var buttons: [UIButton] = { ...create buttons with text, color and action... }

// Distribute the buttons horizontally
buttonsContainer.autoLayout.distributeHorizontally(buttons, spacing: 8).activate()

// And make their widths equal
AutoLayout<UIView>.equalWidths(buttons).activate()

```

**That's it!** Super easy, chainable syntax.



# Main parts of AutoLayout

## AutoLayout Class

The main part is `AutoLayout` class itself. It is a generic class that wraps a `<Source: AnchorProviding>` and manages created `Connection`s (`NSLayoutConstraint` wrappers).  
_Fresh instances of this class are created every time_ you access `UIView.autoLayout(in:)` or `UIView.autoLayout` so there is no Ojb-C association magic or global storages and whatnots.

The first adds the view (source) as a subview to passed in view (also sets `translatesAutoresizingMaskIntoConstraints` to false). And you are ready to do some layout 🙌

You use the second when a view has already a `superview`:

```swift
// ...somewhere else has already been created a view and added as a subview
myView.autoLayout.width(to: otherView, multiplier: 1, constant: -10, priority: .required).activate()

```

Instances of this class serve only to create and keep references to created constraints so it's totally OK to discard them after calling `activate()`, which activates all created constraints:
```swift
myView.autoLayout(in: otherView).centerHorizontally().centerVertically()
                                .width(300).height(relation: <=450).activate()
```

### Changing layout

If you want to change some constraints later, keep an AutoLayout instance around (keep in mind that every instance manages its own constraints):
```swift
private let someView = UIView()
private lazy var someViewLayout = someView.autoLayout(in: self.view)

// when setting up constraints
someViewLayout.top().left().right().height(150).activate()

// later
someViewLayout.findAll(.height).first?.constant = 500
// or use a convenience
someViewLayout.heightConnections.first?.constant = 500

// OR you can keep around just the height connection
let someView = UIView()
let heightConnection = someView.autoLayout(in: self.view).top().left().right().height(150)
                                                         .activate().findAll(.height).first
// or
let heightConnection = someView.autoLayout(in: otherView).top().left().right().height(150)
            .activate().firstHeightConnection                                                         

// and then
heightConnection?.constant = 500

```

### Switching between layouts

Easily switch between layouts by calling `activate()` and `deactivate()`:
```swift
tinyLayout.deactivate()
compactLayout.activate()
```

### Removing all constraints

When you want to remove all constraints from a view and create a new layout, just call `destroy()` on your AutoLayout instance:
```swift
myViewLayout.destroy()
myViewLayout = myView.autoLayout.top().left().right().heightToParent(multiplier: 0.5).activate()
```

## Other parts

Other parts include:  
`Connection` - an NSLayoutConstraint wrapper  
enums `LayoutConnectionSimpleRelation` and `LayoutConnectionMultipliedRelation` - represent relations like equal to (=), greater than or equal to (>=) and less than or equal to (>=). Representing a relation, multiplier, constant and priority.  

`LayoutConnectionSimpleRelation` implements `ExpressibleByFloatLiteral` and `ExpressibleByIntegerLiteral`. And they have their own operators for convenience:
```swift
// Simple relation
myView.autoLayout.below(relation: >=20, to: otherView)

// or
myView.autoLayout.below(relation: .greaterThanOrEqual(to: 20, priority: .required), to: otherView)

// and many more
myView.autoLayout.height(relation: .equal(to: otherView.heightAnchor, multiplier: 1, constant: -100, priority: .defaultHigh))

// or just
myView.autoLayout.height(to: otherView)
myView.autoLayout.height(to: otherView.heightAnchor)

myView.autoLayout.leading(to: otherView)
myView.autoLayout.after(otherView) // myView.leading == otherView.trailing

```


### Lots of conveniences
There's lots of conveniences. You can layout with constants, multipliers, with priorities, to anchors and to other views (including baselines)!

```swift
// Top, Left, Right, Bottom, Leading, Trailing
myView.autoLayout.top().left().right().bottom()
myView.autoLayout.top().leading().trailing().bottom()

myView.autoLayout.top(to: otherView).leading(to: otherView).trailing(to: otherView)
myView.autoLayout.top(20).left(150).right(150).height(relation: <=400)

// Width, Height, Size and Aspect
myView.autoLayout.size(80)
myView.autoLayout.width(80).height(80)
myView.autoLayout.width(80).aspect()
myView.autoLayout.height(relation: >=80)
myView.autoLayout.height(relation: .greaterThanOrEqual(to: otherView.heightAnchor, multiplier: 1, constant: -50, priority: .required))
myView.autoLayout.width(to: otherView).aspect()
myView.autoLayout.width(to: otherView.heightAnchor).aspect()

// Center vertically, center horizontally
myView.autoLayout.centerVertically() // in parent
myView.autoLayout.centerHorizontally(50) // in parent, with offset
myView.autoLayout.centerHorizontally(to: otherView) // to other viiew's centerX

// Edges to parent, edges to other views, edges to layout guides
myView.autoLayout.fillParent(16)
myView.autoLayout.fill(inSafeAreaOf: otherView)
myView.autoLayout.fill(inReadableContentGuideOf: otherView)
myView.autoLayout.top(to: otherView.safeAreaLayoutGuide).bottom(to: otherView.safeAreaLayoutGuide)
myView.autoLayout.leading(to: otherView.readableContentGuide).trailing(to: otherView.readableContentGuide)

```

### Relative layouts
```swift
// Above, Below, Before, After, Horizontally between, Vertically between
myView.autoLayout.above(firstView)
myView.autoLayout.above(20, to: firstView)
myView.autoLayout.below(firstView)
// And between
myView.autoLayout.verticallyBetween(firstView, and: secondView, margin: 20)
// which is same as
myView.autoLayout.below(20, to: firstView).above(20, to: secondView)

myView.autoLayout.before(firstView)
myView.autoLayout.after(30, to: secondView)
// And between
myView.autoLayout.horizontallyBetween(firstView, and: secondView)
// which is same as
myView.autoLayout.after(firstView).before(secondView)

// Equal heights and widths
AutoLayout<UIView>.equalHeights([firstView, secondView]).activate()
AutoLayout<UIView>.equalWidths([firstView, secondView]).activate()
// OR
UIViewLayout.equalHeights([firstView, secondView]).activate()
UIViewLayout.equalWidths([firstView, secondView]).activate()

```

### And of course, distribution ❤️
```swift
// Distribute views equaly in horizontal/vertical direciton (with optional spacing and margin)
container.autoLayout.distributeHorizontally(
    [firstView, secondView, thirdView],
    spacing: 8,
    margin: .init(top: 20, left: 16, bottom: 20, right: 16)
)
```


## Friendly reminders
In debug mode, when you forget to call `activate()` or not-layouted AutoLayout instance gets deallocated without activation, you will be reminded in console:

> ⚠️ AutoLayout has not been activated - was this intentional? Source: MySuperAwesomeView"


## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but Alamofire does support its use on supported platforms.

```swift
dependencies: [
    .package(url: "https://github.com/skiny-n/autolayout", .branch("master"))
]
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate AutoLayout into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "skiny-n/AutoLayout" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `AutoLayout.framework` into your Xcode project.


### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate AutoLayout into your project manually, just drag and drop the **AutoLayout.xcodeproj** into your workspace.


## License

AutoLayout is released under the **MIT** license. See LICENSE for details.


## TODOs: 

[ ] MacOS  
[ ] tvOS  
[ ] More examples  
