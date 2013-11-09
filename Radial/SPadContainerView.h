//
//  SPadView.h
//  Radial
//
//  Created by Cédric Foucault on 08/11/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPadContainerView : UIView

@property (nonatomic) CGPoint jointCenter;
@property (nonatomic) CGFloat radiusInner;
@property (nonatomic) CGFloat radiusOuter;
@property (nonatomic) CGFloat angleMin; // radians
@property (nonatomic) CGFloat angleMax; // radians
@property (nonatomic) CGFloat xFromJoint;

@end
