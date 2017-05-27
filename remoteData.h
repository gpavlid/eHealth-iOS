//
//  remoteData.h
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "debug.h"
//#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]

@interface remoteData : NSObject

- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;

@property NSString *timeStamp;
@property NSString *sensorName;
@property NSString *sensorValue;
@property NSString *sensorMetric;

@end
