//
//  LBYouTubePlayerController.h
//  LBYouTubeView
//
//  Created by Laurin Brandner on 29.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LBYouTubeExtractor.h"

@protocol LBYouTubePlayerControllerDelegate;
@protocol PlayDelegate;


@interface LBYouTubePlayerViewController : MPMoviePlayerViewController <LBYouTubeExtractorDelegate>

@property (nonatomic, strong, readonly) LBYouTubeExtractor* extractor;
@property (nonatomic, weak) IBOutlet id <LBYouTubePlayerControllerDelegate> delegate;

@property (nonatomic, assign) id<PlayDelegate>           playDelegate;


-(id)initWithYouTubeURL:(NSURL*)youTubeURL quality:(LBYouTubeVideoQuality)quality;
-(id)initWithYouTubeURL:(NSURL*)youTubeURL quality:(LBYouTubeVideoQuality)quality extractionExpression:(NSString*)expression;
-(id)initWithYouTubeID:(NSString*)youTubeID quality:(LBYouTubeVideoQuality)quality;
-(id)initWithYouTubeID:(NSString*)youTubeID quality:(LBYouTubeVideoQuality)quality extractionExpression:(NSString*)expression;
- (void) playMovieOnPlayer;

@end
@protocol LBYouTubePlayerControllerDelegate <NSObject>

-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL;
-(void)youTubePlayerViewController:(LBYouTubePlayerViewController *)controller failedExtractingYouTubeURLWithError:(NSError *)error;

@end

@protocol PlayDelegate <NSObject>
- (void) readyToPlay;

@end
