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
#import "BusStopDetailViewController.h"

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
        self.annotation.subtitle = busStop.routes;
        self.annotation.coordinate = pinCoordinate;
        self.annotation.accessibilityLabel = busStop.transfer;
    [self.mapView addAnnotation:self.annotation];

        //latitdude and longitude for Chicago --Zoom to region
        double lat = 41.8500300;
        double lon = -87.6500500;
        [self zoomToRegion:&lat :&lon];

      //  [self.mapView showAnnotations:self.annotation animated:true];


        //A Boolean value that determines whether the user may use pinch gestures to zoom in and out of the map.
        //self.mapView.zoomEnabled = true;




    }

}
-(void)zoomToRegion:(double *)lat :(double *)lon{

    MKCoordinateRegion region;
    region.center.latitude = *lat;
    region.center.longitude = *lon;
    region.span.latitudeDelta = .3;
    region.span.longitudeDelta = .3;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:TRUE];

}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   
        [self performSegueWithIdentifier:@"toDetailPage" sender:view];

}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"toDetailPage"]){
         MKAnnotationView *annotationView = (MKAnnotationView*)sender;
        BusStopDetailViewController *DestinationVC = segue.destinationViewController;
        DestinationVC.busStop = annotationView.annotation;
    }

}

#pragma mark MapKit Delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];


    if ([self.annotation.accessibilityLabel isEqual:@"Metra"]) {
        pinAnnotation.pinColor = MKPinAnnotationColorGreen;


    }else if ([self.annotation.accessibilityLabel isEqual:@"Pace"]){
        pinAnnotation.pinColor = MKPinAnnotationColorPurple;
    }

    pinAnnotation.canShowCallout = true;

    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];


    return  pinAnnotation;
}


@end
