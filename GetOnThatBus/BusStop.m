//
//  BusStop.m
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/24/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "BusStop.h"

@implementation BusStop

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];

    self.longitude = [[dictionary objectForKey:@"longitude"] doubleValue];
    self.latitude = [[dictionary objectForKey:@"latitude"] doubleValue];

    self.routes = [dictionary objectForKey:@"routes"];


    self.stopName = [dictionary objectForKey:@"cta_stop_name"];
    self.transfer = [dictionary objectForKey:@"inter_modal"];


    return self;

}




@end
