//
//  ThumbWheelViewController.h
//  Radial
//
//  Created by Cédric Foucault on 28/10/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThumbWheelDelegate <NSObject>

- (void)copyButtonTapped:(id)sender;
- (void)pasteButtonTapped:(id)sender;
- (void)deleteButtonTapped:(id)sender;

@end

@interface ThumbWheelViewController : NSObject

@property (weak, nonatomic) UIView *view;
@property (weak, nonatomic) id<ThumbWheelDelegate> delegate;

- (id)initWithView:(UIView *)view delegate:(id<ThumbWheelDelegate>)delegate;
//- (void)rotateClockwise:(BOOL)clockwise animated:(BOOL)animated;
- (void)fitToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)moveToLocation:(CGPoint)location;

@end
