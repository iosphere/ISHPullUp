//
//  ISHPullUpHandleView+ISHPullUpState.h
//  ISHPullUp
//
//  Created by Felix Lamouroux on 06.07.18.
//  Copyright © 2018 iosphere GmbH. All rights reserved.
//

#import "ISHPullUpHandleView.h"
#import "ISHPullUpViewController.h"

@interface ISHPullUpHandleView (ISHPullUpState)

/// Helper method to convert ISHPullUpState to ISHPullUpHandleState.
/// @param state An ISHPullUpViewController's state.
/// @return An ISHPullUpHandleView's state, appropriate for the given
/// pull up controller state.
+ (ISHPullUpHandleState)handleStateForPullUpState:(ISHPullUpState)state;

@end
