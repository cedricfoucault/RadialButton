//
//  RadialButton.m
//  Radial
//
//  Created by Cédric Foucault on 10/18/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "RadialButton.h"

static const CGFloat borderWidth = 0.0;

@interface RadialButton ()

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation RadialButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCenter:(CGPoint)center radiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
    // Init the view's frame
    CGFloat xFrame = [self xFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
    CGFloat yFrame = [self yFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
    CGFloat widthFrame = [self widthFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
    CGFloat heightFrame = [self heightFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
    CGRect viewFrame = CGRectMake((center.x + xFrame), (center.y - yFrame), widthFrame, heightFrame);
    self = [self initWithFrame:viewFrame];
    if (self) {
        // Init parameters
        _radiusInner = radiusInner;
        _radiusOuter = radiusOuter;
        _angleMin = angleMin;
        _angleMax = angleMax;
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    CGSize titleSize = [self.titleLabel.attributedText size];
    self.titleLabel.frame = CGRectMake((self.widthFrame - titleSize.width) / 2, (self.heightFrame - titleSize.height) / 2, titleSize.width, titleSize.height);
    [self.titleLabel setNeedsDisplay];
}

- (CGFloat)widthButton {
    return (self.radiusOuter - self.radiusInner);
}

- (CGFloat)angleButton {
    return (self.angleMax - self.angleMin);
}

- (CGFloat)xFrame {
    return (self.radiusInner * cos(self.angleMax));
}

- (CGFloat)xFrameWithRadiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
    return (radiusInner * cos(angleMax));
}

- (CGFloat)yFrame {
//    return (self.radiusInner * sin(self.angleMin));
    return (self.radiusOuter * sin(self.angleMax));
}

- (CGFloat)yFrameWithRadiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
//    return (radiusInner * sin(angleMin));
    return (radiusOuter * sin(angleMax));
}

- (CGFloat)widthFrame {
    return (self.radiusOuter * cos(self.angleMin) - self.xFrame);
}

- (CGFloat)widthFrameWithRadiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
    return (radiusOuter * cos(angleMin) - [self xFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax]);
}

- (CGFloat)heightFrame {
//    return (self.radiusOuter * sin(self.angleMax) - self.yFrame);
    return (self.yFrame - self.radiusInner * sin(self.angleMin));
}

- (CGFloat)heightFrameWithRadiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
//    return (radiusOuter * sin(angleMax) - [self yFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax]);
    return ([self yFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax] - radiusInner * sin(angleMin));
}

- (CGMutablePathRef)drawPath {
    // create the path
    CGMutablePathRef drawPath = CGPathCreateMutable();
    // start at (xInnerMax, 0)
    CGFloat xInnerMax = self.radiusInner * cos(self.angleMin) - self.xFrame;
//    CGFloat yInnerMax = self.radiusInner * sin(self.angleMax) - self.yFrame;
    CGPathMoveToPoint(drawPath, NULL, xInnerMax, self.heightFrame);
//    CGPathMoveToPoint(drawPath, NULL, 0.0, yInnerMax);
    // add the inner arc
    CGPathAddArc(drawPath, NULL, -self.xFrame, self.yFrame, self.radiusInner, self.angleMin, self.angleMax, false);
//    CGPathAddArc(drawPath, NULL, -self.xFrame, -self.yFrame, self.radiusInner, self.angleMax, self.angleMin, true);
    // add the outer arc and connect the 2 arcs
    CGPathAddArc(drawPath, NULL, -self.xFrame, self.yFrame, self.radiusOuter, self.angleMax, self.angleMin, true);
//    CGPathAddArc(drawPath, NULL, -self.xFrame, -self.yFrame, self.radiusOuter, self.angleMin, self.angleMax, false);
    CGPathCloseSubpath(drawPath);
    return drawPath;
}

