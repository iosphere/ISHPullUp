//
//  ISHPullUpRoundedView.m
//  ISHPullUp
//
//  Created by Felix Lamouroux on 28.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPullUpRoundedView.h"

const CGFloat ISHPullUpRoundedViewDefaultRadius = 8.0;

/**
 * A special shadowing layer that "knocks out" its
 * own content with top corner radius applied from the shadow.
 * The yields a shadow that is only outside and not below the layer itself.
 * This is needed whenever the layer itself has transparency.
 */
@interface ISHPullUpRoundedTopShadowLayer : CALayer
@property (nonatomic) CGFloat radius;
@property (nonatomic) CAShapeLayer *shapeMaskLayer;
@end

@interface ISHPullUpRoundedView()
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) ISHPullUpRoundedTopShadowLayer *shadowLayer;
@end


@implementation ISHPullUpRoundedTopShadowLayer

- (instancetype)init {
    self = [super init];
    [self setShapeMaskLayer:[CAShapeLayer new]];
    [self.shapeMaskLayer setFillColor:[[UIColor blackColor] CGColor]];
    [self.shapeMaskLayer setFillRule:kCAFillRuleEvenOdd];
    [self setShadowOffset:CGSizeZero];
    [self setMask:self.shapeMaskLayer];
    [self setRadius:ISHPullUpRoundedViewDefaultRadius];
    return self;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    [super setShadowRadius:shadowRadius];
    [self setNeedsLayout];
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    [super setShadowOffset:shadowOffset];
    [self setNeedsLayout];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    [self.shapeMaskLayer setFrame:self.bounds];

    // The lip path is the basically our own bounds with top corners rounded using self.radius
    // this defines what shape is casting a shadow
    UIBezierPath *lipPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(self.radius, self.radius)];
    [self setShadowPath:[lipPath CGPath]];

    /*
     we want to mask the area that cast the shadow in order to not show a shadow there
     we do not want to mask the area above (and outside of bounds)
     we use the even-odd fill rule and add the entire bounds as rect plus the shadow length above
     this yields the lip being covered twice (even) while everything above is covered once (odd)
     we use that path as a filled mask leaving only the top visible
    */
    CGFloat defaultShadowPadding = 10;
    // if the shadowOffset and radius are not set explicitly the shadow stil extends beyond 0
    // adding a padding also also avoids accidentally cutting off the shadow by a few pixels
    CGFloat shadowLength = self.shadowOffset.height + self.shadowRadius + defaultShadowPadding;
    [lipPath appendPath:[UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(-shadowLength, -shadowLength, 0, -shadowLength))]];
    [self.shapeMaskLayer setPath:[lipPath CGPath]];
}

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
    [self setShadowLayer:[ISHPullUpRoundedTopShadowLayer new]];
    [self setShadowColor:[UIColor blackColor]];
    [self setShadowOpacity:0.25];
    [self.layer addSublayer:self.shadowLayer];
    [self setStrokeWidth:(1.0 / [UIScreen mainScreen].scale)];
    [self setStrokeColor:[UIColor lightGrayColor]];
    [self setCornerRadius:ISHPullUpRoundedViewDefaultRadius];
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

- (void)setShadowRadius:(CGFloat)shadowRadius {
    [self.shadowLayer setShadowRadius:shadowRadius];
}

- (CGFloat)shadowRadius {
    return [self.shadowLayer shadowRadius];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self.shadowLayer setShadowOpacity:shadowOpacity];
}

- (CGFloat)shadowOpacity {
    return [self.shadowLayer shadowOpacity];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self.shadowLayer setShadowColor:[shadowColor CGColor]];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (_cornerRadius == cornerRadius) {
        return;
    }

    _cornerRadius = cornerRadius;
    [self.shadowLayer setRadius:cornerRadius];
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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.shadowLayer setFrame:self.bounds];
}

@end

@interface ISHPullUpRoundedVisualEffectView ()
@property (nonatomic) UIVisualEffectView *visualEffectsView;
@end

@implementation ISHPullUpRoundedVisualEffectView

- (void)setupDefaultValues {
    self.visualEffectsView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self.visualEffectsView setClipsToBounds:YES];
    [self insertSubview:self.visualEffectsView atIndex:0];
    [super setupDefaultValues];
}

- (UIVisualEffect *)effect {
    return self.visualEffectsView.effect;
}

- (void)setEffect:(UIVisualEffect *)effect {
    [self.visualEffectsView setEffect:effect];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    [super setStrokeWidth:strokeWidth];
    [self setNeedsLayout];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [super setCornerRadius:cornerRadius];
    [self.visualEffectsView.layer setCornerRadius:cornerRadius];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // extend visual effects view below own bounds to hide lower corner radius
    self.visualEffectsView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(self.strokeWidth, 0, -self.cornerRadius, 0));
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
