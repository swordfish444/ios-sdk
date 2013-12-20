//
//  DealDetailsViewController.m
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import "OfferDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation OfferDetailViewController

const int companyScrollViewHeight = 199;
const int companyScrollViewWidth = 280;

// Const values for dynamically creating UITextViews
const int paddingAtEndOfPage = 150;
const int pageXOffset = 10;  // The X offset that every object on the page is aligned with
const int imageScrollHeightOffset = 128; // Distance between image scroll view and first text view
const int textViewWidth = 300;
const int textViewLabelHeaderHeight = 30;
const int headerPadding = 60;
const int lineSeparatorPadding = 2;
const int lineSeparatorWidth = 280;
const int lineSeparatorHeight = 5;
const int offerDetailsMaxHeight = 70;
const int offerDetailsWidth = 280;
const int priceAndSeparatorPadding = 15;
const int oldPriceLblMaxWidth = 125;
const int oldPriceLblMaxHeight = 50;
const int priceLblMaxWidth = 125;
const int priceLblMaxHeight = 50;
const int discountLblMaxWidth = 125;
const int discountLblMaxHeight = 50;
const int spaceBtwPriceAndDiscount = 150;
const int spaceBtwTextViewAndDiscount = 20;
const int buttonHeight = 50;
static int buttonWidth = 90;
const int buttonShareHeigth = 40;
const int buttonShareWidth = 60;
const int btnViewHeight = 60;

const int maxMinBtnHeight = 30;
const int maxMinBtnWidth = 40;

- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [self.companyImageScrollView subviews];
    
    int curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (companyScrollViewWidth);
		}
	}
	
	[self.companyImageScrollView setContentSize:CGSizeMake((self.numImages * companyScrollViewWidth), [self.companyImageScrollView bounds].size.height -50)];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.textViewArray = [[NSMutableArray alloc] init];
        self.offerDetailLbl = [[UILabel alloc] init];
        self.discountLbl = [[UILabel alloc] init];
        self.oldPriceLbl = [[UILabel alloc] init];
        self.priceLbl = [[UILabel alloc] init];
        self.button = [[UIButton alloc] init];
        self.shareBtn = [[UIButton alloc] init];
        self.dictServerResponse = [[NSDictionary alloc] init];
        self.fontTileHeader = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        self.fontTileDescription = [UIFont fontWithName:@"Arial" size:17];
        self.fontRetailPrice = [UIFont fontWithName:@"Helvetica" size:18.0f];
        self.fontOfferDescription = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        self.showButton = FALSE;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    [self.backgroundScrollView setNeedsDisplay];
    
}
-(void) viewWillDisappear:(BOOL)animated
{
}

- (void) setServerResponse: (NSDictionary*) dict
{
    self.dictServerResponse = dict;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.btnView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.navigationItem.title = [self.dictServerResponse objectForKey:@"offerTitle"];
    
    if([self.dictServerResponse objectForKey:@"videoURL"] != nil)
    {
        NSString *videoUrl = [self.dictServerResponse objectForKey:@"videoURL"];
        [self playVideoWithUrl:videoUrl];
    }
    
    int statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    if(self.navigationController.navigationBar)
    {
        self.offsetStatusTabBarNavBar += self.navigationController.navigationBar.frame.size.height;
    }
    if(statusBarHeight)
    {
        self.offsetStatusTabBarNavBar += statusBarHeight;
    }
    
    [self configureShareBtn];
    [self drawOfferDescriptionLbl:[self.dictServerResponse objectForKey:@"offerDescription"]];
    self.lineSeparator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightGreyBG3.jpg"]];
    float xCenter = self.view.center.x - (lineSeparatorWidth/2);
    CGRect lineSepRect = CGRectMake(self.view.frame.origin.x + xCenter, self.offerDetailLbl.frame.origin.y+lineSeparatorPadding +self.offerDetailLbl.frame.size.height
                                    , lineSeparatorWidth, lineSeparatorHeight);
    [self.lineSeparator setFrame:lineSepRect];
    [self.backgroundScrollView addSubview:self.lineSeparator];
    
    
    [self drawPricesAndDiscountLbl: [self.dictServerResponse objectForKey:@"retailPrice"] andPrice: [self.dictServerResponse objectForKey:@"price"] andDiscount:[self.dictServerResponse objectForKey:@"discount"]];
    
    if([self.dictServerResponse objectForKey:@"tiles"])
    {
        NSMutableArray *tileArray = [[NSMutableArray alloc] initWithArray:[self.dictServerResponse objectForKey:@"tiles"]];
        for(NSDictionary *tile in tileArray)
        {
            NSString *tileDescription = [tile objectForKey:@"text"];
            NSString *tileName = [tile objectForKey:@"name"];
            [self drawTextView:tileName andTextViewString:tileDescription];
        }
    }
    
    
    self.companyNameLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:30];
    self.companyNameLbl.textColor = [UIColor redColor];
    
    self.scrollDirection = ScrollDirectionNone;
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];

    [self populateImageScrollView];

    if(![[self.dictServerResponse objectForKey:@"buttonName"] isEqualToString:@""])
    {
        double yBtnViewPos = self.view.frame.size.height - btnViewHeight;
        self.showButton = TRUE;
        [self configureBtnView: yBtnViewPos];
        [self configureBtnOnView:yBtnViewPos];
    }
    
    
    // Configure backgroundScrollView
    UITextView *lastTextView = self.textViewArray.lastObject;
    int dynamicHeightOfScrollView = lastTextView.frame.origin.y + lastTextView.frame.size.height + self.btnView.frame.size.height + self.offsetStatusTabBarNavBar + 20;
    self.backgroundScrollView.backgroundColor = [UIColor whiteColor];
    self.backgroundScrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    self.backgroundScrollView.delegate = self;
    self.backgroundScrollView.contentSize = CGSizeMake(self.view.frame.size.width, dynamicHeightOfScrollView);
}

