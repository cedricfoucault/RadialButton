//
//  SPadView.m
//  Radial
//
//  Created by Cédric Foucault on 08/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "SPadContainerView.h"

@interface SPadContainerView ()

@property (strong, nonatomic) IBOutlet UIView *sPadView;
@property (weak, nonatomic) IBOutlet UIButton *sPadTouchCircle;

@end

@implementation SPadContainerView

- (void)_updateFrame {
    self.frame = CGRectMake(self.jointCenter.x + self.xFromJoint, self.jointCenter.y + self.yFromJoint,
                            self.widthFrame, self.heightFrame);
    [self setNeedsDisplay];
}

- (void)setJointCenter:(CGPoint)jointCenter {
    _jointCenter = jointCenter;
    [self _updateFrame];
}

- (void)setRadiusInner:(CGFloat)radiusInner {
    _radiusInner = radiusInner;
    [self _updateFrame];
}

- (void)setRadiusOuter:(CGFloat)radiusOuter {
    _radiusOuter = radiusOuter;
    [self _updateFrame];
}

- (void)setAngleMin:(CGFloat)angleMin {
    _angleMin = angleMin;
    [self _updateFrame];
}

- (void)setAngleMax:(CGFloat)angleMax {
    _angleMax = angleMax;
    [self _updateFrame];
}

- (CGFloat)yFromJoint {
    return - self.radiusInner * sin(self.angleMax);
}

- (CGFloat)widthFrame {
    return self.radiusInner * cos(self.angleMin) - self.xFromJoint;
}

- (CGFloat)heightFrame {
    return (- self.xFromJoint * tan(self.angleMin)) - self.yFromJoint;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return [self isInside:point];
}

- (BOOL)isInside:(CGPoint)p {
    // get location in (r, teta) coordinate system
    CGFloat xpFromJoint = self.xFromJoint + p.x;
    CGFloat ypFromJoint = self.yFromJoint + p.y;
    CGFloat r = sqrt((xpFromJoint * xpFromJoint + ypFromJoint * ypFromJoint));
    CGFloat teta = acos(xpFromJoint / r);
    return p.x >= 0.0 && r <= self.radiusInner && teta >= self.angleMin && teta <= self.angleMax;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
