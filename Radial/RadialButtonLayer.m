//
//  RadialButtonLayer.m
//  Radial
//
//  Created by Cédric Foucault on 28/10/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "RadialButtonLayer.h"

static const CGFloat borderWidth = 0.0;

@implementation RadialButtonLayer

+ (BOOL) needsDisplayForKey:(NSString *) key {
    NSArray *customKeys = @[@"arcCenter", @"angleMax", @"angleMin", @"radiusInner", @"radiusOuter"];
    return ([super needsDisplayForKey:key] || [customKeys containsObject:key]);
}

- (id)initWithCenter:(CGPoint)center radiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax {
    self = [self init];
    if (self) {
        _arcCenter = center;
        _radiusInner = radiusInner;
        _radiusOuter = radiusOuter;
        _angleMin = angleMin;
        _angleMax = angleMax;
        CGFloat rgba[4] = {0.5, 0.5, 0.5, 1.0};
        self.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), rgba);
    }
    return self;
}

- (void)updateFrame {
    self.frame = CGRectMake(self.arcCenter.x + self.xFrame, self.arcCenter.y - self.yFrame, self.widthFrame, self.heightFrame);
    [self setNeedsDisplay];
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

-(void)drawInContext:(CGContextRef)ctx {
    // Drawing code
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 1.0); // black stroke
    CGContextSetRGBFillColor(ctx, 1.0, 0.5, 0.0, 1.0); // orange fill
    UIBezierPath *drawPath = [self drawPathUI];
    [drawPath stroke];
    [drawPath fill];
}

@end
