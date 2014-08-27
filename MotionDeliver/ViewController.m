//
//  ViewController.m
//  MotionDeliver
//
//  Created by yu_hao on 10/17/13.
//  Copyright (c) 2013 yu_hao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"选择主机";
	_browser = [[NSNetServiceBrowser alloc] init];
	_browser.delegate = self;
	[_browser searchForServicesOfType:@"_sampleservice._tcp" inDomain:@"local."];
	[super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	[_browser stop];
	_browser.delegate = nil;
	[_browser release];
	_browser = nil;
    
	[_foundServices removeAllObjects];
}

#pragma mark NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
	NSLog(@"found service %@", netService);
	if (!_foundServices)
		_foundServices = [[NSMutableArray alloc] init];
	
	[_foundServices addObject:netService];
	
	[self.bigTableView reloadData];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"%@ has been shut down!", netService);
	[_foundServices removeObject:netService];
    [self.bigTableView reloadData];
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser
{
	[_foundServices removeAllObjects];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_foundServices count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSLog(@"没有找到Cell");
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSNetService	*netService = [_foundServices objectAtIndex:indexPath.row];
    // Configure the cell...
	cell.textLabel.text = netService.name;
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNetService	*netService = [_foundServices objectAtIndex:indexPath.row];
    
	// Resolve the net service, and when successful, push a messaging screen
	netService.delegate = self;
	[netService resolveWithTimeout:5];
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	MessageSender *messageSender = [self.storyboard instantiateViewControllerWithIdentifier:@"MessageSender"];
	messageSender.netService = sender;
	messageSender.titleString = [NSString stringWithFormat:@"正在向%@发送数据", sender.name];
	[self.navigationController pushViewController:messageSender animated:YES];
}

- (void)dealloc {
    [_bigTableView release];
    [super dealloc];
}
- (IBAction)refresh:(id)sender {
    NSLog(@"now refreshing the server list...");
    [_browser searchForServicesOfType:@"_sampleservice._tcp" inDomain:@"local."];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didNotSearch:(NSDictionary *)errorDict
{
    NSLog(@"error! not searching");
    for(NSString *key in [errorDict allKeys]) {
        NSLog(@"%@",[errorDict objectForKey:key]);
    }
}

@end
