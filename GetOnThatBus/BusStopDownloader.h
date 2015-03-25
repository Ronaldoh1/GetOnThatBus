//
//  BusStopDownloader.h
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/24/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BusStopDownloaderDelegate <NSObject>

-(void) gotBusStops:(NSArray *)busStopInfoArray;

@end

@interface BusStopDownloader : NSObject

@property id<BusStopDownloaderDelegate>parentVC;

-(void)pullBusStopsFromCTAApi;

@end
