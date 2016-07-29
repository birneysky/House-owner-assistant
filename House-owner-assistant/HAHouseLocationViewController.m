//
//  HAHouseLocationViewController.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAHouseLocationViewController.h"
#import <MapKit/MapKit.h>
#import "HALocationPoint.h"

@interface HAHouseLocationViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager* locationManager;
@end

@implementation HAHouseLocationViewController

#pragma mark - *** Properties ***
- (CLLocationManager*)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.locationManager requestWhenInUseAuthorization];
    
//    CLLocationCoordinate2D touchMapCoordinate =
//        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:39.975535 longitude:116.338525];
    CLLocationCoordinate2D coord = [loc coordinate];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    [self.mapView setRegion:region animated:YES];
    
    HALocationPoint *centerPoint = [[HALocationPoint alloc] initWithCoordinate:coord];
    [self.mapView addAnnotation:centerPoint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** Target Action ***
- (IBAction)canelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    CLLocationCoordinate2D loc = [userLocation coordinate];
//    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
//    [mapView setRegion:region animated:YES];
    

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
