//
//  RadialButton.h
//  Radial
//
//  Created by Cédric Foucault on 10/18/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadialButton : UIControl

// button parameters
@property (nonatomic) CGFloat radiusInner;
@property (nonatomic) CGFloat radiusOuter;
@property (nonatomic) CGFloat angleMin; // radians
@property (nonatomic) CGFloat angleMax; // radians
@property (copy, nonatomic) NSString *title;

// readonly parameters
@property (readonly, nonatomic) CGFloat widthButton;
@property (readonly, nonatomic) CGFloat angleButton; //radians
@property (readonly, nonatomic) CGFloat xFrame;
@property (readonly, nonatomic) CGFloat yFrame;
@property (readonly, nonatomic) CGFloat widthFrame;
@property (readonly, nonatomic) CGFloat heightFrame;

- (id)initWithCenter:(CGPoint)center radiusInner:(CGFloat)radiusInner outer:(CGFloat)radiusOuter angleMin:(CGFloat)angleMin max:(CGFloat)angleMax;

@end
