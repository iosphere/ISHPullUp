//
//  ISHPullUpRoundedView.m
//  ISHPullUp
//
//  Created by Felix Lamouroux on 28.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPullUpRoundedView.h"
@interface ISHPullUpRoundedView()
@property (nonatomic) UIColor *fillColor;
@end

@implementation ISHPullUpRoundedView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupDefaultValues];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setupDefaultValues];
    return self;
}

- (void)setupDefaultValues {
    self.strokeWidth = 1.0 / [UIScreen mainScreen].scale;
    self.strokeColor = [UIColor lightGrayColor];
    self.cornerRadius = 8;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    [self setFillColor:backgroundColor];
}

- (UIColor *)backgroundColor {
    return [UIColor clearColor];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    if ([_strokeColor isEqual:strokeColor]) {
        return;
    }

    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth == strokeWidth) {
        return;
    }

    _strokeWidth = strokeWidth;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }

    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (UIBezierPath *)pathForBounds:(CGRect)bounds {
    CGFloat strokeInset = self.strokeWidth / 2.0;
    // we adjust the bounds on the sides to outset the stroke to be just outside the screen.
    // we adjust the bottom to be outside the bounds of the view.
    CGRect adjustedBounds = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(strokeInset, -strokeInset, -strokeInset, -strokeInset));

    return [UIBezierPath bezierPathWithRoundedRect:adjustedBounds
                                 byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                       cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
}

- (void)setFrame:(CGRect)frame {
    BOOL sizeChanged = !CGSizeEqualToSize(self.frame.size, frame.size);
    [super setFrame:frame];

    if (sizeChanged) {
        [self setNeedsDisplay];
    }
}

- (void)setBounds:(CGRect)bounds {
    BOOL sizeChanged = !CGSizeEqualToSize(self.bounds.size, bounds.size);
    [super setBounds:bounds];

    if (sizeChanged) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [self pathForBounds:rect];
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    [path setLineWidth:self.strokeWidth];
    [path stroke];
    [path fill];
}

@end

@implementation ISHPullUpDimmingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setupDefaultValues];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setupDefaultValues];
    return self;
}

- (void)setupDefaultValues {
    self.backgroundColor = [UIColor clearColor];
}

- (void)setRoundedView:(ISHPullUpRoundedView *)roundedView {
    _roundedView = roundedView;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:rect];

    if (self.roundedView) {
        CGFloat cornerRadius = self.roundedView.cornerRadius;
        // convert roundeview bounds to this coordinate space
        CGRect roundedViewRect = [self convertRect:self.roundedView.bounds fromView:self.roundedView];
        // let rounded view create a path
        UIBezierPath *bottomPath = [self.roundedView pathForBounds:roundedViewRect];

        // append path and use even odd fill rule
        [bezierPath appendPath:bottomPath];
        [bezierPath setUsesEvenOddFillRule:YES];
    }

    [self.color setFill];
    [bezierPath fill];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    if (self.roundedView) {
        CGFloat cornerRadius = self.roundedView.cornerRadius;
        [self setBounds:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0.0, 0.0, -cornerRadius * 2.0, 0.0))];
        [self setNeedsDisplay];
    }
}

@end
