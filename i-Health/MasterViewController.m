//
//  MasterViewController.m
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "remoteData.h"
#import "JSONLoader.h"
#import "localData.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *reconnectButton;
-(IBAction)reconnectingServer;

@end


@implementation MasterViewController{

	// declare the remote data array variable
	NSArray *_sensorData;
	// declare the local SQLite data variable
	///////localData *localDB;

}

@synthesize serverURL;
@synthesize serverTimeout;
@synthesize serverTimestamp;
@synthesize refreshInterval;
NSTimer *connectionTimer;


- (void) alertWithError {

		NSString * alertMSG = [NSString stringWithFormat:@"%@ %@ %@", @"Unable to connect to the i-Health medical server \n", serverURL, @"\n Please check your internet connection or the server URL defined in your device settings."];
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Server unreachable!" message:alertMSG delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];

}



- (BOOL) checkServerConnection {

	BOOL hasConnection = YES;
	NSError* error = nil;

	NSString *connect = [NSString stringWithContentsOfURL:[NSURL URLWithString:serverURL] encoding:NSUTF8StringEncoding error:&error];

	if (connect) {
		hasConnection = YES;
	} else {
		hasConnection = NO;
	}
	if (iHealthDebug) NSLog(@"serverURL=%@ -- connection=%d (error=%@)", serverURL, hasConnection, error);
	
	return hasConnection;

}


- (void) mainLoop {

	if( [self checkServerConnection]){
		// display current readings
		[self readHealthServer];
		// install the auto refresh timer that reads eHealth data from the i-Health server
		connectionTimer = [NSTimer scheduledTimerWithTimeInterval:refreshInterval target:self selector:@selector(autoRefresh:) userInfo:nil repeats:YES];
		
		self.reconnectButton.hidden = YES;
	} else {
		// alert
		[self alertWithError];
		[connectionTimer invalidate];
		self.reconnectButton.hidden = NO;
	}

}



- (IBAction) reconnectingServer {

	[self mainLoop];
	
}


- (void) readHealthServer {

	// make sure there is a connection to the server...otherwise the app crashes!!!
	if( [self checkServerConnection]){
		// Create a new JSONLoader with a local file URL
		JSONLoader *jsonLoader = [[JSONLoader alloc] init];
		NSURL *url = [NSURL URLWithString:serverURL];

		// Load the data on a background queue...
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			_sensorData = [jsonLoader dataFromJSON:url withServerTimeout:serverTimeout withServerTimestamp:serverTimestamp];
			// reload the table data on the main UI thread with the json data
			[self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
		});
	}	else {
		// alert
		[self alertWithError];
/*
		NSString * alertMSG = [NSString stringWithFormat:@"%@ %@ %@", @"Unable to connect to the i-Health medical server '", serverURL, @"'. Please check your internet connection or the server URL defined in your device settings."];
		UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Server unreachable!" message:alertMSG delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [message show];*/
		[connectionTimer invalidate];
		self.reconnectButton.hidden = NO;
	}


}


-(void)autoRefresh:(UIRefreshControl *)refresh{

	[self readHealthServer];

}



- (void)viewDidLoad {

	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	// set the serverURL variable according to the default value in settings
	serverURL = [[NSUserDefaults standardUserDefaults] objectForKey:@"serverURL"];
	if (iHealthDebug) NSLog(@"serverURL=%@", serverURL);
	// set the refreshInterval variable according to the default value in settings
	refreshInterval = [[[NSUserDefaults standardUserDefaults] objectForKey:@"refreshInterval"] doubleValue];
	// divide by 1000 to make it sec from msec
	refreshInterval = refreshInterval/1000;
	if (iHealthDebug) NSLog(@"refreshInterval=%fl", refreshInterval);
	// set the serverTimeout variable according to the default value in settings
	serverTimeout = [[[NSUserDefaults standardUserDefaults] objectForKey:@"serverTimeout"] doubleValue];
	if (iHealthDebug) NSLog(@"serverTimeout=%f", serverTimeout);
	// set the serverTimestamp variable according to the default value in settings
	serverTimestamp = [[[NSUserDefaults standardUserDefaults] objectForKey:@"serverTimestamp"] boolValue];
	if (iHealthDebug) NSLog(@"serverTimestamp=%d", serverTimestamp);
	// set here the rest of the variables...
	// .............

	// load the background image as an imageview
	UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"750x1334_master.png"]];
	// resize the image view to fit the screen
	[backgroundImageView setFrame:[[self tableView] bounds]];
	// assign the background image view to the table view
	self.tableView.backgroundView = backgroundImageView;
	
	// initialize local database
//	[localDB initializeLocalData];
	
	// call the main app loop
	[self mainLoop];
	
}



- (void)awakeFromNib {
	[super awakeFromNib];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}




#pragma mark - Segues


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

	DetailViewController *detailItem = segue.destinationViewController;
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	detailItem = [_sensorData objectAtIndex:indexPath.row];
	if (iHealthDebug) NSLog(@"sending detail object %@",detailItem);
	[[segue destinationViewController] setDetailItem:detailItem];

/*
	if ([[segue identifier] isEqualToString:@"i-Health history"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	    NSDate *object = self.objects[indexPath.row];
	    [[segue destinationViewController] setDetailItem:object];
	}
*/

}



#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// ************************
//
// main function that fills the UITableView with the remote data
//
// ************************
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	// set the CELL properties :: Font, background color and transparency
	cell.textLabel.font=[UIFont fontWithName:@"system" size:13.0];
	cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];

	// get the remote data available at this moment and transform to cells
	remoteData *RemoteData = [_sensorData objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@: %@ %@",RemoteData.sensorName,RemoteData.sensorValue,RemoteData.sensorMetric];
	cell.detailTextLabel.text = RemoteData.sensorName;

	return cell;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_sensorData count];
}



@end