-(void)playVideoWithUrl: (NSString*)videoUrl
{
    [self.companyImageScrollView setHidden:YES];
    CGRect movieRect = self.companyImageScrollView.frame;
    self.movieController = [[LBYouTubePlayerViewController alloc] initWithYouTubeURL:[NSURL URLWithString:videoUrl] quality:LBYouTubeVideoQualitySmall];
    [self.movieController.view setFrame:movieRect];
    [self.backgroundScrollView addSubview:self.movieController.view];
    [self.backgroundScrollView bringSubviewToFront:self.movieController.view];
    
}

-(void)populateImageScrollView
{
    // Customize page control.  Add shadows, round corners, etc.
    self.companyImagePageControl.backgroundColor = [UIColor clearColor];
    self.companyImagePageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.companyImagePageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    
    [self.companyImageScrollView.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [self.companyImageScrollView.layer setBorderWidth: 1.0f];
    
	// setup the scrollview for multiple images and add it to the view controller
    self.companyImageScrollView.delegate = self;
    self.companyImageScrollView.autoresizesSubviews = NO;
	[self.companyImageScrollView setBackgroundColor:[UIColor blackColor]];
	[self.companyImageScrollView setCanCancelContentTouches:NO];
	self.companyImageScrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	self.companyImageScrollView.clipsToBounds = YES;
	self.companyImageScrollView.scrollEnabled = YES;
	self.companyImageScrollView.pagingEnabled = YES;
	
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithArray:[self.dictServerResponse objectForKey:@"offerDetailImages"]];
    self.numImages = [imageArray count];
    self.companyImagePageControl.currentPage = 0;
    self.companyImagePageControl.numberOfPages = self.numImages;
    
    NSUInteger i;
    for (i = 1; i <= self.numImages; i++)
    {
        NSDictionary *imageDict = [[NSDictionary alloc] initWithDictionary:[imageArray objectAtIndex:i-1]];
        
        
        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            
            /* Fetch the image from the server... */
            NSURL *imageURL = [NSURL URLWithString: [imageDict objectForKey:@"url"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                CGRect rect = imageView.frame;
                rect.size.height = self.companyImageScrollView.bounds.size.height;
                rect.size.width = self.companyImageScrollView.bounds.size.width;
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.frame = rect;
                imageView.tag = i;
                
                [self.companyImageScrollView addSubview:imageView];
                [self layoutScrollImages];

            });
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(CGSize)sizeOfText:(NSString *)textToMesure widthOfTextView:(CGFloat)width withFont:(UIFont*)font
{
    CGSize ts = [textToMesure sizeWithFont:font constrainedToSize:CGSizeMake((int)width-20, (int)FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
    return ts;
}

-(void)drawOfferDescriptionLbl: (NSString*) offerString
{
    UIFont *font = self.fontOfferDescription;
    
    int ycoord = self.companyImagePageControl.frame.size.height + self.companyImagePageControl.frame.origin.y -10;
    int xCoord = self.view.center.x - (lineSeparatorWidth/2);
    CGSize textSize = [self sizeOfText:offerString widthOfTextView:offerDetailsWidth withFont:font];
    if(textSize.height > offerDetailsMaxHeight)
    {
        textSize.height = offerDetailsMaxHeight;
    }
    CGRect rect = CGRectIntegral(CGRectMake(xCoord, ycoord, textSize.width, textSize.height));
    
    [self.offerDetailLbl setFrame:rect];
    [self.offerDetailLbl setBackgroundColor:[UIColor clearColor]];
    [self.offerDetailLbl setFont:font];
    [self.offerDetailLbl setText:offerString];
    self.offerDetailLbl.numberOfLines = 4;
    [self.offerDetailLbl sizeThatFits:textSize];
    [self.backgroundScrollView addSubview:self.offerDetailLbl];
}

-(void)drawPricesAndDiscountLbl: (NSString*) retailPrice andPrice: (NSString*) price andDiscount: (NSString*) discount
{
    if(retailPrice == NULL)
    {
        retailPrice = @"";
    }
    if(price == NULL)
    {
        price = @"";
    }
    if(discount == NULL)
    {
        discount = @"";
    }
    
    if( !([retailPrice caseInsensitiveCompare:@"N/A"] == NSOrderedSame) )
    {
        if( (![retailPrice hasPrefix:@"$"]) && (![retailPrice isEqualToString:@""]) )
        {
            NSString *prefixString = [[NSString alloc]initWithString:[NSString stringWithFormat:@"$%@",retailPrice]];
            retailPrice = prefixString;
        }
    }
    
    if( !([price caseInsensitiveCompare:@"N/A"] == NSOrderedSame) )
    {
        if( (![price hasPrefix:@"$"]) && (![price isEqualToString:@""]) )
        {
            NSString *prefixString = [[NSString alloc]initWithString:[NSString stringWithFormat:@"$%@",price]];
            price = prefixString;
        }
    }
    
    if( !([discount caseInsensitiveCompare:@"N/A"] == NSOrderedSame) )
    {
        if( (![discount hasSuffix:@"%"]) && (![discount isEqualToString:@""]) )
        {
            NSString *prefixString = [[NSString alloc]initWithString:[NSString stringWithFormat:@"%@%%",discount]];
            discount = prefixString;
        }
    }

    
    
    // Check iOS version. If device is not using 6.0, use a different means of striking out the text
    NSString *reqSysVer = @"6.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
    {
        // Device is running 6.0 or above
        NSMutableAttributedString *oldPriceString = [[NSMutableAttributedString alloc] initWithString:retailPrice];
        NSInteger _stringLength = [retailPrice length];
        
        UIColor *_black=[UIColor blackColor];
        [oldPriceString addAttribute:NSFontAttributeName value:self.fontRetailPrice range:NSMakeRange(0, _stringLength)];
        [oldPriceString addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, _stringLength)];
        [oldPriceString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:2] range:(NSRange){0,[oldPriceString length]}];
        self.oldPriceLbl.attributedText = oldPriceString;
        
    }
    
    
    // Configure oldPrice and draw on screen
    int ycoord = self.lineSeparator.frame.origin.y + self.lineSeparator.frame.size.height + priceAndSeparatorPadding;
    CGSize oldPriceTextSize = [self sizeOfText:retailPrice widthOfTextView: oldPriceLblMaxWidth withFont:self.fontRetailPrice];
    if(oldPriceTextSize.height > oldPriceLblMaxHeight)
    {
        oldPriceTextSize.height = oldPriceLblMaxHeight;
    }
    CGRect rectOldPrice = CGRectIntegral(CGRectMake(self.lineSeparator.frame.origin.x, ycoord, oldPriceTextSize.width, oldPriceTextSize.height));
    
    [self.oldPriceLbl setFrame:rectOldPrice];
    [self.oldPriceLbl sizeThatFits:oldPriceTextSize];
    [self.backgroundScrollView addSubview:self.oldPriceLbl];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] == NSOrderedAscending)
    {
        self.oldPriceLbl.text = retailPrice;
        CGRect lineFrame = CGRectMake(rectOldPrice.origin.x, rectOldPrice.origin.y + oldPriceTextSize.height/2, rectOldPrice.size.width, 2);
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:lineFrame];
        lineLabel.backgroundColor = [UIColor blackColor];
        [self.backgroundScrollView addSubview:lineLabel];
        [self.backgroundScrollView bringSubviewToFront:lineLabel];
    }
    
    NSString *priceAppend = [NSString stringWithFormat:@"%@", price];
    // Configure and Draw price on screen
    UIFont *priceFont = [UIFont fontWithName:@"Arial-BoldMT" size:17];
    CGSize textSize = [self sizeOfText:priceAppend widthOfTextView: priceLblMaxWidth withFont:priceFont];
    if(textSize.height > priceLblMaxHeight)
    {
        textSize.height = priceLblMaxHeight;
    }
    CGRect rect = CGRectIntegral(CGRectMake(self.oldPriceLbl.frame.origin.x + self.oldPriceLbl.frame.size.width + 5, ycoord, priceLblMaxWidth, textSize.height));
    
    [self.priceLbl setFrame:rect];
    [self.priceLbl setBackgroundColor:[UIColor clearColor]];
    [self.priceLbl setFont:priceFont];
    [self.priceLbl setText:priceAppend];
    //self.priceLbl.textColor = [UIColor colorWithRed:(45/255.f) green:(179/255.f) blue:(194/255.f) alpha:1.0f];
    self.priceLbl.textColor = [UIColor colorWithRed:(33/255.f) green:(105/255.f) blue:(0/255.f) alpha:1.0f];
    [self.priceLbl sizeThatFits:textSize];
    [self.backgroundScrollView addSubview:self.priceLbl];
    
    
    NSString *discountAppend = [NSString stringWithFormat:@"Discount: %@", discount];
    // Configure and Draw discount on screen
    UIFont *discountFont = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    CGSize maxSize = CGSizeMake(discountLblMaxWidth, discountLblMaxHeight);
    CGSize discountLabelSize = [discountAppend sizeWithFont:discountFont
                                          constrainedToSize:maxSize
                                              lineBreakMode:self.discountLbl.lineBreakMode];
    
    int discountX = self.oldPriceLbl.frame.origin.x + self.lineSeparator.frame.size.width - discountLabelSize.width;
    CGRect rect2 = CGRectIntegral(CGRectMake(discountX, ycoord, discountLabelSize.width, discountLabelSize.height));
    
    [self.discountLbl setFrame:rect2];
    [self.discountLbl setBackgroundColor:[UIColor clearColor]];
    [self.discountLbl setFont:discountFont];
    [self.discountLbl setText:discountAppend];
    self.discountLbl.enabled = YES;
    self.discountLbl.highlighted = NO;
    //self.discountLbl.textColor = [UIColor colorWithRed:(45/255.f) green:(179/255.f) blue:(194/255.f) alpha:1.0f];
    self.discountLbl.textColor = [UIColor colorWithRed:(33/255.f) green:(105/255.f) blue:(0/255.f) alpha:1.0f];
    [self.discountLbl sizeThatFits:textSize];
    [self.backgroundScrollView addSubview:self.discountLbl];
    
    
    
}


