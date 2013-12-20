//
//  FootmarksSDK_V3.h
//  FootmarksSDK_V3
//
//  Created by casey graika on 11/15/13.
//  Copyright (c) 2013 casey graika. All rights reserved.
//
#import <Foundation/Foundation.h>



/*
 Register to observe this notification name in order to receive constant beacon advertisements.
 FootmarksTestApp contains an example of how to observe and utilize the advertisement data returned.
 */
static NSString *NOTIF_BEACON_AD = @"NOTIF_BEACON_AD";




/************************************************************/

/*                   LeDiscoveryDelegate                    */

/************************************************************/
/*
 LeDiscoveryDelegate is used to return information directly related to the SmartConnect Beacons and the iOS devices Bluetooth chip
 */
@protocol LeDiscoveryDelegate <NSObject>

@optional

/*
 This delegate is invoked when the iOS devices Bluetooth is not powered on.  You should ask the user to enable Bluetooth within this delegate
 */
- (void) discoveryStatePoweredOff;

/*
 This delegate is invoked when a user comes within range of one of your SmartConnect Beacons. Perform all the necessary operations on the data within this delegate.  For instance, this is the place to invoke a notification to the user in order to alert them of whatever content you would like.
 @return a dictionary (dict) containing the custom JSON you entered into the Footmarks Management Console for the giving Beacon.
 */
- (void) smartConnectDiscoveredWithInfo: (NSDictionary*) dict;


@end



/************************************************************/

/*                      LeDiscovery                         */

/************************************************************/
/*
 LeDiscovery is a singleton class that manages the devices Bluetooth capabilities and the beacons the app interacts with
 */
@interface LeDiscovery : NSObject

@property (nonatomic, assign) id<LeDiscoveryDelegate>           discoveryDelegate;

/*
 @return a shared instance of the LeDiscovery singleton class
 */
+ (id) sharedInstance;
/*
 Ends the devices Bluetooth discovery mode.  Once called, beacons will not be detected until you start scanning again.
 */
- (void) stopScanning;
/*
 Resumes scanning
 */
- (void) startScanning;
/*
 Call this method to reset all internal SDK queues.  This allows you to interact with Beacons you have already communicated with
 */
- (void) resetBeaconQueues;

/* 
 Once invoked, this notification helper method will turn on automatic notification handling.  This includes 
 incrementing the badge count.  NOTE: To reset the badge count to zero when the app is brought back to the foreground
 include the following line of code in the App Delegates applicationDidBecomeActive:(UIApplication *) method:
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
 @param key
  The JSON key for the corresponding notification string you would like to display upon coming within range
  of your beacon.  This key will be used to parse out the notification string from the JSON Dictionary
  returned from the Footmarks Service.
 */
- (void) enableNotificationHandlingUsingJsonKey: (NSString*) key;


@end



/************************************************************/

/*                 FootmarksAccountDelegate                 */

/************************************************************/
/*
 FootmarksAccountDelegate handles the Footmarks Service login process
 */
@protocol FootmarksAccountDelegate <NSObject>

/*
 This delegate is invoked if the login is successful
 */
- (void) loginSuccessful;
/*
 Invoked when login fails.
 @return a string containing the reason for the login attempts failure
 */
- (void) loginUnsuccessful: (NSString*)error;

@end

/*
 FootmarksAccount is a singleton that handles the Footmarks Service Account processes.
 */
@interface FootmarksAccount : NSObject

@property (nonatomic, assign) id<FootmarksAccountDelegate>           accountDelegate;


+ (id) sharedInstance;

/*
 This method attempts to login to the Footmarks Service.
 @param appKey
 The app key provided by the Footmarks Management Console upon registration
 @param appSecret
 The app secret provided by the Footmarks Management Console upon registration.
 @return True if no problems occurred in the process of attempting the call.  Else false.  Note: Success or Failure of the call will be returned to the FoomarksAccountDelegate
 */
-(BOOL)loginToFootmarksServer: (NSString*) appKey andAppSecret: (NSString*) appSecret;

/*
 This method revokes the user's access token.  Once revoked, the current access token will not work for protected calls to the Footmarks server.
 */
-(void)revokeAccessToken;


@end



/************************************************************/

/*                     Helper Methods                       */

/************************************************************/
/*
 Necessary include to perform JSONKit operations within the SDK.
 */
@interface NSString (JSONKitDeserializing)

- (id)objectFromJSONString;

@end

