//
//  ISHPullUpViewController.h
//  ISHPullUp
//
//  Created by Felix Lamouroux on 25.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// The suggested default minimumHeight for the bottomViewController.
extern const CGFloat ISHPullUpViewControllerDefaultMinimumHeight;

@class ISHPullUpViewController;

/**
 *   The view of the contentViewController fills the entire view and is partly overlaid by the
 *   view of the bottomViewController. In addition, the area covered by the bottom view can change.
 *   To adjust your layout accordingly you may set the contentDelegate.
 *
 *   Additionally, we suggest that your content view controller uses a dedicated view as the first child to
 *   its own root view that provides layout margins for the rest of the layout.
 */
@protocol ISHPullUpContentDelegate

/**
 *   Informs the delegate that the area overlayed by the bottomViewController's view changed.
 *
 *   This delegate method should be used to adjust the contentViewController's
 *   layout for the area overlayed by the bottomViewController. 
 *
 *   This method may be called from an animation block.
 *
 *   @param pullUpViewController The caller of this delegate method.
 *   @param edgeInsets The edgeInsets currently overlayed by the bottomViewController's
 *                     view in the contentViewController's view's coordinate sytem.
 *   @param contentVC The content view controller for which the edgeInsets are provided.
 */
- (void)pullUpViewController:(ISHPullUpViewController *)pullUpViewController updateEdgeInsets:(UIEdgeInsets)edgeInsets forContentViewController:(UIViewController *)contentVC;
@end

/**
 *   The height of the bottomViewController is controlled by the sizingDelegate. All heights 
 *   are cached and updated regularly.
 */
@protocol ISHPullUpSizingDelegate

/**
 *   Asks the delegate for the minimum height for the bottomViewController in the collapsed state.
 *
 *   @param pullUpViewController The caller of this delegate method.
 *   @param bottomVC The bottom view controller for which the minimum height should be provided.
 *   @return A nonnegative floating-point value that specifies the minimum height (in points) for the bottomViewController.
 */
- (CGFloat)pullUpViewController:(ISHPullUpViewController *)pullUpViewController minimumHeightForBottomViewController:(UIViewController *)bottomVC;

/**
 *   Asks the delegate for the maximum height for the bottomViewController in the expanded state.
 *
 *   @param pullUpViewController The caller of this delegate method.
 *   @param bottomVC The bottom view controller for which the maximum height should be provided.
 *   @param maximumAvailableHeight The maximum available height for the bottom viewcontroller
 *                                 (already respects the top margin and layout guide).
 *   @return A nonnegative floating-point value that specifies the maximum height (in points) for the bottomViewController.
 */
- (CGFloat)pullUpViewController:(ISHPullUpViewController *)pullUpViewController maximumHeightForBottomViewController:(UIViewController *)bottomVC maximumAvailableHeight:(CGFloat)maximumAvailableHeight;

/**
 *   Tells the delegate when the user finishes dragging the bottomViewController and allows returning a different target height.
 *
 *   @note Please be aware that the snapping behaviour (see snapToEnds and snapThreshold) is
 *         applied on the value returned from the method. The final position of the bottom
 *         view controller may thus differ from the returned value.
 *         Set snapToEnds to NO to override this behaviour and ensure that the value returned is the final position.
 *
 *   @param pullUpViewController The caller of this delegate method.
 *   @param bottomVC The bottom view controller for which the maximum height should be provided.
 *   @param height The current height at which the user stopped dragging.
 *   @return A nonnegative floating-point value that specifies the target height at which the bottomViewController should come to a rest.
 *           Return the provided height if you do not need to adjust the target height.
 *           Changes will be animated and snapped to either end if snapToEnds is YES.
 */
- (CGFloat)pullUpViewController:(ISHPullUpViewController *)pullUpViewController targetHeightForBottomViewController:(UIViewController *)bottomVC fromCurrentHeight:(CGFloat)height;

/**
 *   When using bottom layout mode ISHPullUpBottomLayoutModeShift this method informs 
 *   the delegate that the area of the bottomViewController's view that is currently visible changed.
 *
 *   This delegate method should be used to adjust the content 
 *   inset of scroll views inside the bottomViewController.
 *
 *   This method may be called from an animation block.
 *
 *   @param pullUpViewController The caller of this delegate method.
 *   @param edgeInsets The edgeInsets describing the area
 *          currently not visible of the bottomViewController's view.
 *   @param contentVC The content view controller for which the edgeInsets are provided.
 */
- (void)pullUpViewController:(ISHPullUpViewController *)pullUpViewController updateEdgeInsets:(UIEdgeInsets)edgeInsets forBottomViewController:(UIViewController *)contentVC;
@end

/**
 *   Defines all possible states of the bottom controller.
 */
typedef NS_ENUM (NSUInteger, ISHPullUpState) {
    /// The bottomViewController is shown at its minimum height.
    ISHPullUpStateCollapsed,
    /// The bottomViewController is currently being dragged, or
    /// within a state change animation.
    ISHPullUpStateDragging,
    /// The bottomViewController is currently resting somewhere
    /// between the collapsed and expanded positions.
    ISHPullUpStateIntermediate,
    /// The bottomViewController is shown at its maximum height.
    ISHPullUpStateExpanded,
};

/**
 *   This protocol allows you to react to state changes.
 */
@protocol ISHPullUpStateDelegate

/**
 *   Tells the delegate that the state of the view controller has changed.
 *
 *   This method is also called initially right before the first appearance.
 *
 *   @param pullUpViewController The caller of this delegate method.
 *   @param state The new state of the view controller.
 */
- (void)pullUpViewController:(ISHPullUpViewController *)pullUpViewController didChangeToState:(ISHPullUpState)state;

@end

