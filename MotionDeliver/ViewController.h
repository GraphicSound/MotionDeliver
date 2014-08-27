//
//  ViewController.h
//  MotionDeliver
//
//  Created by yu_hao on 10/17/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageSender.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSNetServiceBrowserDelegate, NSNetServiceDelegate>
{
    NSNetServiceBrowser	*_browser;
	NSMutableArray	*_foundServices;
}

@property (retain, nonatomic) IBOutlet UITableView *bigTableView;
- (IBAction)refresh:(id)sender;

@end