-(void)drawTextView: (NSString*) headerString andTextViewString:(NSString*)textViewString
{
    if((headerString == NULL) || (textViewString == NULL))
    {
        return;
    }
    int ycoord = 0;
    // If this is the first text view to be created.  Set the ycoord offset based on the bottom of the companyimage scroll view.
    if(self.textViewArray.count == 0)
    {

        if( ([self.priceLbl.text rangeOfString:@"N/A"].location != NSNotFound) && ([self.discountLbl.text rangeOfString:@"N/A"].location != NSNotFound) && ([self.oldPriceLbl.text rangeOfString:@"N/A"].location != NSNotFound))
        {
            ycoord = self.lineSeparator.frame.origin.y + self.lineSeparator.frame.size.height + priceAndSeparatorPadding;
            [self.priceLbl setHidden:YES];
            [self.discountLbl setHidden:YES];
            [self.oldPriceLbl setHidden:YES];
        }
        else
        {
            ycoord = self.priceLbl.frame.origin.y + self.priceLbl.frame.size.height + spaceBtwTextViewAndDiscount;
        }
    }
    else
    {
        UITextView *lastTextViewAdded = self.textViewArray.lastObject;
        ycoord = lastTextViewAdded.frame.origin.y + lastTextViewAdded.bounds.size.height + 30;
    }
    
    // Create textView header label.
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectIntegral(CGRectMake(pageXOffset, ycoord, textViewWidth, textViewLabelHeaderHeight))];
    //headerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGreyBG2.jpg"]];
    headerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tile_header_bg.png"]];
    [headerLabel.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [headerLabel.layer setBorderWidth: 1.0];
    [headerLabel.layer setCornerRadius:2.0f];
    headerLabel.text = [NSString stringWithFormat:@" %@", headerString];
    headerLabel.font = self.fontTileHeader;
    
    
    // Calculate dynamic height of the UITextView we are creating
    CGSize size = [self sizeOfText:textViewString widthOfTextView:textViewWidth withFont:[UIFont fontWithName:@"Arial" size:17]];
    UITextView *customTextView = [[UITextView alloc] initWithFrame:CGRectIntegral(CGRectMake((int)pageXOffset, (int)ycoord, (int)textViewWidth, (int)(size.height + headerPadding)))];
    NSString *contentStringWithPadding = [NSString stringWithFormat:@"\n\n%@",textViewString];
    customTextView.text = contentStringWithPadding;
    customTextView.font = self.fontTileDescription;
    [customTextView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [customTextView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [customTextView.layer setBorderWidth: 1.0];
    [customTextView.layer setCornerRadius:2.0f];
    customTextView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    customTextView.layer.zPosition = 0.0f;
    customTextView.layer.shouldRasterize = YES;
    [customTextView.layer setMasksToBounds:NO];
    customTextView.layer.shadowColor = [[UIColor blackColor] CGColor];
    customTextView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    customTextView.layer.shadowOpacity = 1.0f;
    customTextView.layer.shadowRadius = 3.0f;
    [customTextView setUserInteractionEnabled:NO];
    
    // Add customTextView to an array storing all of the text views we have dynamically created.
    // This allows us to calculate offsets based on these text views.
    [self.textViewArray addObject:customTextView];
    [self.backgroundScrollView addSubview:customTextView];
    [self.backgroundScrollView addSubview:headerLabel];
}

- (IBAction)buttonPressed: (id)sender
{
    webController *webView = [[webController alloc] initWithNibName:@"webController" bundle:nil];
    [webView setUrlToLoad:[self.dictServerResponse objectForKey:@"buttonURL"]];
    [webView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webView animated:YES];
}


-(void)configureBtnView: (double)yBtnViewPos
{
    // Setup btnView at a stationary location at the bottom of the screen.
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backgroundScrollView.contentOffset.y + yBtnViewPos, self.backgroundScrollView.frame.size.width, btnViewHeight)];
    self.btnView.backgroundColor = [UIColor colorWithRed:0.00/255.00 green:0.00/255.00 blue:0.00/255.00 alpha:.75];
    [self.backgroundScrollView addSubview:self.btnView];
    [self.backgroundScrollView bringSubviewToFront:self.btnView];
}

