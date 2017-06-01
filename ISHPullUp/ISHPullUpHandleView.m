//
//  ISHPullUpHandleView.m
//  ISHPullUp
//
//  Created by Felix Lamouroux on 29.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPullUpHandleView.h"

@interface ISHPullUpHandleView ()
@property (nonatomic) CGRect boundsUsedForCurrentPath;
@end

@implementation ISHPullUpHandleView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setupDefaultsValues];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupDefaultsValues];
    return self;
}

- (void)setupDefaultsValues {
    [self setBackgroundColor:[UIColor clearColor]];
    self.boundsUsedForCurrentPath = CGRectZero;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    self.strokeWidth = 6.0;
    self.strokeColor = [UIColor lightGrayColor];
    self.arrowSize = CGSizeMake(30.0, 5.0);
    [self setState:ISHPullUpHandleStateNeutral animated:NO];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    _strokeWidth = strokeWidth;
    self.shapeLayer.lineWidth = strokeWidth;
    [self invalidateIntrinsicContentSize];
}

- (void)setArrowSize:(CGSize)arrowSize {
    _arrowSize = arrowSize;
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    self.shapeLayer.strokeColor = [strokeColor CGColor];
}

- (void)setState:(ISHPullUpHandleState)state animated:(BOOL)animated {
    ISHPullUpHandleState oldState = _state;

    if (oldState == state) {
        return;
    }

    _state = state;

    UIBezierPath *newPath = [self pathForBounds:self.bounds state:state];

    NSString *keyPath = @"path";
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = (id)self.shapeLayer.path;
    self.shapeLayer.path = [newPath CGPath];
    animation.toValue = (id)self.shapeLayer.path;
    animation.duration = animated ? 0.35 : 0.0;
    [self.shapeLayer addAnimation:animation forKey:keyPath];
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(self.arrowSize.width + self.strokeWidth, self.arrowSize.height + self.strokeWidth);
}

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(self.boundsUsedForCurrentPath, self.bounds)) {
        self.boundsUsedForCurrentPath = self.bounds;
        self.shapeLayer.path = [[self pathForBounds:self.bounds state:self.state] CGPath];
    }
}

- (UIBezierPath *)pathForBounds:(CGRect)bounds state:(ISHPullUpHandleState)state {
    CGFloat arrowHeight = self.arrowSize.height;
    CGSize arrowSpan = CGSizeMake(self.arrowSize.width / 2.0, arrowHeight / 2.0);

    CGFloat offsetMultiplier = 0;
    switch (state) {
        case ISHPullUpHandleStateUp:
            offsetMultiplier = -1;
            break;

        case ISHPullUpHandleStateDown:
            offsetMultiplier = 1;
            break;

        case ISHPullUpHandleStateNeutral:
            offsetMultiplier = 0;
            break;
    }

    CGFloat centerY = CGRectGetMidY(bounds) + offsetMultiplier * arrowHeight / 2.0;
    CGFloat centerX = CGRectGetMidX(bounds);
    CGFloat wingsY = centerY - offsetMultiplier * arrowHeight;

    CGPoint center = CGPointMake(centerX, centerY);
    CGPoint centerRight = CGPointMake(centerX + arrowSpan.width, wingsY);
    CGPoint centerLeft = CGPointMake(centerX - arrowSpan.width, wingsY);

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:centerLeft];
    [bezierPath addLineToPoint:center];
    [bezierPath addLineToPoint:centerRight];
    return bezierPath;
}

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
