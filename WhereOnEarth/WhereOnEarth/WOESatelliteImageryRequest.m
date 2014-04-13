//
//  WOESatelliteImageryRequest.m
//  WhereOnEarth
//
//  Created by Heidi Proske on 4/12/14.
//  Copyright (c) 2014 Heidi Proske. All rights reserved.
//

#import "WOESatelliteImageryRequest.h"

@implementation WOESatelliteImageryRequest

+ (NSMutableArray*)populateCities
{
    //
    // Prepare for Quiz
    //
    return [@[
              @{KEY_CITY : @"Durban"", KEY_COUNTRY : "@"South Africa"},
              @{KEY_CITY : @"New York", KEY_COUNTRY : @"USA"},
              @{KEY_CITY : @"Paris", KEY_COUNTRY : @"France"},
              //       @{KEY_CITY : @"Hong Kong", KEY_COUNTRY : @"China"},
              //       @{KEY_CITY : @"Berlin", KEY_COUNTRY : @"Germany"},
              //       @{KEY_CITY : @"New York", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"Miami", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"San Francisco", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"Barcelona", KEY_COUNTRY : @"Spain"},
              //       @{KEY_CITY : @"Cape Town", KEY_COUNTRY : @"South Africa"},
              //       @{KEY_CITY : @"Honolulu", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"Nice", KEY_COUNTRY : @"France"},
              //       @{KEY_CITY : @"Rio de Janeiro", KEY_COUNTRY : @"Brazil"},
              //       @{KEY_CITY : @"Sydney", KEY_COUNTRY : @"Australia"},
              //       @{KEY_CITY : @"Tel Aviv", KEY_COUNTRY : @"Israel"},
              //       @{KEY_CITY : @"Vancouver", KEY_COUNTRY : @"British Columbia"},
              //       @{KEY_CITY : @"Hong Kong", KEY_COUNTRY : @"China"},
              //       @{KEY_CITY : @"Paris", KEY_COUNTRY : @"France"},
              //       @{KEY_CITY : @"Shanghai", KEY_COUNTRY : @"China"},
              //       @{KEY_CITY : @"Shilin", KEY_COUNTRY : @"Taiwan"},
              //       @{KEY_CITY : @"Ho Chi Minh City", KEY_COUNTRY : @"Vietnam"},
              //       @{KEY_CITY : @"Bangkok", KEY_COUNTRY : @"Thailand"},
              //       @{KEY_CITY : @"Singapore", KEY_COUNTRY : @"Malaysia"},
              //       @{KEY_CITY : @"Melbourne", KEY_COUNTRY : @"Australia"},
              //       @{KEY_CITY : @"Athens", KEY_COUNTRY : @"Greece"},
              //       @{KEY_CITY : @"Izmir", KEY_COUNTRY : @"Turkey"},
              //       @{KEY_CITY : @"Istanbul", KEY_COUNTRY : @"Turkey"},
              //       @{KEY_CITY : @"Dubai", KEY_COUNTRY : @"UAE"},
              //       @{KEY_CITY : @"Kuwait", KEY_COUNTRY : @"Iraq"},
              //       @{KEY_CITY : @"Venice", KEY_COUNTRY : @"Italy"},
              //       @{KEY_CITY : @"Rome", KEY_COUNTRY : @"Italy"},
              //       @{KEY_CITY : @"Casablanca", KEY_COUNTRY : @"Morocco"},
              //       @{KEY_CITY : @"Mumbai", KEY_COUNTRY : @"India"},
              //       @{KEY_CITY : @"Manila", KEY_COUNTRY : @"Philippines"},
              //       @{KEY_CITY : @"Havana", KEY_COUNTRY : @"Cuba"},
              //       @{KEY_CITY : @"Buenos Aires", KEY_COUNTRY : @"Argentina"},
              //       @{KEY_CITY : @"Panama", KEY_COUNTRY : @"Panama"},
              //       @{KEY_CITY : @"New Orleans", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"Cape Canaveral", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"Armstrong Flight Research Center", KEY_COUNTRY : @"USA"},
              //       @{KEY_CITY : @"Puerto Rico", KEY_COUNTRY : @"Dominican Republic"},
              //       @{KEY_CITY : @"Tokyo", KEY_COUNTRY : @"Japan"},
              //       @{KEY_CITY : @"Lisbon", KEY_COUNTRY : @"Portugal"},
              //       @{KEY_CITY : @"Dublin, KEY_COUNTRY : Ireland"}
              ] mutableCopy];
}

@end
