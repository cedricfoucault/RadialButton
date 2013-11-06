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

@property CGPoint arcCenter;

- (NSAttributedString *)attributedTitle;
- (UIColor *)titleColorForState:(UIControlState)state;

@end

@implementation RadialButton

- (id)initWithCenter:(CGPoint)center radiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
    // Init the view's frame
    
//    CGFloat xFrame = [self xFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
//    CGFloat yFrame = [self yFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
//    CGFloat widthFrame = [self widthFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
//    CGFloat heightFrame = [self heightFrameWithRadiusInner:radiusInner outer:radiusOuter angleMin:angleMin max:angleMax];
//    CGRect viewFrame = CGRectMake((center.x + xFrame), (center.y - yFrame), widthFrame, heightFrame);
//    self = [self initWithFrame:viewFrame];
    self = [self initWithFrame:CGRectZero];
    if (self) {
        // Init parameters
        _arcCenter = center;
        _radiusInner = radiusInner;
        _radiusOuter = radiusOuter;
        _angleMin = angleMin;
        _angleMax = angleMax;
        [self updateFrame];
        self.backgroundColor = [UIColor clearColor];
        [self addTarget:self action:@selector(setNeedsDisplay) forControlEvents:UIControlEventAllTouchEvents];
//        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLabel.textColor = [UIColor whiteColor];
//        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)updateFrame {
    self.frame = CGRectMake(self.arcCenter.x + self.xFrame, self.arcCenter.y - self.yFrame, self.widthFrame, self.heightFrame);
    [self setNeedsDisplay];
}

- (void)setTitle:(NSString *)title {
    _title = [[NSString alloc] initWithString:title];
    [self setNeedsDisplay];
//    self.titleLabel.text = title;
//    CGSize titleSize = [self.titleLabel.attributedText size];
//    CGFloat angleMid = (self.angleMin + self.angleMax) / 2;
//    CGFloat radiusMid = (self.radiusInner + self.radiusOuter) / 2;
//    CGFloat xmid = radiusMid * cos(angleMid) - self.xFrame;
//    CGFloat ymid = self.yFrame - (radiusMid * sin(angleMid));
//    self.titleLabel.frame = CGRectMake(xmid - titleSize.width / 2, ymid - titleSize.height / 2, titleSize.width, titleSize.height);
//    [self.titleLabel setNeedsDisplay];
}

- (NSAttributedString *)attributedTitle {
    NSDictionary *attributes = [[NSDictionary alloc] initWithObjectsAndKeys:
                      [UIFont systemFontOfSize:[UIFont systemFontSize]], NSFontAttributeName,
                      [self titleColorForState:self.state], NSForegroundColorAttributeName, nil];
    return [[NSAttributedString alloc] initWithString:self.title attributes:attributes];
}

- (UIColor *)titleColorForState:(UIControlState)state {
    if (state == UIControlStateHighlighted) {
        return [UIColor blackColor];
    } else {
        return [UIColor whiteColor];
    }
}

- (void)setAngleMax:(CGFloat)angleMax {
    _angleMax = angleMax;
    [self updateFrame];
}

- (void)setAngleMin:(CGFloat)angleMin {
    _angleMin = angleMin;
    [self updateFrame];
}

- (void)setRadiusOuter:(CGFloat)radiusOuter {
    _radiusOuter = radiusOuter;
    [self updateFrame];
}

- (void)setRadiusInner:(CGFloat)radiusInner {
    _radiusInner = radiusInner;
    [self updateFrame];
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

- (CGFloat)yFrame {
//    return (self.radiusInner * sin(self.angleMin));
    return (self.radiusOuter * sin(self.angleMax));
}

- (CGFloat)widthFrame {
    return (self.radiusOuter * cos(self.angleMin) - self.xFrame);
}

- (CGFloat)heightFrame {
//    return (self.radiusOuter * sin(self.angleMax) - self.yFrame);
    return (self.yFrame - self.radiusInner * sin(self.angleMin));
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
    CGSize titleSize = [self.attributedTitle size];
    CGFloat angleMid = (self.angleMin + self.angleMax) / 2;
    CGFloat radiusMid = (self.radiusInner + self.radiusOuter) / 2;
    CGFloat xmid = radiusMid * cos(angleMid) - self.xFrame;
    CGFloat ymid = self.yFrame - (radiusMid * sin(angleMid));
    [self.attributedTitle drawAtPoint:CGPointMake(xmid - titleSize.width / 2, ymid - titleSize.height / 2)];
}

//- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
////    return [self isInside:[touch locationInView:self]];
////    self.titleLabel.textColor = [UIColor blackColor];
//    [self setNeedsDisplay];
//    return YES;
//}

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
//- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
////    self.titleLabel.textColor = [UIColor whiteColor];
//    [self setNeedsDisplay];
//}
//
//- (void)cancelTrackingWithEvent:(UIEvent *)event {
////    self.titleLabel.textColor = [UIColor whiteColor];
//    [self setNeedsDisplay];
//}

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
