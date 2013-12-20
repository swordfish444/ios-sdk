//
//  PropertyCell.h
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyCell : UITableViewCell

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) IBOutlet UIView *viewShowcase;
@property (strong, nonatomic) IBOutlet UIView *viewDescription;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorVShowcase;

@property (strong, nonatomic) IBOutlet UIImageView *imageVShowcase;
@property (strong, nonatomic) IBOutlet UILabel *labelVDescription;


@end