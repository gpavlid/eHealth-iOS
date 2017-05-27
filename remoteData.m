//
//  remoteData.m
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import "remoteData.h"

@implementation remoteData

// Init the object with information from a dictionary
- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary {
	if(self = [self init]) {
		// Assign all properties with keyed values from the dictionary
		_sensorName = [jsonDictionary objectForKey:@"sensor"];
		_sensorValue = [jsonDictionary objectForKey:@"value"];
		_sensorMetric = [jsonDictionary objectForKey:@"metric"];
		_timeStamp = [jsonDictionary objectForKey:@"timeStamp"];
	}
	return self;
}


@end
