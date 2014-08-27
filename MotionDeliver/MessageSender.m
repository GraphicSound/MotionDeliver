//
//  MessageSender.m
//  MotionDeliver
//
//  Created by yu_hao on 10/17/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "MessageSender.h"

@interface MessageSender ()

@end

@implementation MessageSender

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        weaponNumber = 0;
        doFire = 0;
        angle = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@synthesize netService;

- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"发送数据";
    [self startSender];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[outputStream close];
	[outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	outputStream.delegate = nil;
	[outputStream release];
	outputStream = nil;
}

- (void)dealloc {
    [_titleString release];
    [_titleLabel release];
    [_channel1 release];
    [_channel2 release];
    [_channel3 release];
    [_startButton release];
    [_changeWeapon release];
    [_angleLable release];
    [_slider release];
    [super dealloc];
}

- (IBAction)stop:(id)sender {
    if (TRUE == messageSwitch)
    {
        [outputStream close];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        outputStream.delegate = nil;
        [outputStream release];
        outputStream = nil;
        if (outputStream == nil)
        {
            [self.startButton setTitle:@"Start" forState:0];
            messageSwitch = FALSE;
            NSLog(@"Device has stopped sending data.");
            self.channel1.text = @"null";
            self.channel2.text = @"null";
            self.titleLabel.text = @"已停止发送数据";
        }
    } else
    {
        [self.startButton setTitle:@"Stop" forState:0];
        [self startSender];
    }
}

- (void) startSender
{
    messageSwitch = TRUE;
    self.titleLabel.text = [NSString stringWithFormat:@"正在向%@发送数据...", self.titleString];
    
    [self.netService getInputStream:nil outputStream:&outputStream];
	outputStream.delegate = self;
    //并没有自己建立runloop source，因为stream本身就是吧
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[outputStream open];
    
    __block NSDictionary *dataDic = nil;
    __block NSData *data = nil;
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0/5.0;
    queue = [NSOperationQueue currentQueue];
    [motionManager startDeviceMotionUpdatesToQueue: queue
                                       withHandler:
     ^(CMDeviceMotion *deviceMotion, NSError *error)
     {
         //CMAcceleration acceleration = accelerometerData.acceleration;
         //有很多种方式获得数据，但是这里用的是经过处理的deviceMotion里的数据
         NSString *pitch = [NSString stringWithFormat:@"%f", deviceMotion.attitude.pitch];
         NSString *roll = [NSString stringWithFormat:@"%f", deviceMotion.attitude.roll];
         NSString *deliverWeapon = [NSString stringWithFormat:@"%d", weaponNumber];
         NSString *deliverFire = [NSString stringWithFormat:@"%d", doFire];
         NSString *deliverAngle = [NSString stringWithFormat:@"%d", angle];
         
         dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                    pitch,@"pitch",
                    roll,@"roll",
                    deliverWeapon,@"whichWeapon",
                    deliverFire,@"fire",
                    deliverAngle,@"angle",
                    nil];
         data = [NSKeyedArchiver archivedDataWithRootObject:dataDic];
         if (outputStream != nil) {
             [outputStream write:data.bytes maxLength:data.length];
             self.channel1.text = pitch;
             self.channel2.text = roll;
         }
     }];
}

- (IBAction)change:(id)sender {
    weaponNumber++;
    if (3 == weaponNumber) {
        weaponNumber = 0;
    }
}

- (IBAction)fire:(id)sender {
    if (doFire == 0) {
        doFire = 1;
        return;
    }
    if (doFire == 1) {
        doFire = 0;
        return;
    }
}

- (IBAction)sliderValueChanged:(id)sender {
    UISlider *MYslider = (UISlider *)sender;
    angle = (int)roundf(MYslider.value);
    self.angleLable.text = [NSString stringWithFormat:@"%d", angle];
}
@end