/// Defines the behaviour of the bottom controller when not entirely
/// on screen.
typedef NS_ENUM(NSUInteger, ISHPullUpBottomLayoutMode) {
    /// The bottom view controller is only shifted and is never resized below its maximum height. Recommended mode.
    ISHPullUpBottomLayoutModeShift,
    /// The bottom view controller is shifted and resized to match the current user gesture input.
    /// Might cause issues with scrollviews.
    ISHPullUpBottomLayoutModeResize,
};

/**
 *   Defines a set of options to configure an animation.
 */
struct ISHPullUpAnimationConfiguration {
    /// Duration of the animation.
    CGFloat duration;
    /// The spring damping of the animation.
    CGFloat springDamping;
    /// The initial spring velocity of the animation.
    CGFloat initialVelocity;
    /// Further options of the animation. Should always include
    /// UIViewAnimationOptionLayoutSubviews.
    UIViewAnimationOptions options;
};
typedef struct ISHPullUpAnimationConfiguration ISHPullUpAnimationConfiguration;

/**
 *   A container view controller combining a fullscreen content
 *   and a dragable bottom view controller.
 *
 *   The bottom view controller can be dragged up using a built-in pan gesture.
 */
@interface ISHPullUpViewController : UIViewController

/**
 *   The contentViewController is displayed full screen behind the bottomViewController.
 *
 *   Use the contentDelegate to adjust its layout for the area overlayed by
 *   the bottomViewController.
 */
@property (nonatomic, nullable) UIViewController *contentViewController;

/**
 *   The bottomViewController is displayed at the bottom of this view controller
 *   over the contentViewController.
 *
 *   Use sizingDelegate to configure the minimum and maximum height and to provide
 *   targetHeight steps for intermediate drag positions.
 *
 *   Use the stateDelegate to receive information about state changes.
 */
@property (nonatomic, nullable) UIViewController *bottomViewController;

/// The layout mode to be used for the bottom view controller. Default is ISHPullUpBottomLayoutModeShift.
@property (nonatomic) ISHPullUpBottomLayoutMode bottomLayoutMode;

/// The contentDelegate should be used to adjust the contentViewController's
/// layout for the area overlayed by the bottomViewController.
@property (nonatomic, nullable, weak) id<ISHPullUpContentDelegate> contentDelegate;

/// Use sizingDelegate to configure the minimum and maximum height of the bottomViewController.
/// It can also be used to provide targetHeight steps for intermediate drag positions.
@property (nonatomic, nullable, weak) id<ISHPullUpSizingDelegate> sizingDelegate;

/// The stateDelegate provides information about state changes.
@property (nonatomic, nullable, weak) id<ISHPullUpStateDelegate> stateDelegate;

/// If YES the bottomViewController snaps to the top or bottom when dragging ends near one of the ends. Default is YES.
@property (nonatomic) BOOL snapToEnds;

/***
 *  The threshold as a relative value ]0-1[ of the total height.
 *  If the user stops dragging within this threshold of
 *  either end. The bottom view controller will snap
 *  to the closest end. Default is 0.25.
 */
@property (nonatomic) CGFloat snapThreshold;

/// The current state of the view controller.
@property (nonatomic, readonly) ISHPullUpState state;

/**
 *   The animation configuration used for animated state changes. 
 *   You can either set this property to adjust the animation, or
 *   read this property to get the default configuration that you
 *   can use in other animations.
 */
@property (nonatomic) ISHPullUpAnimationConfiguration animationConfiguration;

/**
 *   When the controller is locked, its state cannot be changed by
 *   dragging or tapping. The controller can be locked in collapsed,
 *   intermediate, or expanded state.
 *   
 *   The state can still be changed programmatically or by external
 *   gestures.
 *
 *   Defaults to NO.
 */
@property (nonatomic, getter=isLocked) BOOL locked;

/**
 *   Sets the current state of the view controller with(out) animation.
 *
 *   @param state The new state of the view controller.
 *                Setting the state to ISHPullUpStateIntermediate or ISHPullUpStateDragging has no effect.
 *   @param animated If YES the change in state is animated.
 *   @warning Calling this method with ISHPullUpStateIntermediate or ISHPullUpStateDragging triggers an assert.
 */
- (void)setState:(ISHPullUpState)state animated:(BOOL)animated;

/**
 *   Toggle the state of the view controller.
 *   If the current state is ISHPullUpStateCollapsed,
 *   the state will be changed to ISHPullUpStateExpanded.
 *   Otherwise the state will be changed to ISHPullUpStateCollapsed.
 *
 *   @param animated If YES the change in state is animated.
 */
- (void)toggleStateAnimated:(BOOL)animated;

/**
 *   The sizingDelegate can provide a maximum height,
 *   which is constrained to the maximum available
 *   height minus this topMargin. Default is 20pt.
 */
@property (nonatomic) CGFloat topMargin;

/// The color used for dimming the content.
/// Set to nil to disable dimming. Default is black with 40% alpha.
@property (nonatomic, nullable) UIColor *dimmingColor;

/// The threshold at which the content should be dimmed relative to the
/// difference between minimum and maximum height. Default is 0.5 meaning
/// that dimming will start half way between min and max height.
@property (nonatomic) CGFloat dimmingThreshold;

/// Returns the current model value for the height of the bottomViewController.
@property (nonatomic, readonly) CGFloat bottomHeight;

/** 
 *   Set the bottom height directly.
 *
 *   @param bottomHeight The new bottom height.
 *   @param animated If YES the height change is animated.
 *
 *   @note: This will not perform any "sanity" checks or snapping.
 */
- (void)setBottomHeight:(CGFloat)bottomHeight animated:(BOOL)animated;

/// Call this method when the minimum or maximum values change.
- (void)invalidateLayout;
@end

NS_ASSUME_NONNULL_END
