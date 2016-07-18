# <img src="icon.png" align="center" width="60" height="60"> ISHPullUp

[![Travis Build Status](https://travis-ci.org/iosphere/ISHPullUp.svg?branch=master)](http://travis-ci.org/iosphere/ISHPullUp)&nbsp;
[![Version](http://cocoapod-badges.herokuapp.com/v/ISHPullUp/badge.png)](http://cocoadocs.org/docsets/ISHPullUp)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

**A vertical split view controller with a pull up gesture as seen in the iOS 10 
Maps app.**

![Screenshot showing sample app in expanded and collapsed state](SupportingFiles/screenshot.jpg)

ISHPullUp provides a simple UIViewControlller subclass with two child controllers. 
The layout can be managed entirely via delegation and is easy to use with autolayout.

[View subclasses](#view-subclasses) are provided to make beautiful iOS 10 style designs easier. 
ISHPullUpHandleView provides a drag handle as seen in the notification center or Maps app 
with three states: up, neutral, down. ISHPullUpRoundedView provides the perfect backing 
view for your bottom view controller with a hairline border and rounded top corners.

Combine it with [`ISHHoverBar`](https://github.com/iosphere/ISHHoverBar) to create a UI resembling 
the iOS 10 Maps app.

## Basic usage

![Screencast explaining the basic implementation details](SupportingFiles/intro.gif)

To use the framework create an instance of `ISHPullUpViewController` and set the 
`contentViewController` and `bottomViewController` properties to your own view controller 
instances. That's it, everything else is optional. 

Implement the appropriate delegates to fine-tune the behaviour. While all delegates are 
optional, the methods of all delegates themselves are mandatory.

You can customize a lot more via the `ISHPullUpViewController` properties:

* When and if the bottom should snap to the collapsed and expanded positions
* At what threshold the content should be dimmed using which color
* If the bottom view controller should be shifted or resized

### Controlling the height using the `sizingDelegate`

The height of the `bottomViewController` is controlled by the `sizingDelegate`. All heights are cached and updated regularly. You can use auto layout to calculate minimum and maximum heights (e.g. via `systemLayoutSizeFitting(UILayoutFittingCompressedSize)`).

You can customize:

* The minimum height (collapsed): `...minimumHeightForBottomViewController...`
* The maximum height (expanded): `...maximumHeightForBottomViewController...`
* Intermediate snap positions: `...targetHeightForBottomViewController...`

As an example, the minimum height is determined by the following delegate callback:
```swift
// Swift
func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat 
```
```objective-c
// ObjC
- (CGFloat)pullUpViewController:(ISHPullUpViewController *)pullUpViewController minimumHeightForBottomViewController:(UIViewController *)bottomVC;
```

The sizing delegate also provides a callback to adjust the layout of the `bottomViewController`: `...updateEdgeInsets:forBottomViewController:`.

### Adjusting the layout of the `contentViewController` using the `contentDelegate`

The view of the `contentViewController` fills the entire view and is partly overlaid by
the view of the `bottomViewController`. In addition the area covered by the bottom view can change. To adjust your layout accordingly you may set the `contentDelegate`. Additionally, we suggest that your content view controller uses a dedicated view as the first child to its own root view that provides layout margins for the rest of the layout. The typical implementation of the content delegate would then look like this:  

```swift
// Swift
func pullUpViewController(_ vc: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController _: UIViewController) {
	layoutView.layoutMargins = edgeInsets
	// call layoutIfNeeded right away to participate in animations
	// this method may be called from within animation blocks
	layoutView.layoutIfNeeded()
}
```
```objective-c
// ObjC
- (void)pullUpViewController:(ISHPullUpViewController *)pullUpViewController updateEdgeInsets:(UIEdgeInsets)edgeInsets forContentViewController:(UIViewController *)contentVC {
	self.layoutView.layoutMargins = edgeInsets;
	// call layoutIfNeeded right away to participate in animations
	// this method may be called from within animation blocks
	[self.layoutView layoutIfNeeded];
}
```

### Reacting to changes in state

The `ISHPullUpViewController` has four states: collapsed, dragging, intermediate, expanded.

You can react to state changes (e.g. to update the state of a `ISHPullUpHandleView`) by 
setting the `stateDelegate` and implementing its only method.

### View subclasses

#### `ISHPullUpRoundedView`

A view subclass providing corner radius for the top edges and shadow.
The shadow is only applied outside of the view content allowing
for transparency.

When using this subclass as the primary view for the bottom view controller
the dimming (using `ISHPullUpDimmingView`) is automatically adjusted 
for the top edges' rounded corners.

You can configure most properties via *Interface Builder* or code including:

* Shadow: opacity, offset, color, and radius
* Stroke: color and line width
* Corner radius

The `ISHPullUpRoundedVisualEffectView` subclass uses a UIVisualEffectView as a background.

#### `ISHPullUpHandleView` 

The `ISHPullUpHandleView` can be used anywhere in your view hierarchy to show a drag handle. It provides three states (up, neutral, and down) and can animate between the states. Changing the state is up to the implementation allowing you to either match the state of the pullup view controller or to always display it in a neutral state.

The frame should not be set explicitly. You should rather use the intrinsic content size and rely on auto layout. In *Interface Builder* wait for the framework to be compiled once for the `intrinsicContentSize` to be correctly applied to your `XIB`.
  
You can configure most aspects via  *Interface Builder* or code including:

* Size of the arrow
* Stroke: color and width
* State (via code only)


## General info

The framework is written in **Objective-C** to allow easy integration into any iOS project 
and has fully documented headers. All classes are annotated for easy integration into 
*Swift* code bases.

The sample app is written in **Swift 3** and thus requires *Xcode 8* to compile.

The framework and sample app have a **Deployment Target** of **iOS 8**.

## Integration into your project

### Dynamically-Linked Framework

Add the project file `ISHPullUp.xcodeproj` as a subproject of your app. 
Then add the framework `ISHPullUp.framework` to the app's embedded binaries 
(on the *General* tab of your app target's settings). On the *Build Phases* tab, 
verify that the framework has also been added to the *Link Binary with
Libraries* phase, and that an *Embed Frameworks* phase has been created (unless
it existed before).

The framework can be used as a module, so you can use `@import ISHPullUp;`
(Objective-C) and `import ISHPullUp` (Swift) to import all public headers. 

Further reading on Modules: 
[Clang Documentation](http://clang.llvm.org/docs/Modules.html)

### Include files directly

Currently the project relies on 3 implementation files and their headers. 
You can include them directly into your project:

* `ISHPullUp/ISHPullUpHandleView.h`{`h`/`m`}
* `ISHPullUp/ISHPullUpRoundedView.`{`h`/`m`}
* `ISHPullUp/ISHPullUpViewController.`{`h`/`m`}

### CocoaPods

You can use CocoaPods to install ISHPullUp as a static library. Add this
to your Podfile:

```ruby
target 'MyApp' do
  pod 'ISHPullUp'
end
```

`ISHPullUp` can also be installed as a framework:

```ruby
target 'MyApp' do
  use_frameworks!
  pod 'ISHPullUp'
end
```

See the [official website](https://cocoapods.org/#get_started) to get started with
CocoaPods.

### Carthage

Since `ISHPullUp` can be built as a framework, it supports Carthage, too. Add
this to your Cartfile:

```
github iosphere/ISHPullUp
```

See the [Carthage repository](https://github.com/Carthage/Carthage) to get started
with Carthage.

## More OpenSource projects by iosphere

<img src="https://raw.githubusercontent.com/iosphere/ISHPermissionKit/master/icon.png" align="center" width="40" height="40"> [`ISHPermissionKit`](https://github.com/iosphere/ISHPermissionKit) - A polite and unified way of asking for permission on iOS

<img src="https://raw.githubusercontent.com/iosphere/ISHHoverBar/master/icon.png" align="center" width="40" height="40"> [`ISHHoverBar`](https://github.com/iosphere/ISHHoverBar) - A floating UIToolBar replacement as seen in the iOS 10 Maps app, supporting both vertical and horizontal orientation

## TODO

* [ ] Add modal presentation mode for a bottom view controller
