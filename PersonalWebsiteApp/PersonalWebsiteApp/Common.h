//
//  Common.h
//  PersonalWebsiteApp
//
//  Created by Ali Muzaffar on 26/06/13.
//  Copyright (c) 2013 Ali Muzaffar. All rights reserved.
//

#import <Foundation/Foundation.h>

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

CGRect rectFor1PxStroke(CGRect rect);

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);

