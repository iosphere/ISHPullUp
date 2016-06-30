//
//  ISHPullUpHandleView.h
//  ISHPullUp
//
//  Created by Felix Lamouroux on 29.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPullUpViewController.h"

// Enum describing the state of a ISHPullUpHandleView
typedef NS_ENUM(NSUInteger, ISHPullUpHandleState) {
    ISHPullUpHandleStateUp,
    ISHPullUpHandleStateNeutral,
    ISHPullUpHandleStateDown,
};

/// Provides a view similar to the handle views seen in notification center and maps.
IB_DESIGNABLE
@interface ISHPullUpHandleView : UIView
/// The maximum size of the arrow (when using states up/down). Default matches the notification center style.
@property (nonatomic) IBInspectable CGSize arrowSize;
/// The stroke width of the arrow. Default matches the notification center style.
@property (nonatomic) IBInspectable CGFloat strokeWidth;
/// The stroke color of the arrow. Default is lightGrayColor.
@property (nonatomic, nonnull) IBInspectable UIColor *strokeColor;

/// The current state of the handle view.
@property (nonatomic, readonly) ISHPullUpHandleState state;
/// Set state of the handle view with or without animation.
- (void)setState:(ISHPullUpHandleState)state animated:(BOOL)animated;

/// Helper method to convert ISHPullUpState to ISHPullUpHandleState.
+ (ISHPullUpHandleState)handleStateForPullUpState:(ISHPullUpState) state;
@end
