//
//  JSONLoader.m
//  JSONHandler
//
//  Created by Phillipus on 28/10/2013.
//  Copyright (c) 2013 Dada Beatnik. All rights reserved.
//

#import "JSONLoader.h"
#import "remoteData.h"

@implementation JSONLoader

NSString *jsonDataKey = @"healthData";


- (NSArray *)dataFromJSON:(NSURL *)url withServerTimeout:(double)serverTimeout withServerTimestamp:(BOOL)serverTimestamp {

	if (iHealthDebug) NSLog(@"starting with URL %@ using timeout %f...",url,serverTimeout);
	// Create a NSURLRequest with the given URL
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:serverTimeout];
	
	// Get the data
	NSURLResponse *response;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
	if (iHealthDebug) NSLog(@"just got a server response.");
	
	// create a local timestamp
	NSString *localTimestamp;
	NSDate *now = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
	localTimestamp = [dateFormatter stringFromDate:now];
	
	// Now create a NSDictionary from the JSON data
	NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

	// Create a new array to hold the sensor measurements under the root element <jsonRootKey>
	NSMutableArray *sensorData = [[NSMutableArray alloc] init];

	// Get an array of dictionaries with the key <jsonDataKey>
	NSArray *array = [jsonDictionary objectForKey:jsonDataKey];
	// Iterate through the array of dictionaries
	if (iHealthDebug) NSLog(@"start the iterations for all json elements (%lu) for root key %@...",(unsigned long)array.count,jsonDataKey);
	for (NSDictionary *dict in array) {
		// Create a new remoteData object for each one and initialise it with information in the dictionary
		remoteData *theSensorData = [[remoteData alloc] initWithJSONDictionary:dict];
		if (!serverTimestamp) {
			if (iHealthDebug) NSLog(@"Switching to local time (%@-->%@)...",theSensorData.timeStamp,localTimestamp);
			theSensorData.timeStamp = localTimestamp;
		}
		// Add the sensor data object to the array
		[sensorData addObject:theSensorData];
		if (iHealthDebug) NSLog(@"Inserting the (%@,%@,%@,%@) in the measurements array...",theSensorData.sensorName,theSensorData.sensorValue,theSensorData.sensorMetric,theSensorData.timeStamp);
	}
		if (iHealthDebug) NSLog(@"Sensor data count = %lu",(unsigned long)sensorData.count);

	if (iHealthDebug) NSLog(@"all done - returning.");
	// Return the array of measurements
	return sensorData;
}


@end
