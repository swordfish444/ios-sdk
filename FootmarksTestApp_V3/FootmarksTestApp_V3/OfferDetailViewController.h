//
//  DealDetailsViewController.h
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "webController.h"
#import "LBYouTubePlayerViewController.h"

@interface OfferDetailViewController : UIViewController <UIScrollViewDelegate>

typedef enum {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@property int rowUserSelected;

@property (retain, nonatomic) UIButton *shareBtn;
@property (retain, nonatomic) UIButton *button;
@property (nonatomic, retain) UIView *btnView;  // View button lies on
@property (weak, nonatomic) IBOutlet UILabel *companyNameLbl;
@property (retain, nonatomic) UILabel *oldPriceLbl;
@property (retain, nonatomic) UILabel *priceLbl;
@property (retain, nonatomic) UILabel *discountLbl;
@property (nonatomic, retain) UILabel *offerDetailLbl;
@property (nonatomic, retain) UIFont *fontRetailPrice;
@property (nonatomic, retain) UIFont *fontOfferDescription;
@property (nonatomic, retain) UIFont *fontTileHeader;
@property (nonatomic, retain) UIFont *fontTileDescription;

@property (retain, nonatomic)  UIImageView *lineSeparator;
@property (weak, nonatomic) IBOutlet UIScrollView *companyImageScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *companyImagePageControl;
@property (nonatomic, assign) int lastContentOffset;
@property (nonatomic, assign) int offsetStatusTabBarNavBar;
@property (nonatomic, assign) int numImages;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;
@property (nonatomic, assign) ScrollDirection scrollDirection;
@property (nonatomic, retain) NSMutableArray *textViewArray; // Contains all of the text views we dynamically create.
@property (nonatomic, retain) NSDictionary *dictServerResponse;
@property BOOL showButton;
@property (retain, nonatomic) LBYouTubePlayerViewController *movieController;
// This method will parse the dictionary returned from the server and populate the page
// appropriately.
- (void) setServerResponse: (NSDictionary*) dict;

-(void)drawOfferDescriptionLbl: (NSString*) offerString;
-(void)drawPricesAndDiscountLbl: (NSString*) retailPrice andPrice: (NSString*) price andDiscount: (NSString*) discount;
-(void)drawTextView: (NSString*) headerString andTextViewString:(NSString*)textViewString;

-(void)populateImageScrollView;
-(void)configureBtnOnView: (double) yBtnViewPos;
-(void)configureBtnView: (double)yBtnViewPos;
-(void)configureShareBtn;


- (IBAction)shareBtnPressed:(id)sender;
- (IBAction)buttonPressed: (id)sender;

@end
