//
//  ISHPullUpRoundedView.h
//  ISHPullUp
//
//  Created by Felix Lamouroux on 28.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
/// A UIView subclass with
/// rounded corners at the top and a stroke.
@interface ISHPullUpRoundedView : UIView
/// The stroke color used for the edges. Defaults to lightGrayColor.
@property (nonatomic, nullable) IBInspectable UIColor *strokeColor;
/// The stroke width used for the edges. Defaults to 1/screenscale.
@property (nonatomic) IBInspectable CGFloat strokeWidth;
/// The corner radius is used for the top left and top right corners of the view. Default is 8pt.
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@end

/// A ISHPullUpRoundedView subclass which uses a UIVisualEffectView as a background.
@interface ISHPullUpRoundedVisualEffectView : ISHPullUpRoundedView
@property (nonatomic, nullable) UIVisualEffect *effect;
@end

/**
 A view subclass used to dim the content view.

 The main feature is that it takes into account 
 the configuration of a related ISHPullUpRoundedView.
 This works automatically if you use an ISHPullUpRoundedView 
 as the bottomViewController's first child view.
*/
@interface ISHPullUpDimmingView : UIView
/// Optionally the bottom view controller's rounded view to allow dimming the edges around the round corners.
@property (nonatomic, weak, nullable) ISHPullUpRoundedView *roundedView;
/// The dimming color.
@property (nonatomic, nonnull) UIColor *color;
@end