-(void)configureBtnOnView: (double) yBtnViewPos
{
        
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.hidden = NO;
    self.button.enabled = YES;
    [self.button setFont:font];
    [self.button setTitle:[self.dictServerResponse objectForKey:@"buttonName"] forState:UIControlStateNormal]; // TODO: Change
    [self.button.layer setCornerRadius:8.0f];
    [self.button.layer setMasksToBounds:NO];
    [self.button.layer setBorderWidth:1.0f];
    self.button.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.button.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.button.layer.shadowOpacity = 1.0f;
    self.button.layer.shadowRadius = 3.0f;
    [self.button.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize fontSize = [[self.dictServerResponse objectForKey:@"buttonName"] sizeWithFont:font];

    CGRect btnFrame = [self.button frame];
    btnFrame.size.width = fontSize.width + 10; // Provide some spacing on the sides
    double xBtnPos = (self.backgroundScrollView.frame.size.width/2) - (btnFrame.size.width/2);
    double yBtnPos = (((yBtnViewPos + btnViewHeight) - (yBtnViewPos + buttonHeight))/2) + yBtnViewPos;
    double newYBtnPos = yBtnPos + self.backgroundScrollView.contentOffset.y;
    btnFrame.size.height = buttonHeight;
    btnFrame.origin.x = xBtnPos;
    btnFrame.origin.y = newYBtnPos;
    [self.button setFrame:btnFrame];


    
    [self.button setBackgroundColor:[UIColor colorWithRed:(133/255.f) green:(196/255.f) blue:(66/255.f) alpha:1.0f]];
    
    UIImage *image = [UIImage imageNamed:@"blue_gradient1.png"];
    UIImageView *highlightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xBtnPos, newYBtnPos, self.button.frame.size.width, self.button.frame.size.height)];
    UIGraphicsBeginImageContextWithOptions(highlightImageView.bounds.size, NO, 1.0);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:highlightImageView.bounds
                                cornerRadius:10.0] addClip];
    // Draw your image
    [image drawInRect:highlightImageView.bounds];
    // Get the image, here setting the UIImageView image
    highlightImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.button setBackgroundImage:highlightImageView.image forState:UIControlStateHighlighted];
    
    //self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.backgroundScrollView addSubview:self.button];
    [self.backgroundScrollView bringSubviewToFront:self.button];
    
}

