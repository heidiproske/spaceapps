//
//  WOESatelliteImageryRequest.m
//  WhereOnEarth
//
//  Created by Heidi Proske on 4/12/14.
//  Copyright (c) 2014 Heidi Proske. All rights reserved.
//

#import "WOESatelliteImageryRequest.h"

@implementation WOESatelliteImageryRequest

+ (UIImage*)getImageForCity:(NSString *)cityName InCountry:(NSString*)countryName
{
    //    NSString* myKey = @"AIzaSyDgXPabFl8HDR87DT6K5ry8rMQxlAD6onU";
    //    With a developer API key
    //    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&sensor=false&key=%@",searchString,myKey];
    
    //
    //send web request to retrieve latitude and longitude from Google API
    //
    
    NSString *searchString = [NSString stringWithFormat:@"%@,+%@",
                              [cityName stringByReplacingOccurrencesOfString:@" " withString:@"+" ],
                              [countryName stringByReplacingOccurrencesOfString:@" " withString:@"+" ]];
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",searchString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"Trying to connect to %@", urlString);
    
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
            
            return [self getImageForCityWithLatitude:latitude AndLongitude:longitude];
        }
    }
    
    //    NSLog(@"UHOH couldn't find details for %@. Error: %@", cityName, locationResults);
    return nil;
}

+ (UIImage *)getImageForCityWithLatitude:(NSString *)latitude AndLongitude:(NSString *)longitude
{
    // E.g. URL http://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=400x400&sensor=false
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@,%@&zoom=12&size=400x400&sensor=false",latitude, longitude];
    
    NSLog(@"Getting image from %@",urlString);
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
