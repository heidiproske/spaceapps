//
//  WOESatelliteImageryRequest.m
//  WhereOnEarth
//
//  Created by Heidi Proske on 4/12/14.
//  Copyright (c) 2014 Heidi Proske. All rights reserved.
//

#import "WOESatelliteImageryRequest.h"

@implementation WOESatelliteImageryRequest

+ (NSDictionary*)getImageForCity:(NSString *)cityName InCountry:(NSString*)countryName
{
    //
    //send web request to retrieve latitude and longitude from Google API
    //
    
    NSString *searchString = [NSString stringWithFormat:@"%@,+%@",
                              [cityName stringByReplacingOccurrencesOfString:@" " withString:@"+" ],
                              [countryName stringByReplacingOccurrencesOfString:@" " withString:@"+" ]];
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",searchString];
    NSURL *url = [NSURL URLWithString:urlString];
    //    NSLog(@"Trying to connect to %@", urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSError *requestError = nil;
    NSURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
    
    // Parse with JSON
    NSError *jsonError = nil; //TODO note how we do &jsonError on next line because that method will update it
    NSDictionary *locationResults = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&jsonError];
    //    NSLog(@"JSON: %@", locationResults);
    if (locationResults[@"results"] != nil)
    {
        NSDictionary* results = (NSDictionary *)((NSArray*)locationResults[@"results"][0]);
        if (results[@"geometry"] != nil)
        {
            NSDictionary* location = (NSDictionary *)results[@"geometry"][@"location"];
            NSString* latitude = location[@"lat"];
            NSString* longitude = location[@"lng"];
            
            NSMutableDictionary* returnResult = [@{} mutableCopy];
            returnResult[KEY_LATITUDE] = latitude;
            returnResult[KEY_LONGITUDE] = longitude;
            returnResult[KEY_IMAGE] = [self getImageForCityWithLatitude:latitude AndLongitude:longitude];
            return returnResult;
        }
    }
    
    //    NSLog(@"UHOH couldn't find details for %@. Error: %@", cityName, locationResults);
    return nil;
}

+ (UIImage *)getImageForCityWithLatitude:(NSString *)latitude AndLongitude:(NSString *)longitude
{
    // E.g. URL http://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=400x400&sensor=false
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=10&size=300x300&sensor=false&maptype=satellite",latitude, longitude];
    
    //    NSLog(@"Getting image from %@",urlString);
    NSURL* imageURL = [NSURL URLWithString:urlString];
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    return [UIImage imageWithData:imageData];
}

+ (NSMutableArray*)populateCities
{
    //
    // Prepare for Quiz
    //
    return [@[
              [@{KEY_CITY : @"Durban", KEY_COUNTRY : @"South Africa"} mutableCopy],
              [@{KEY_CITY : @"New York", KEY_COUNTRY : @"USA"} mutableCopy],
              [@{KEY_CITY : @"Paris", KEY_COUNTRY : @"France"} mutableCopy],
              [@{KEY_CITY : @"Hong Kong", KEY_COUNTRY : @"China"} mutableCopy],
              [@{KEY_CITY : @"Miami", KEY_COUNTRY : @"USA"} mutableCopy],
              [@{KEY_CITY : @"San Francisco", KEY_COUNTRY : @"USA"} mutableCopy],
              [@{KEY_CITY : @"Barcelona", KEY_COUNTRY : @"Spain"} mutableCopy],
              [@{KEY_CITY : @"Cape Town", KEY_COUNTRY : @"South Africa"} mutableCopy],
              [@{KEY_CITY : @"Honolulu", KEY_COUNTRY : @"USA"} mutableCopy],
              [@{KEY_CITY : @"Nice", KEY_COUNTRY : @"France"} mutableCopy],
              [@{KEY_CITY : @"Rio de Janeiro", KEY_COUNTRY : @"Brazil"} mutableCopy],
              [@{KEY_CITY : @"Sydney", KEY_COUNTRY : @"Australia"} mutableCopy],
              [@{KEY_CITY : @"Tel Aviv", KEY_COUNTRY : @"Israel"} mutableCopy],
              [@{KEY_CITY : @"Vancouver", KEY_COUNTRY : @"British Columbia"} mutableCopy],
              [@{KEY_CITY : @"Hong Kong", KEY_COUNTRY : @"China"} mutableCopy],
              [@{KEY_CITY : @"Paris", KEY_COUNTRY : @"France"} mutableCopy],
              [@{KEY_CITY : @"Shilin", KEY_COUNTRY : @"Taiwan"} mutableCopy],
              [@{KEY_CITY : @"Singapore", KEY_COUNTRY : @"Malaysia"} mutableCopy],
              [@{KEY_CITY : @"Melbourne", KEY_COUNTRY : @"Australia"} mutableCopy],
              [@{KEY_CITY : @"Athens", KEY_COUNTRY : @"Greece"} mutableCopy],
              [@{KEY_CITY : @"Izmir", KEY_COUNTRY : @"Turkey"} mutableCopy],
              [@{KEY_CITY : @"Istanbul", KEY_COUNTRY : @"Turkey"} mutableCopy],
              [@{KEY_CITY : @"Dubai", KEY_COUNTRY : @"UAE"} mutableCopy],
              [@{KEY_CITY : @"Kuwait", KEY_COUNTRY : @"Iraq"} mutableCopy],
              [@{KEY_CITY : @"Venice", KEY_COUNTRY : @"Italy"} mutableCopy],
              [@{KEY_CITY : @"Casablanca", KEY_COUNTRY : @"Morocco"} mutableCopy],
              [@{KEY_CITY : @"Mumbai", KEY_COUNTRY : @"India"} mutableCopy],
              [@{KEY_CITY : @"Manila", KEY_COUNTRY : @"Philippines"} mutableCopy],
              [@{KEY_CITY : @"Havana", KEY_COUNTRY : @"Cuba"} mutableCopy],
              [@{KEY_CITY : @"Buenos Aires", KEY_COUNTRY : @"Argentina"} mutableCopy],
              [@{KEY_CITY : @"Panama", KEY_COUNTRY : @"Panama"} mutableCopy],
              [@{KEY_CITY : @"New Orleans", KEY_COUNTRY : @"USA"} mutableCopy],
              [@{KEY_CITY : @"Cape Canaveral", KEY_COUNTRY : @"USA"} mutableCopy],
              [@{KEY_CITY : @"Tokyo", KEY_COUNTRY : @"Japan"} mutableCopy],
              [@{KEY_CITY : @"Lisbon", KEY_COUNTRY : @"Portugal"} mutableCopy],
              [@{KEY_CITY : @"Dublin", KEY_COUNTRY : @"Ireland" } mutableCopy]
              ] mutableCopy];
}

@end