-(void)configureShareBtn
{
    [self.shareBtn setTitle:@"Share" forState:UIControlStateNormal];
    self.shareBtn.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareBtn.layer setCornerRadius:8.0f];
    [self.shareBtn.layer setMasksToBounds:NO];
    [self.shareBtn.layer setBorderWidth:1.0f];
    self.shareBtn.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.shareBtn.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.shareBtn.layer.shadowOpacity = 1.0f;
    self.shareBtn.layer.shadowRadius = 3.0f;
    [self.shareBtn.layer setBorderColor:[[UIColor clearColor] CGColor]];
    
    [self.shareBtn addTarget:self action:@selector(shareBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setBackgroundColor:[UIColor colorWithRed:(133/255.f) green:(196/255.f) blue:(66/255.f) alpha:1.0f]];
    
    int xBtnPos = self.backgroundScrollView.frame.size.width - buttonShareWidth - 5;
    int yBtnPos = 5;
    [self.shareBtn setFrame:CGRectMake(xBtnPos, yBtnPos, buttonShareWidth, buttonShareHeigth)];
    
    UIImage *image = [UIImage imageNamed:@"blue_gradient1.png"];
    UIImageView *highlightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xBtnPos, yBtnPos, buttonShareWidth, buttonShareHeigth)];
    UIGraphicsBeginImageContextWithOptions(highlightImageView.bounds.size, NO, 1.0);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:highlightImageView.bounds
                                cornerRadius:10.0] addClip];
    [image drawInRect:highlightImageView.bounds];
    highlightImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.shareBtn setBackgroundImage:highlightImageView.image forState:UIControlStateHighlighted];
    
    self.shareBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self.backgroundScrollView addSubview:self.shareBtn];
    [self.backgroundScrollView bringSubviewToFront:self.shareBtn];
    
}


