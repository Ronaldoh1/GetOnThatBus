//
//  CustomMKAnnotationView.h
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/25/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BusStop.h"
@interface CustomMKPointAnnotation : MKPointAnnotation
@property BusStop *busStop;

@end