- (UIBezierPath *)drawPathUI {
    UIBezierPath *drawPath = [UIBezierPath bezierPath];
    drawPath.lineWidth = borderWidth;
    CGFloat xInnerMax = self.radiusInner * cos(self.angleMin) - self.xFrame;
    [drawPath moveToPoint:CGPointMake(xInnerMax, self.heightFrame)];
    CGFloat angleStart = - self.angleMin;
    CGFloat angleEnd = - self.angleMax;
    [drawPath addArcWithCenter:CGPointMake(-self.xFrame, self.yFrame) radius:self.radiusInner startAngle:angleStart endAngle:angleEnd clockwise:NO];
    [drawPath addArcWithCenter:CGPointMake(-self.xFrame, self.yFrame) radius:self.radiusOuter startAngle:angleEnd endAngle:angleStart clockwise:YES];
    [drawPath closePath];
    return  drawPath;
}

//- (CGMutablePathRef)drawPath {
//    // create the path
//    CGMutablePathRef drawPath = CGPathCreateMutable();
//    // start at (xInnerMax, 0)
//    CGFloat xInnerMax = self.radiusInner * cos(self.angleMin);
//    CGFloat xOuterMin = self.radiusOuter * cos(self.angleMax);
//    // add the inner arc
//    CGPathMoveToPoint(drawPath, NULL, xInnerMax, 0.0);
//    CGPathAddArc(drawPath, NULL, -self.xFrame, -self.yFrame, self.radiusInner, self.angleMin, self.angleMax, false);
//    CGPathCloseSubpath(drawPath);
//    // add the outer arc and connect the 2 arcs
//    CGPathMoveToPoint(drawPath, NULL, xOuterMin, self.yFrame - 1.0);
//    CGPathAddArc(drawPath, NULL, -self.xFrame, -self.yFrame, self.radiusOuter, self.angleMax, self.angleMin, true);
//    CGPathCloseSubpath(drawPath);
//    return drawPath;
//}

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    // get the current graphics context
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    // transform CTM so that y axis points up
//    CGContextSaveGState(context);
////    CGContextTranslateCTM (context, 0, self.heightFrame);
////    CGContextScaleCTM (context, 1,  -1);
//    // get the path to draw
//    CGMutablePathRef drawPath = [self drawPath];
//    // add it to the graphics context
//    CGContextAddPath(context, drawPath);
//    // draw the path (stroke + fill)
//    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); // black stroke
//    CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 1.0); // orange fill
//    CGContextSetLineWidth(context, borderWidth); // border line width
////    CGContextDrawPath(context, kCGPathFillStroke);
////    CGContextDrawPath(context, kCGPathFillStroke);
//    CGContextDrawPath(context, kCGPathStroke);
//    CGPathRelease(drawPath);
//    // restore the default CTM
////    CGContextRestoreGState(context);
//}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1.0); // black stroke
    CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 1.0); // orange fill
    UIBezierPath *drawPath = [self drawPathUI];
    [drawPath stroke];
    [drawPath fill];
    // draw text
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    return [self isInside:[touch locationInView:self]];
    self.titleLabel.textColor = [UIColor blackColor];
    return YES;
}

//
//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
////    return [self isInside:[touch locationInView:self]];
//    if ([self isInside:[touch locationInView:self]]) {
//        NSLog(@"inside");
//        return YES;
//    } else {
//        NSLog(@"outside");
//        return NO;
//    }
//}
//
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    self.titleLabel.textColor = [UIColor whiteColor];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self isInside:point];
}

- (BOOL)isInside:(CGPoint)p {
    // get location in (r, teta) coordinate system
    CGFloat xp = self.xFrame + p.x;
    CGFloat yp = self.yFrame - p.y;
    CGFloat r = sqrt((xp * xp + yp * yp));
    CGFloat teta = acos(xp / r);
    return r >= self.radiusInner && r <= self.radiusOuter && teta >= self.angleMin && teta <= self.angleMax;
}

@end
