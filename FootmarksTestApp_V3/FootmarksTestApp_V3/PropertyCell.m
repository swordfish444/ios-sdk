//
//  PropertyCell.m
//  Footmarks
//
//  Created by casey graika on 5/22/13.
//  Copyright (c) 2013 Footmarks Inc. All rights reserved.
//

#import "PropertyCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation PropertyCell

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self initialize];
    }
    return self;
}

+ (void)initialize {
    
}

- (void)initialize {
    [[self class] initialize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self styleElements];
    CGRect frameImageShowcase = self.viewShowcase.frame;
    frameImageShowcase.origin.x = 7.5;
    self.viewShowcase.frame = frameImageShowcase;
}


#pragma mark - Accessors

- (void)setData:(NSDictionary *)data
{
    if ([data isEqualToDictionary:_data])
    {
        return;
    }
    
    _data = data;

    self.imageVShowcase.image = [UIImage imageNamed:data[@"image_showcase"]];
    
    [self setNeedsLayout];
}


#pragma mark - Style

- (void)styleElements
{
     self.labelVDescription.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
     self.labelVDescription.textColor = [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f];
    [self.labelVDescription setBackgroundColor:[UIColor clearColor]];
}


@end
