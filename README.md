# <img src="icon.png" align="center" width="60" height="60"> ISHPullUp

[![Travis Build Status](https://travis-ci.org/iosphere/ISHPullUp.svg?branch=master)](http://travis-ci.org/iosphere/ISHPullUp)&nbsp;

**A vertical split view controller with a pull up gesture as seen in the iOS 10 
Maps app.**

ISHPullUp provides a simple UIViewControlller subclass with two child controllers. 
The layout can be managed entirely via delegation and is easy to use with autolayout.

Two view subclasses are provided to make beautiful iOS10 style designs easier. 
ISHPullUpHandleView provides a drag handle as seen in the notification center or Maps app 
with three states: up, neutral, down. ISHPullUpRoundedView provides the perfect backing 
view for your bottom view controller with a hairline border and rounded top corners.