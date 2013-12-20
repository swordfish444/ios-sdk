//
//  SecondViewController.m
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import "OffersViewController.h"
#import <QuartzCore/QuartzCore.h>

#import "PropertyCell.h"
#import "OfferDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation OffersViewController



@synthesize offerArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *darkTeal = [UIColor colorWithRed:102.00/255.00 green:175.00/255.00 blue:191.00/255.00 alpha:1.f];
    
    self.navigationController.navigationBar.tintColor = darkTeal;
    if(self.offerArray == nil)
    {
        self.offerArray = [[NSMutableArray alloc] init];
    }
    
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleBeaconAdvertisementData:)  name:NOTIF_BEACON_AD object:nil];
    // IMPORTANT:  Initialize the LeDiscovery singleton after a successfull login.
    // This prevents a race condition in which an Access Token does not exist (login has
    // not completed yet) when making an immediate call (from SmartConnect tag in proximity)
    // to retrieve a beacons data.
    [[LeDiscovery sharedInstance] setDiscoveryDelegate: self];
    
    // This helper method turns on SDK notification handling.  It tells the SDK to present a
    // notification everytime a beacon comes within range.  In the case below the notificaiton
    // data presented will be the value for the JSON key 'offerDescription' returned from the
    // beacon.  NOTE: You do not need to use this, you can perform your own notification handling
    // in the smartConnectDiscoveredWithInfo() delegate method below if you would like.
    [[LeDiscovery sharedInstance] enableNotificationHandlingUsingJsonKey:@"offerDescription"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item-header-bkg"]];
    

}

- (void) handleBeaconAdvertisementData:(NSNotification *) notification
{
    // Example of how to retrieve the beaconId and RSSI value for each
    // beacon advertisement.
    NSString *beaconId = [[notification userInfo] objectForKey:@"BEACONID"];
    NSNumber *rssi = [[notification userInfo] objectForKey:@"RSSI"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)refreshBtnClicked: (id)sender
{
    if(self.offerArray.count > 0)
    {
        NSString *title     = @"Offer Table";
        
        NSString *message   = @"Would you like reset the offer table?";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:nil];
        [alertView addButtonWithTitle:@"YES"];
            
        [alertView show];
        
    }
    else
    {
        [self.offerArray removeAllObjects];
        [self.tableView reloadData];
        // Clear internally managed Beacon data structures so you can reconnect to previously processed beacons
        [[LeDiscovery sharedInstance] resetBeaconQueues];
        [[LeDiscovery sharedInstance] stopScanning];
        [[LeDiscovery sharedInstance] startScanning];
    }

}

#pragma mark AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"YES"])
    {
        
        [self.offerArray removeAllObjects];
        [self.tableView reloadData];
        [[LeDiscovery sharedInstance] resetBeaconQueues];
        [[LeDiscovery sharedInstance] stopScanning];
        [[LeDiscovery sharedInstance] startScanning];
    }
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.offerArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 1)
    {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item-header-bkg"]];
        return view;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item-header-bkg"]];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     NSString *cellIdentifier = @"PropertyCell";
     PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil)
     {
        cell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
     NSMutableDictionary *offerDict = [self.offerArray objectAtIndex:[indexPath row]];
     
     if(offerDict)
     {
         cell.labelVDescription.text = [offerDict objectForKey:@"offerDescription"];
         NSURL *imageURL = [NSURL URLWithString:[offerDict objectForKey:@"offerImage"]];
         UIImage *imagePlaceHolder = [UIImage imageNamed:@"FM_App_Logo_retina.png"];
         
         [cell.indicatorVShowcase startAnimating];

         SDWebImageManager *manager = [SDWebImageManager sharedManager];
         [manager downloadWithURL:imageURL
                          options:0
                         progress:^(NSUInteger receivedSize, long long expectedSize)
          {
              // progression tracking code
          }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
          {
              if (image)
              {
                  [cell.indicatorVShowcase stopAnimating];

                  [cell.imageVShowcase setImage:image]; // do something with image
              }
          }];
     }
     
     return cell;
     
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 239;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Note: If you would like to use my pre-built OfferDetailViewController, then you must
    // create your JSON accordingly so that it parses it correctly within the
    // OfferDetailsViewController.  I provide an example of the Offer Format it expects within
    // the file: "Example_Offer_Format.rtf"
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *offerDict = [self.offerArray objectAtIndex:[indexPath row]];
    // Push detail view here
    OfferDetailViewController *vc = [[OfferDetailViewController alloc] initWithNibName:@"OfferDetailViewController" bundle:nil];
    [vc setServerResponse:offerDict];
    [self.navigationController pushViewController:vc animated:NO];
   
}


/****************************************************************************/

/*                     LeDiscovery Delegate Methods                         */

/****************************************************************************/
#pragma mark - LeDiscovery delegate

- (void) smartConnectDiscoveredWithInfo: (NSMutableDictionary*) dict
{
    /*
     Perform necessary logic on the json you associated with the tag within 
     the Footmarks Management console (biz.footmarks.com).  For the sake of 
     this example, I created a basic offer.
     NOTE: beaconId will always be appended to your json data.  beaconId uniquely
     identifies your beacon.
     */
    NSString *beaconId = [dict objectForKey:@"beaconId"];
    NSNumber *rssi = [dict objectForKey:@"rssi"];
    double latitude = [[dict objectForKey:@"latitude"] doubleValue];
    double longitude = [[dict objectForKey:@"longitude"] doubleValue];

    
    [self.offerArray addObject:dict];
    [self.tableView reloadData];
    
}

// Invoked when a devices Bluetooth is not enabled.  Bluetooth is necessary,
// so inform the user to enable their Bluetooth.
- (void) discoveryStatePoweredOff
{
    NSString *title     = @"Bluetooth Power";
    NSString *message   = @"Bluetooth must be enabled in order for this app to function properly.";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}





@end
