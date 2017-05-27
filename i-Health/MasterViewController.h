//
//  MasterViewController.h
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "debug.h"

@interface MasterViewController : UITableViewController

@property NSString *serverURL;
@property NSTimeInterval serverTimeout;
@property BOOL serverTimestamp;
@property NSTimeInterval refreshInterval;

@end

