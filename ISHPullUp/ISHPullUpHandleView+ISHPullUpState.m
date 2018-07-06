//
//  ISHPullUpHandleView+ISHPullUpState.m
//  ISHPullUp
//
//  Created by Felix Lamouroux on 06.07.18.
//  Copyright © 2018 iosphere GmbH. All rights reserved.
//

#import "ISHPullUpHandleView+ISHPullUpState.h"

@implementation ISHPullUpHandleView (ISHPullUpState)

+ (ISHPullUpHandleState)handleStateForPullUpState:(ISHPullUpState)state {
    switch (state) {
        case ISHPullUpStateDragging:
        case ISHPullUpStateIntermediate:
            return ISHPullUpHandleStateNeutral;

        case ISHPullUpStateExpanded:
            return ISHPullUpHandleStateDown;

        case ISHPullUpStateCollapsed:
            return ISHPullUpHandleStateUp;
    }
}

@end
