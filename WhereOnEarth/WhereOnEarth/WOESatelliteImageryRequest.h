//
//  WOESatelliteImageryRequest.h
//  WhereOnEarth
//
//  Created by Heidi Proske on 4/12/14.
//  Copyright (c) 2014 Heidi Proske. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOESatelliteImageryRequest : NSObject

+ (UIImage*)getImageForCity:(NSString *)cityName InCountry:(NSString*)countryName;
+ (NSMutableArray*)populateCities;
@end
