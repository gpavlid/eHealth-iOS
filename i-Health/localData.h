//
//  localData.h
//  i-Health
//
//  Created by gpavlid on 10/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>
//#import "remoteData.h"

@interface localData : NSObject

// declare the sqlite basic properties
@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *dataDB;

// declare the sqlite data fields
@property (strong, nonatomic) NSDate *moment;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *metric;
@property (strong, nonatomic) NSString *status;

// declare the main local data functions
- (void) saveData;
- (void) loadData;
- (void) initializeLocalData;

@end
