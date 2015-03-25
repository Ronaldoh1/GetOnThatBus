//
//  BusStop.h
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/24/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BusStop : NSObject


@property double latitude;
@property double longitude;
@property NSString *routes;
@property NSString *stopName;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary;



@end
