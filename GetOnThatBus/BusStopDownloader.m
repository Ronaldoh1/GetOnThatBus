//
//  BusStopDownloader.m
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/24/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "BusStopDownloader.h"

@implementation BusStopDownloader


//pull Bus Stop information - store it in an array notify and provide the parentVC with bus stops.
-(void)pullBusStopsFromCTAApi{
    //create a URL
    NSURL *url = [NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    //create a request.
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        [self downloadcomplete:data];
        
    }];
    
    
    
    
}

-(void)downloadcomplete:(NSData *)data
{

    //store all of the stops in an Array.
    NSDictionary *busStopsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

    NSArray *results = [busStopsDictionary objectForKey:@"row"];
    [self.parentVC gotBusStops:results];

}

@end
