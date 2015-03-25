//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/24/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "MapViewController.h"
#import "BusStop.h"
#import <MapKit/MapKit.h>
#import "BusStopDownloader.h"

@interface MapViewController ()<MKMapViewDelegate, BusStopDownloaderDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property BusStopDownloader *downloader;

@property NSArray *busStopsArray;
@property NSMutableArray *dictionaryOfBusStopObjects;
@property MKPointAnnotation *annotation;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.downloader = [BusStopDownloader new];
    self.downloader.parentVC = self;
    [self.downloader pullBusStopsFromCTAApi];

    //allocate and initialize dictionary for bus stop objects.
  self.dictionaryOfBusStopObjects = [[NSMutableArray alloc]init];



}



-(void)gotBusStops:(NSArray *)busStopInfoArray{




    for (NSDictionary *dict in busStopInfoArray){

        BusStop *busStop = [[BusStop alloc] initWithDictionary:dict];
        [self.dictionaryOfBusStopObjects addObject:busStop];

    }

     [self displayPins:self.dictionaryOfBusStopObjects];

    

}

-(void)displayPins:(NSMutableArray *)busStopsDictionary{


    for(BusStop *busStop in busStopsDictionary){

        double latitude = busStop.latitude;
        double longitude = busStop.longitude;
        CLLocationCoordinate2D pinCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.annotation = [[MKPointAnnotation alloc]init];
        self.annotation.title = busStop.stopName;
        self.annotation.coordinate = pinCoordinate;
        [self.mapView addAnnotation:self.annotation];





    }

}

#pragma mark MapKit Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    pinAnnotation.canShowCallout = true;

    return  pinAnnotation;
}


@end
