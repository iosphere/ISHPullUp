//
//  ISHPullUpRoundedView.h
//  ISHPullUp
//
//  Created by Felix Lamouroux on 28.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 
 * A view subclass providing corner radius for the top edges and shadow.
 * The shadow is only applied outside of the view content allowing
 * for transparency.
 *
 * When using this subclass as the primary view of a view controller
 * the dimming (using ISHPullUpDimmingView) is automatically adjusted 
 * for the top edges' rounded corners.
 */
IB_DESIGNABLE
@interface ISHPullUpRoundedView : UIView
/// The stroke color used for the edges. Defaults to lightGrayColor.
@property (nonatomic, nullable) IBInspectable UIColor *strokeColor;
/// The stroke width used for the edges. Defaults to 1/screenscale.
@property (nonatomic) IBInspectable CGFloat strokeWidth;
/// The corner radius is used for the top left and top right corners of the view. Default is 8pt.
@property (nonatomic) IBInspectable CGFloat cornerRadius;

/// The shadow opacity is used for the drop shadow above the rounded view. Default is 0.25.
@property (nonatomic) IBInspectable CGFloat shadowOpacity;

/// The shadow radius is used for the drop shadow above the rounded view. Default is 3.
@property (nonatomic) IBInspectable CGFloat shadowRadius;

/// The shadow color is used for the drop shadow above the rounded view. Default is black.
@property (nonatomic, nullable) IBInspectable UIColor *shadowColor;

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
