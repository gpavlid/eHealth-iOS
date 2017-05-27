//
//  DetailViewController.m
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end


@implementation DetailViewController


// declare a remoteData class for the sensor data derived from the tableview
remoteData *_sensorData;


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
	if (_detailItem != newDetailItem) {
	    _detailItem = newDetailItem;
	        
	    // Update the view.
	    [self configureView];
	}
}

- (void)configureView {
	// Update the user interface for the detail item.
	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [NSString stringWithFormat:@"History data for: '%@'\nCurrent value: %@ %@\n@timestamp: %@", _sensorData.sensorName, _sensorData.sensorValue, _sensorData.sensorMetric, _sensorData.timeStamp];
	
	}
}

- (void)viewDidLoad {

	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

	// set the background image
	UIGraphicsBeginImageContext(self.view.frame.size);
	[[UIImage imageNamed:@"750x1334_detail.png"] drawInRect:self.view.bounds];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	self.view.backgroundColor = [UIColor colorWithPatternImage:image];

	[self.detailDescriptionLabel setNumberOfLines:0];
	[self.detailDescriptionLabel sizeToFit];
	
	_sensorData = self.detailItem;
	if (iHealthDebug) NSLog(@"sensor data selected :: %@, %@, %@, %@",_sensorData.sensorName, _sensorData.sensorValue, _sensorData.sensorMetric, _sensorData.timeStamp);

	[self configureView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
