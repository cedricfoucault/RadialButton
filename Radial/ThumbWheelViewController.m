//
//  ThumbWheelViewController.m
//  Radial
//
//  Created by Cédric Foucault on 28/10/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ThumbWheelViewController.h"
#import "RadialButton.h"
#import "UIDevice+Hardware.h"
#import "UIScreen+PhysicalSize.h"

#define DEGREES_TO_RADIANS(degrees) ((degrees) * (M_PI / 180.0))
#define RADIANS_TO_DEGREES(degrees) ((degrees) * (180.0 / M_PI))

const NSUInteger RADIUS_OUTER_MM = 110;
const NSUInteger RADIUS_INNER_MM = 90;
const NSUInteger THUMB_JOINT_MM_FROM_SCREEN = 40.39;
//const NSUInteger THUMB_JOINT_MM_FROM_SCREEN = 31.;
const NSUInteger THUMB_JOINT_MM_FROM_BEZEL = 21.11;

@interface ThumbWheelViewController ()

@property (strong, nonatomic) RadialButton *buttonTop;
@property (strong, nonatomic) RadialButton *buttonMiddle;
@property (strong, nonatomic) RadialButton *buttonBottom;
@property (strong, nonatomic) NSTimer *animationTimer;
@property NSUInteger animationRepeatCountdown;

@end

@implementation ThumbWheelViewController

- (id)initWithView:(UIView *)view delegate:(id<ThumbWheelDelegate>)delegate {
    self = [super init];
    if (self) {
        _view = view;
        _delegate = delegate;
        [self _init];
    }
    return self;
}

- (void)_init {
    // Get sizes
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat radiusOuter = [screen ptFromMm:RADIUS_OUTER_MM];
    CGFloat radiusInner = [screen ptFromMm:RADIUS_INNER_MM];
//    CGFloat frame_x = - [screen ptFromMm:THUMB_JOINT_MM_FROM_SCREEN];
    CGFloat frame_x = - [screen ptFromMm:(THUMB_JOINT_MM_FROM_BEZEL + [device bezelWidthMmWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation])];
//    CGFloat frame_x = 0.0;
//    NSLog(@"outer: %f, inner: %f, frame_x: %f", radiusOuter, radiusInner, frame_x);
    CGFloat angleMinDeg = 29.5;
    CGFloat angleMinRad = DEGREES_TO_RADIANS(angleMinDeg);
    CGFloat angleMaxRad = acos(- frame_x / radiusInner);
//    NSLog(@"angleMaxDeg: %f", RADIANS_TO_DEGREES(angleMaxRad));
    CGFloat angleRangeRad = angleMaxRad - angleMinRad;
    CGFloat angleStepRad = angleRangeRad / 3;
    // Configure frame view
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;
//    NSLayoutConstraint *squareConstraint = [NSLayoutConstraint constraintWithItem:self.view
//                                                                        attribute:NSLayoutAttributeWidth
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:self.view
//                                                                        attribute:NSLayoutAttributeHeight
//                                                                       multiplier:1.0 constant:0.0];
//    [self.view addConstraint:squareConstraint];
    self.view.frame = CGRectMake(frame_x, self.view.frame.origin.y, radiusOuter, radiusOuter);
//    NSLog(@"frame: (%f, %f, %f, %f)", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    // Configure radial buttons
    CGFloat squareSize = MIN(self.view.bounds.size.height, self.view.bounds.size.width);
    CGPoint center = CGPointMake(0.0, squareSize - 1);
    
    self.buttonBottom = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter
                                                 angleMin:angleMinRad max:(angleMinRad + angleStepRad)];
    self.buttonMiddle = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter
                                                    angleMin:(angleMinRad + angleStepRad) max:(angleMinRad + 2 * angleStepRad)];
    self.buttonTop = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter
                                                    angleMin:(angleMinRad + 2 * angleStepRad) max:(angleMinRad + 3 * angleStepRad)];
    
//    __block ThumbWheelViewController *blockSelf = self;
//    blockSelf.buttonTop.angleMax -= DEGREES_TO_RADIANS(30);
//    blockSelf.buttonTop.angleMin -= DEGREES_TO_RADIANS(30);
//    blockSelf.buttonMiddle.angleMax -= DEGREES_TO_RADIANS(30);
//    blockSelf.buttonMiddle.angleMin -= DEGREES_TO_RADIANS(30);
//    blockSelf.buttonBottom.angleMax -= DEGREES_TO_RADIANS(30);
//    blockSelf.buttonBottom.angleMin -= DEGREES_TO_RADIANS(30);
    [self.view addSubview:self.buttonTop];
    [self.view addSubview:self.buttonMiddle];
    [self.view addSubview:self.buttonBottom];
