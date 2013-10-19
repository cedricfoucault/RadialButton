//
//  ViewController.m
//  Radial
//
//  Created by Cédric Foucault on 10/18/13.
//  Copyright (c) 2013 Cédric Foucault. All rights reserved.
//

#import "ViewController.h"
#import "RadialButton.h"

@interface ViewController ()

@property (strong, nonatomic) RadialButton *button1;
@property (strong, nonatomic) RadialButton *button2;
@property (strong, nonatomic) RadialButton *button3;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.view.backgroundColor = [UIColor blackColor];
    CGPoint center = CGPointMake(400.0, 400.0);
    CGFloat radiusInner = 150.0;
    CGFloat radiusOuter = 250.0;
    self.button1 = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter angleMin:(0.0) max:(M_PI / 10.0)];
    self.button2 = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter angleMin:(M_PI / 10.0) max:(3 * M_PI / 10.0)];
    self.button3 = [[RadialButton alloc] initWithCenter:center radiusInner:radiusInner outer:radiusOuter angleMin:(3 * M_PI / 10.0) max:(M_PI / 2.0)];
    
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
    self.button1.title = @"delete";
    self.button2.title = @"paste";
    self.button3.title = @"copy";
    [self.button1 addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button2 addTarget:self action:@selector(pasteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.button3 addTarget:self action:@selector(copyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
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

@end
