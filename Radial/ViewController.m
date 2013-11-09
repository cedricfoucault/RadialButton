//
//  ViewController.m
//  Radial
//
//  Created by Cédric Foucault on 10/18/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ViewController.h"
#import "RadialButton.h"
#import "UIDevice+Hardware.h"
#import "UIScreen+PhysicalSize.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
- (IBAction)handleTap:(UITapGestureRecognizer *)sender;
@property (strong, nonatomic) ThumbWheelViewController *thumbWheelViewController;
@property (weak, nonatomic) IBOutlet UIView *thumbWheelView;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tripleTapRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.thumbWheelViewController = [[ThumbWheelViewController alloc] initWithView:self.thumbWheelView delegate:self];
//    self.view.backgroundColor = [UIColor blackColor];
//    CGPoint center = CGPointMake(400.0, 400.0);
//    CGFloat radiusInner = 150.0;
//    CGFloat radiusOuter = 250.0;
//    self.button1 = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter angleMin:(0.0) max:(M_PI / 10.0)];
//    self.button2 = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter angleMin:(M_PI / 10.0) max:(3 * M_PI / 10.0)];
//    self.button3 = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter angleMin:(3 * M_PI / 10.0) max:(M_PI / 2.0)];
//    
//    [self.view addSubview:self.button1];
//    [self.view addSubview:self.button2];
//    [self.view addSubview:self.button3];
//    self.button1.title = @"delete";
//    self.button2.title = @"paste";
//    self.button3.title = @"copy";
//    [self.button1 addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.button2 addTarget:self action:@selector(pasteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.button3 addTarget:self action:@selector(copyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.thumbWheelViewController fitToInterfaceOrientation:toInterfaceOrientation];
}

- (void)copyButtonTapped:(id)sender {
//    NSLog(@"copy!");
    self.statusLabel.text = @"copy!";
}

- (void)pasteButtonTapped:(id)sender {
//    NSLog(@"paste!");
    self.statusLabel.text = @"paste!";
}

- (void)deleteButtonTapped:(id)sender {
//    NSLog(@"delete!");
    self.statusLabel.text = @"delete!";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
//        if (self.view.backgroundColor == [UIColor blackColor]) {
//            self.view.backgroundColor = [UIColor greenColor];
//        } else {
//            self.view.backgroundColor = [UIColor blackColor];
//        }
        CGPoint location = [sender locationInView:self.view];
        [self.thumbWheelViewController moveToLocation:location];
//        self.thumbWheelView.frame = CGRectMake(self.thumbWheelView.frame.origin.x,
//                                               location.y - self.thumbWheelView.frame.size.height / 2,
//                                               self.thumbWheelView.frame.size.width, self.thumbWheelView.frame.size.height);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tripleTapRecognizer) {
        // Disallow recognition of triple tap in any UIControl
        if ([touch.view isKindOfClass:[UIControl class]]) {
            return  NO;
        }
    }
    return YES;
}

@end
