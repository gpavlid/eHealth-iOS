//
//  DetailViewController.h
//  i-Health
//
//  Created by gpavlid on 9/10/14.
//  Copyright (c) 2014 George Pavlidis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "remoteData.h"
#import "debug.h"
/////#import "localData.h"

@interface DetailViewController : UIViewController

// declare the main data object
@property (strong, nonatomic) id detailItem;
// declare a remoteData class to hold the measurements
@property (weak, nonatomic) remoteData *measurements;
// declare the label outlet
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;


@end

