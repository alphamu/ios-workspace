//
//  APPStorySelectionDelegate.h
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 20/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPAppDelegate;
@protocol APPStorySelectionDelegate <NSObject>
@required
-(void)selectedStory:(NSString *)articleTitle url:(NSString *)url description:(NSString *)description;

@end
