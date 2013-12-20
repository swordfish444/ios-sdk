//
//  LoginViewController.h
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "FootmarksSDK_V3.h"

@interface LoginViewController : UIViewController <FootmarksAccountDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewBG;
@property (weak, nonatomic) IBOutlet UIImageView *imgVLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblLoading;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property int loginAttempts;
@property BOOL fieldsEntered;

- (void)login;
- (IBAction)loginBtnSelected:(id)sender;
- (void)initialize;
@end
