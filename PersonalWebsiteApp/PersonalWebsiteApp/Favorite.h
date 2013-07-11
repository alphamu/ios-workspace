//
//  Favorite.h
//  RSSReaderOldSchool
//
//  Created by Ali Muzaffar on 19/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * desc;

@end
