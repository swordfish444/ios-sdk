//
//  SecondViewController.h
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FootmarksSDK_V3.h"

@interface OffersViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, LeDiscoveryDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnRefresh;


@property (atomic, retain) NSMutableArray *offerArray;
@property int numOffersNotSeen;

- (IBAction)refreshBtnClicked: (id)sender;

@end