//    [self.view addSubview:buttonOutside];
    self.buttonTop.title = @"copy";
    self.buttonMiddle.title = @"paste";
    self.buttonBottom.title = @"delete";
    
    [self.buttonTop addTarget:self.delegate action:@selector(copyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonMiddle addTarget:self.delegate action:@selector(pasteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonBottom addTarget:self.delegate action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)fitToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    // Get sizes
    UIDevice *device = [UIDevice currentDevice];
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat radiusInner = [screen ptFromMm:RADIUS_INNER_MM];
//    CGFloat frame_xMm = THUMB_JOINT_MM_FROM_BEZEL + [device bezelWidthMmWithInterfaceOrientation:toInterfaceOrientation];
//    NSLog(@"thumb joint: %f mm from screen", frame_xMm);
    CGFloat frame_x = - [screen ptFromMm:(THUMB_JOINT_MM_FROM_BEZEL + [device bezelWidthMmWithInterfaceOrientation:toInterfaceOrientation])];
    CGFloat angleMinDeg = 29.5;
    CGFloat angleMinRad = DEGREES_TO_RADIANS(angleMinDeg);
    CGFloat angleMaxRad = acos(- frame_x / radiusInner);
    //    NSLog(@"angleMaxDeg: %f", RADIANS_TO_DEGREES(angleMaxRad));
    CGFloat angleRangeRad = angleMaxRad - angleMinRad;
    CGFloat angleStepRad = angleRangeRad / 3;
    // Configure frame view
    //    [self.view addConstraint:squareConstraint];
    self.view.frame = CGRectMake(frame_x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    //    NSLog(@"frame: (%f, %f, %f, %f)", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    // Configure radial buttons
    CGFloat angle = angleMinRad + angleStepRad;
    self.buttonBottom.angleMax = angle;
    self.buttonMiddle.angleMin = angle;
    angle += angleStepRad;
    self.buttonMiddle.angleMax = angle;
    self.buttonTop.angleMin = angle;
    angle += angleStepRad;
    self.buttonTop.angleMax = angle;
}

//- (void)rotateClockwise:(BOOL)clockwise animated:(BOOL)animated{
////    __block ThumbWheelViewController *blockSelf = self;
////    void (^rotateOperation)() = clockwise ? ^(){
////        blockSelf.buttonTop.angleMax -= DEGREES_TO_RADIANS(30);
////        blockSelf.buttonTop.angleMin -= DEGREES_TO_RADIANS(30);
////        blockSelf.buttonMiddle.angleMax -= DEGREES_TO_RADIANS(30);
////        blockSelf.buttonMiddle.angleMin -= DEGREES_TO_RADIANS(30);
////        blockSelf.buttonBottom.angleMax -= DEGREES_TO_RADIANS(30);
////        blockSelf.buttonBottom.angleMin -= DEGREES_TO_RADIANS(30);
////    } : ^(){
////        blockSelf.buttonTop.angleMax += DEGREES_TO_RADIANS(30);
////        blockSelf.buttonTop.angleMin += DEGREES_TO_RADIANS(30);
////        blockSelf.buttonMiddle.angleMax += DEGREES_TO_RADIANS(30);
////        blockSelf.buttonMiddle.angleMin += DEGREES_TO_RADIANS(30);
////        blockSelf.buttonBottom.angleMax += DEGREES_TO_RADIANS(30);
////        blockSelf.buttonBottom.angleMin += DEGREES_TO_RADIANS(30);
////    };
//    double angleRotation = clockwise ? (- DEGREES_TO_RADIANS(30)) : DEGREES_TO_RADIANS(30);
//    if (animated) {
//        double fps = 200.0;
//        double animationDuration = 0.5;
//        self.animationRepeatCountdown = floor(animationDuration * fps);
//        double angleIncrement = angleRotation / self.animationRepeatCountdown;
//        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithDouble:angleIncrement], @"angleIncrement", nil];
//        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(animationDuration / fps) target:self selector:@selector(rotateFrameIncrement:) userInfo:userInfo repeats:YES];
////        [UIView animateWithDuration:1.0 animations:rotateOperation];
////        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:rotateOperation completion:nil];
//        [self.animationTimer fire];
//    } else {
////        rotateOperation();
//    }
//}
//
//- (void)rotateFrameIncrement:(NSTimer *)timer {
//    if (self.animationRepeatCountdown > 0) {
//        NSDictionary *userInfo = [timer userInfo];
//        NSNumber *angleIncrementNumber = [userInfo objectForKey:@"angleIncrement"];
//        double angleIncrement = [angleIncrementNumber doubleValue];
//        self.buttonTop.angleMax += angleIncrement;
//        self.buttonTop.angleMin += angleIncrement;
//        self.buttonMiddle.angleMax += angleIncrement;
//        self.buttonMiddle.angleMin += angleIncrement;
//        self.buttonBottom.angleMax += angleIncrement;
//        self.buttonBottom.angleMin += angleIncrement;
//        self.animationRepeatCountdown--;
//    } else {
//        [self.animationTimer invalidate];
//        self.animationTimer = nil;
//    }
//}

@end
