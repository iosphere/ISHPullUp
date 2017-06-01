# <img src="icon.png" align="center" width="60" height="60"> Changelog

## 1.0.5

* Support view controller containment: `ISHPullUpViewController` (or subclasses thereof) can now be embedded in container view controllers that make use of the bottom layout guide (e.g., `UITabBarController`)

## 1.0.4

* Allow PullUp to be locked
* Use `ISHPullUpStateDragging` when an animation is currently running
* Minor Xcode project modernizations

## 1.0.3

* Fix layout issues after rotation while view controller was hidden
* Fix layout issues related to in call status bar

## 1.0.2

* Improved documentation.

## 1.0.0 and 1.0.1

* Add ISHPullUpRoundedView subclass using a UIVisualEffectView.
* Add shadow to rounded view.
* Add method to invalidate layout externally.
* Fix animations and layout during animation
* Fix bug where dimming would not be hidden for small differences between minimum and maximum height.
* Fix an issue where an assertion would load the view of a child vc.
* Fix an issue where dimming view was not removed when removing the bottom view controller.
* Improve subclass-ability by add dimming view at correct index to view rather than sending it to the front.

## 0.9.0

* Initial release. 
