//
//  LoginViewController.m
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


const int btnLoginWidth = 200;
const int btnLoginHeight = 40;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fieldsEntered = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self initialize];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnSelected:(id)sender
{
    [self.btnLogin setHidden:YES];
    [self.lblLoading setHidden:NO];
    [self login];
}


- (void)login
{
    [self.indicatorLogin setHidden:NO];
    [self.indicatorLogin startAnimating];
    self.fieldsEntered = [[FootmarksAccount sharedInstance] loginToFootmarksServer:@"" andAppSecret:@""];

    
    if(!self.fieldsEntered)
    {
        NSString *title     = @"Login Problem";
        NSString *message   = @"Please enter App Key & Secret into Login method.";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [self.btnLogin setHidden:NO];
        [self.lblLoading setHidden:YES];
        [self.indicatorLogin stopAnimating];
        
    }
}

- (void)initialize
{
    self.indicatorLogin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    CGPoint viewCenter = self.view.center;
    
    
    [[FootmarksAccount sharedInstance] setAccountDelegate:self];
    self.loginAttempts = 0;
    
    UIColor *teal = [UIColor colorWithRed:102.00/255.00 green:175.00/255.00 blue:191.00/255.00 alpha:1.00f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[teal CGColor], nil];
    [self.viewBG.layer insertSublayer:gradient atIndex:0];
    
    double btnX = viewCenter.x - (self.btnLogin.frame.size.width/2);
    double btnY = self.view.center.y/2;
    
    CGRect frameBtn = CGRectMake(btnX, btnY, self.btnLogin.frame.size.width, self.btnLogin.frame.size.height);
    [self.btnLogin setFrame:frameBtn];
    [self.btnLogin.layer setCornerRadius:8.0f];
    [self.btnLogin.layer setMasksToBounds:NO];
    [self.btnLogin.layer setBorderWidth:1.0f];
    self.btnLogin.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.btnLogin.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.btnLogin.layer.shadowOpacity = 1.0f;
    self.btnLogin.layer.shadowRadius = 3.0f;
    [self.btnLogin.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    
    self.indicatorLogin.center = self.btnLogin.center;
    [self.indicatorLogin setHidden:YES];
    [self.viewBG addSubview:self.indicatorLogin];
    
    CGRect frame = self.lblLoading.frame;
    frame.origin.y = self.indicatorLogin.frame.origin.y + self.indicatorLogin.frame.size.height + 5;
    [self.lblLoading setFrame:frame];
    self.lblLoading.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:21];
    [self.lblLoading setTextColor:[UIColor whiteColor]];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/***********************************************************
 *
 *   FootmarksAccount Delegate Methods
 *
 ***********************************************************/
- (void) loginSuccessful
{
    [self.indicatorLogin stopAnimating];
    [self.indicatorLogin setHidden:YES];
    self.loginAttempts = 0;
    NSLog(@"Sample App Login successful!");
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                  bundle:nil];
    UINavigationController* vc = [sb instantiateViewControllerWithIdentifier:@"OfferNav"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void) loginUnsuccessful: (NSString*)error
{
    if(self.fieldsEntered)
    {
        NSLog(@"ERROR: Login failed: %@", error);
        NSLog(@"Attempting to log in again...");
        // Attempt to login again
        if(self.loginAttempts < 3)
        {
            self.loginAttempts += 1;
            [[FootmarksAccount sharedInstance] loginToFootmarksServer:@"" andAppSecret:@""];

        }
    }
    
}

- (void)viewDidUnload {
    [self setViewBG:nil];
    [self setBtnLogin:nil];
    [self setImgVLogo:nil];
    [super viewDidUnload];
}
@end
