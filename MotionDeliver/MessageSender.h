//
//  MessageSender.h
//  MotionDeliver
//
//  Created by yu_hao on 10/17/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface MessageSender : UIViewController <NSStreamDelegate>
{
	NSNetService	*netService;
	NSOutputStream	*outputStream;
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
    
    BOOL messageSwitch;
    int weaponNumber;
    int doFire;
    int angle;
}

@property (nonatomic, retain) NSNetService *netService;
@property (retain, nonatomic) NSString *titleString;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;

@property (retain, nonatomic) IBOutlet UILabel *channel1;
@property (retain, nonatomic) IBOutlet UILabel *channel2;
@property (retain, nonatomic) IBOutlet UILabel *channel3;

- (IBAction)stop:(id)sender;
- (void) startSender;
@property (retain, nonatomic) IBOutlet UIButton *startButton;
@property (retain, nonatomic) IBOutlet UIButton *changeWeapon;
- (IBAction)change:(id)sender;
- (IBAction)fire:(id)sender;
@property (retain, nonatomic) IBOutlet UISlider *slider;
@property (retain, nonatomic) IBOutlet UILabel *angleLable;
- (IBAction)sliderValueChanged:(id)sender;

@end
