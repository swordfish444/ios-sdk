//
//  webViewController.m
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import "webController.h"


@implementation webController

@synthesize webView;
@synthesize urlToLoad;
@synthesize indicatorLoadPage;

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
  
    float yPos = self.view.frame.origin.y;
    [self.webView setFrame:CGRectMake(0, yPos, self.view.frame.size.width, self.view.frame.size.height )];
    [self.webView.superview setNeedsDisplay];
    
    [self.webView setDelegate:self];
    self.webView.scalesPageToFit = YES;
    CGRect indFrame = [self.indicatorLoadPage frame];
    indFrame.origin.y = ([UIScreen mainScreen].bounds.size.height/2) - ((indFrame.size.height/2) + [UIApplication sharedApplication].statusBarFrame.size.height + 50);
    indFrame.origin.x = ([UIScreen mainScreen].bounds.size.width/2) - (indFrame.size.width/2);
    [self.indicatorLoadPage setFrame:indFrame];
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {

        dispatch_async( dispatch_get_main_queue(), ^
        {
            NSString *encodedUrl = [self.urlToLoad stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:encodedUrl];
            NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:requestObj];
        });
    });
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
    [self.webView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}


#pragma mark -

#pragma mark UIWebView Delegate Methods

/****************************************************************************/

/*                        UIWebView Delegate Methods                        */

/****************************************************************************/

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.indicatorLoadPage startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorLoadPage stopAnimating];
}

@end
