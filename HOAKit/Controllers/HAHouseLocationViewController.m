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
#import "HALocationPickerTextField.h"
#import "HALeapBehavior.h"
#import "HAHouse.h"
#import "HAHouseTypeTableViewController.h"

@interface HAHouseLocationViewController ()<MKMapViewDelegate,HALocationPickerTextFieldDelegate,UIDynamicAnimatorDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager* locationManager;

@property (weak, nonatomic) IBOutlet HALocationPickerTextField *cityAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *fullAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *houseNumberTextfield;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *locationPromptView;
@property (weak, nonatomic) IBOutlet UIImageView *locationPointImgView;

@property(nonatomic,strong) UIDynamicAnimator* animator;
@property(nonatomic,strong) HALeapBehavior* behavior;

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

-(UIDynamicAnimator*)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.locationView];
        _animator.delegate = self;
    }
    return _animator;
}

-(HALeapBehavior*)behavior
{
    if (!_behavior) {
        _behavior = [[HALeapBehavior alloc] init];
        [self.animator addBehavior:_behavior];
    }
    
    return _behavior;
}

- (HAHouse*)house
{
    if (!_house) {
        _house = [[HAHouse alloc] init];
    }
    return _house;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
    self.cityAddressTextfield.locationPickerDelegate = self;
    UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HOAKit.bundle/HA_Green_Location_Icon"]];
    UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HOAKit.bundle/HA_Arrow_Right"]];
    self.cityAddressTextfield.leftView = leftView;
    self.cityAddressTextfield.rightView = rightView;
    
    if (!_house) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
//    CLLocationCoordinate2D touchMapCoordinate =
//        [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** Target Action ***
- (IBAction)canelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - *** MKMapViewDelegate ***
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    CLLocationCoordinate2D loc = [userLocation coordinate];
//    
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500, 500);
//    [mapView setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"touch begin");
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"touch end");
    self.locationPromptView.hidden = YES;
    [self.behavior addItem:self.locationPointImgView];
}


#pragma mark - *** HALocationPickerTextFieldDelegate ***

- (void)selectedObjectChangedForPickerTextField:(HALocationPickerTextField *)pickerTF address:(NSString *)address province:(NSInteger)pid city:(NSInteger)cid distict:(NSInteger)did
{
    self.house.province = pid;
    self.house.city = cid;
    self.house.distict = did;
    NSString *oreillyAddress = @"1005 Gravenstein Highway North, Sebastopol, CA 95472, USA";
    self.cityAddressTextfield.text = address;
    self.locationPromptView.hidden = YES;
    [self.behavior addItem:self.locationPointImgView];
//    HALocationPoint *centerPoint = [[HALocationPoint alloc] initWithCoordinate:coord];
//    [self.mapView addAnnotation:centerPoint];
}

#pragma mark - *** UIDynamicAnimatorDelegate ***

-(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    self.locationPromptView.hidden = NO;
    [self.behavior removeItem:self.locationPointImgView];
    self.behavior = nil;
    self.animator = nil;
}

#pragma mark - *** TextField Delegate ***
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.fullAddressTextfield == textField) {
        [self.houseNumberTextfield becomeFirstResponder];
    }
    if (self.houseNumberTextfield == textField) {
        [self.houseNumberTextfield resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.fullAddressTextfield == textField) {

        [self geocodeAddressString:self.fullAddressTextfield.text];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    HAHouseTypeTableViewController* destController = segue.destinationViewController;
    if ([destController respondsToSelector:@selector(setHouse:)]) {
        [destController setHouse:self.house];
    }
}

#pragma mark - *** ***
- (void)geocodeAddressString:(NSString*)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            CLLocationDegrees lat = firstPlacemark.location.coordinate.latitude;
            CLLocationDegrees lng = firstPlacemark.location.coordinate.longitude;
            self.house.lat = lat;
            self.house.lng = lng;
            self.house.address = address;
            
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
            CLLocationCoordinate2D coord = [loc coordinate];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
            [self.mapView setRegion:region animated:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
}

@end
