//
//  Event.h
//  Locations
//
//  Created by Ali Muzaffar on 19/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
