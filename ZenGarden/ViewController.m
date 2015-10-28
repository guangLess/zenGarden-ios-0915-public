//
//  ViewController.m
//  ZenGarden
//
//  Created by Guang on 10/28/15.
//  Copyright © 2015 Guang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *rakeImage;
@property (weak, nonatomic) IBOutlet UIImageView *rock1Image;
@property (weak, nonatomic) IBOutlet UIImageView *swordinrockImage;
@property (weak, nonatomic) IBOutlet UIImageView *shrubImage;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinLeftConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinTopConstrain;

@property (nonatomic, assign) CGFloat initialTopConstant;
@property (nonatomic, assign) CGFloat initialLeftConstant;

@property (nonatomic, assign) CGFloat rock1InitialTopConstant;
@property (nonatomic, assign) CGFloat rock1InitialLeftConstant;

@property (nonatomic, assign) CGFloat shrubInitialTopConstant;
@property (nonatomic, assign) CGFloat shrubInitialLeftConstant;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rock1PanConstrainX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rock1PanConstrainY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shrubPanConstrainX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shrubPanConstrainY;
@property (weak, nonatomic) IBOutlet UILabel *blueDot;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.initialTopConstant = self.pinTopConstrain.constant;
    self.initialLeftConstant = self.pinLeftConstrain.constant;
    
    self.rock1InitialTopConstant = self.rock1PanConstrainY.constant;
    self.rock1InitialLeftConstant = self.rock1PanConstrainX.constant;
    
    self.shrubInitialTopConstant = self.shrubPanConstrainY.constant;
    self.shrubInitialLeftConstant = self.shrubPanConstrainX.constant;
    
    NSLog(@"center point are (%.02f , %02.f)",self.view.center.x,self.view.center.y);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - panGestures
-(IBAction)rakeTap:(UITapGestureRecognizer *)sender{
    NSLog(@"rakeTapped!");
    self.rakeImage.backgroundColor = [UIColor brownColor];
    if (sender.numberOfTapsRequired == 2){
        self.rakeImage.backgroundColor = [UIColor greenColor];

    };
}

- (IBAction)rakePan:(UIPanGestureRecognizer *)sender {
    
    CGPoint  translation = [sender translationInView:self.view];
    self.pinTopConstrain.constant = self.initialTopConstant + translation.y;
    self.pinLeftConstrain.constant = self.initialLeftConstant + translation.x;// - self.initialLeftConstant;
    NSLog(@"rake position->(%.02f,%.02f)",self.rakeImage.center.x, self.rakeImage.center.y);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.initialTopConstant = self.pinTopConstrain.constant;
        self.initialLeftConstant = self.pinLeftConstrain.constant;
    }
    [self positionStuff];

}
- (IBAction)rock1Pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    self.rock1PanConstrainY.constant = self.rock1InitialTopConstant + translation.y;
    self.rock1PanConstrainX.constant = self.rock1InitialLeftConstant + translation.x;
    NSLog(@"rock1 position->(%.02f,%.02f)",self.rock1Image.center.x, self.rock1Image.center.y);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.rock1InitialTopConstant = self.rock1PanConstrainY.constant;
        self.rock1InitialLeftConstant = self.rock1PanConstrainX.constant;
    }
    
    [self positionStuff];


}
- (IBAction)shrubPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    self.shrubPanConstrainX.constant = self.shrubInitialLeftConstant + translation.x;
    self.shrubPanConstrainY.constant = self.shrubInitialTopConstant + translation.y;
    NSLog(@"shrub position---->(%.02f,%.02f)",self.shrubImage.center.x, self.shrubImage.center.y);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        self.shrubInitialTopConstant = self.shrubPanConstrainY.constant;
        self.shrubInitialLeftConstant = self.shrubPanConstrainX.constant;
    }
    [self positionStuff];


}

- (IBAction)swordinrockPan:(UIPanGestureRecognizer *)sender {
    
    CGPoint translation = [sender translationInView:self.view];
    CGPoint swordinrockPosition = self.swordinrockImage.center;
    swordinrockPosition.x += translation.x;
    swordinrockPosition.y += translation.y;

    self.swordinrockImage.center = swordinrockPosition;
    [sender setTranslation:CGPointZero inView:self.view];
    
    NSLog(@"swordinrock position------>(%.02f,%.02f)",swordinrockPosition.x,swordinrockPosition.y);
    NSLog(@"swordinrock center position------>(%.02f,%.02f)",self.swordinrockImage.center.x,self.swordinrockImage.center.y);

    [self positionStuff];

}

#pragma mark - checking location.

-(void)positionStuff{
    
    NSLog(@"center point are (%.02f , %02.f)",self.view.center.x,self.view.center.y);
    BOOL swordStatus;
    BOOL nearByStatus;
    BOOL northSouthStatus ;
    
    if (self.swordinrockImage.center.x <= (self.swordinrockImage.frame.size.width)/2)
    {
        swordStatus = YES;
        NSLog(@"swordStatus YES");
        //return swordStatus;
    }
    
    CGFloat dx = fabs(self.shrubImage.center.x - self.rakeImage.center.x);
    CGFloat dy = fabs(self.shrubImage.center.y - self.rakeImage.center.y);
    CGFloat d = 100.0;
    
    if ((dx < d && dy < d) && dx!=dy) {
        nearByStatus = YES;
        NSLog(@"<<<<<<<<<<<--------nearByStatus YES");
    }
    
    if (fabs(self.rock1Image.center.y - self.swordinrockImage.center.y) >= self.view.center.y)
    {
        northSouthStatus = YES;
        NSLog(@"----->>------------------->>>--------northSouthStatusYES");
    }

    if ((swordStatus == YES) && (nearByStatus == YES) && (northSouthStatus == YES)) {
        [self alertViewActive];
    }
    
}

-(void)alertViewActive{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"You found it?" message:@"You are so cool" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- blueDot

- (IBAction)blueDotTap:(UITapGestureRecognizer *)sender{
   self.blueDot.text = @"selected ME";
   self.blueDot.textColor = [UIColor yellowColor];
}
-(IBAction)location:(UITapGestureRecognizer *)sender {
    
}



@end
