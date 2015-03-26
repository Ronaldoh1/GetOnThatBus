//
//  BusStopDetailViewController.m
//  GetOnThatBus
//
//  Created by Ronald Hernandez on 3/25/15.
//  Copyright (c) 2015 Ron. All rights reserved.
//

#import "BusStopDetailViewController.h"
#import <MapKit/MapKit.h>

@interface BusStopDetailViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *busStopAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *busRoutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *transferLabels;
@property NSString *addressString;

@end

@implementation BusStopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self getBusStopAddress];
    
    self.title = self.busStop.stopName;
    self.addressString = [[NSString alloc]init];
    self.busRoutesLabel.text = self.busStop.routes;
    self.transferLabels.text = self.busStop.transfer;



    //will display text when block is complete. This is a promise that there will be a new text and will be updated.
    
    [self.busStopAddressLabel setNeedsDisplay];

}

-(void) getBusStopAddress{

    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.busStop.latitude
                                                        longitude:self.busStop.longitude
                            ];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {

        [self downloadComplete:placemarks];
    }];
}

-(void)downloadComplete:(NSArray *)placemarkArray

{

    CLPlacemark *placemark = [placemarkArray objectAtIndex:0];

    self.busStopAddressLabel.text = [NSMutableString stringWithFormat:@"%@", placemark.thoroughfare];

    NSLog(@"%@",self.addressString);


}




@end
