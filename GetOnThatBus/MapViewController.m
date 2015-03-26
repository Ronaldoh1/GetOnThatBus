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
#import "CustomMKPointAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate, BusStopDownloaderDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property BusStopDownloader *downloader;

@property NSArray *busStopsArray;
@property NSMutableArray *arrayOfBusStopObjects;



@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     self.downloader = [BusStopDownloader new];
    self.downloader.parentVC = self;
    [self.downloader pullBusStopsFromCTAApi];

    //allocate and initialize dictionary for bus stop objects.
  self.arrayOfBusStopObjects = [[NSMutableArray alloc]init];

    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];


}
//Delegate method - busStopInfoArray Contains the

-(void)gotBusStops:(NSArray *)busStopInfoArray{



    for (NSDictionary *dict in busStopInfoArray){

        BusStop *busStop = [[BusStop alloc] initWithDictionary:dict];
        [self.arrayOfBusStopObjects addObject:busStop];
    }

     [self displayPins:self.arrayOfBusStopObjects];

}

    //--Display pins---//
-(void)displayPins:(NSArray *)busStopsArray{


    for(BusStop *busStop in busStopsArray){


        CLLocationCoordinate2D pinCoordinate = CLLocationCoordinate2DMake(busStop.latitude, busStop.longitude);
        CustomMKPointAnnotation *annotation = [[CustomMKPointAnnotation alloc]init];
        annotation.title = busStop.stopName;
        annotation.subtitle = busStop.routes;
        annotation.coordinate = pinCoordinate;
        annotation.accessibilityLabel = busStop.transfer;
        annotation.busStop = busStop;

        [self.mapView addAnnotation:annotation];

        //latitdude and longitude for Chicago --Zoom to region
        double lat = 41.8500300;
        double lon = -87.6500500;
        [self zoomToRegion:&lat :&lon];


    }

}
    //--Zoom into region--//
-(void)zoomToRegion:(double *)lat :(double *)lon{

    MKCoordinateRegion region;
    region.center.latitude = *lat;
    region.center.longitude = *lon;
    region.span.latitudeDelta = .3;
    region.span.longitudeDelta = .3;
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:TRUE];

}
    //---Prepare for segue---//
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"toDetailPage"]){
        CustomMKPointAnnotation *pointAnnotation = sender;
        BusStopDetailViewController *DestinationVC = segue.destinationViewController;
        DestinationVC.busStop = pointAnnotation.busStop;

    }
    
}

#pragma mark MapKit Delegate
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   
        [self performSegueWithIdentifier:@"toDetailPage" sender:view.annotation];

}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    CustomMKPointAnnotation *custAn = (CustomMKPointAnnotation *)annotation;

    MKPinAnnotationView *pinAnnotation = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];

    if ([custAn.accessibilityLabel isEqual:@"Metra"]) {
        pinAnnotation.pinColor = MKPinAnnotationColorGreen;


    }else if ([custAn.accessibilityLabel isEqual:@"Pace"]){
        pinAnnotation.pinColor = MKPinAnnotationColorPurple;
    }

    pinAnnotation.canShowCallout = true;

    pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return  pinAnnotation;
}


@end