#pragma mark -

#pragma mark UIScrollViewDelegate

/****************************************************************************/

/*                       UIScrollViewDelegate Methods                       */

/****************************************************************************/

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // Determines when user stops dragging either left or right
    if(decelerate && self.scrollDirection == ScrollDirectionLeft)
    {
        if(self.companyImagePageControl.currentPage < self.companyImagePageControl.numberOfPages)
        {
            self.companyImagePageControl.currentPage +=1;
        }
    }
    else if(decelerate && self.scrollDirection == ScrollDirectionRight)
    {
        if(self.companyImagePageControl.currentPage > 0)
        {
            self.companyImagePageControl.currentPage -=1;
        }
    }
    else{
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if (self.lastContentOffset > self.companyImageScrollView.contentOffset.x)
        self.scrollDirection = ScrollDirectionRight;
    else if (self.lastContentOffset < self.companyImageScrollView.contentOffset.x)
        self.scrollDirection = ScrollDirectionLeft;
    
    self.lastContentOffset = self.companyImageScrollView.contentOffset.x;
    
    
    if(self.showButton)
    {
        double yBtnViewPos = self.view.frame.size.height - btnViewHeight;
        [self.btnView setFrame:CGRectMake(0, self.backgroundScrollView.contentOffset.y + yBtnViewPos, self.backgroundScrollView.frame.size.width, btnViewHeight)];
                
        // Create button and place it on the btnView
        double xBtnPos = (self.backgroundScrollView.frame.size.width/2) - (self.button.frame.size.width/2);
        double yBtnPos = (((yBtnViewPos + btnViewHeight) - (yBtnViewPos + buttonHeight))/2) + yBtnViewPos;
        double newYBtnPos = yBtnPos + self.backgroundScrollView.contentOffset.y;
        //[self.button setFrame:CGRectMake(xBtnPos, newYBtnPos, buttonWidth, buttonHeight)];
        [self.button setFrame:CGRectMake(xBtnPos, newYBtnPos, self.button.frame.size.width, self.button.frame.size.height)];
    }

}

// Not used in this sample app
- (IBAction)shareBtnPressed:(id)sender
{
    
}


@end
