//
//  webViewController.h
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webController : UIViewController <UIWebViewDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorLoadPage;

@property (nonatomic, retain) NSString *urlToLoad;
@end
