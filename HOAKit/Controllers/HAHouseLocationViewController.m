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
#import "HAAppDataHelper.h"
#import "HARESTfulEngine.h"

@interface HAHouseLocationViewController ()<MKMapViewDelegate,HALocationPickerTextFieldDelegate,UIDynamicAnimatorDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager* locationManager;

@property (weak, nonatomic) IBOutlet HALocationPickerTextField *cityAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *fullAddressTextfield;
@property (weak, nonatomic) IBOutlet UITextField *houseNumberTextfield;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *locationPromptView;
@property (weak, nonatomic) IBOutlet UIImageView *locationPointImgView;
@property (strong, nonatomic) IBOutlet UILabel *textViewInputingLabel;

@property(nonatomic,strong) UIDynamicAnimator* animator;
@property(nonatomic,strong) HALeapBehavior* behavior;
@property(nonatomic,assign) HAValueValidState validFlag;

@property (nonatomic,copy) HAHouse* houseCopy;

@property (nonatomic,assign) BOOL newHouse;

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
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
    self.validFlag = HAValueValidStateNormal;
    if(_house)
    {
        self.navigationItem.rightBarButtonItem.title = @"确定";
        self.fullAddressTextfield.text = self.house.address;
        self.cityAddressTextfield.text = [HAAppDataHelper provincesAndCityAddress:self.house.province city:self.house.city distict:self.house.distict];
        self.houseNumberTextfield.text = self.house.houseNumber;
        
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:self.house.lat longitude:self.house.lng];
        CLLocationCoordinate2D coord = [loc coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
        [self.mapView setRegion:region animated:YES];
        self.houseCopy = self.house;
    }
    else{
        self.newHouse = YES;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
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

- (IBAction)nextBtnclicked:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"下一步"]) {
        [self performSegueWithIdentifier:@"push_house_type" sender:nil];
    }
    else{
        [NETWORKENGINE modifyHouseGeneralInfoWithID:self.houseCopy.houseId
                                             params:self.houseCopy
                                         completion:^(HAHouse* house){
                                             [self.delegate houseDidChangned:house];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                            onError:^(NSError *engineError) {
                                            
        }];
        
    }
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
    //NSString *oreillyAddress = @"1005 Gravenstein Highway North, Sebastopol, CA 95472, USA";
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.fullAddressTextfield == textField) {
        if((self.validFlag | HAValueValidStateNormal) == HAValueValidStateDetailAddress)
        {
            self.textViewInputingLabel.text = @"     请输1-60个字";
        }
    }
    else if (self.houseNumberTextfield == textField){
        if ((self.validFlag | HAValueValidStateNormal) == HAValueValidStateHouseNumber) {
            self.textViewInputingLabel.text = @"    请输1-30个字";
        }
    }
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

#pragma mark - *** Helper ***
- (void)geocodeAddressString:(NSString*)address{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            //NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            //NSLog(@"Longitude = %f", firstPlacemark.location.coordinate.longitude);
            //NSLog(@"Latitude = %f", firstPlacemark.location.coordinate.latitude);
            CLLocationDegrees lat = firstPlacemark.location.coordinate.latitude;
            CLLocationDegrees lng = firstPlacemark.location.coordinate.longitude;
            self.house.lat = lat;
            self.house.lng = lng;
            self.house.address = address;
            
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
            CLLocationCoordinate2D coord = [loc coordinate];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
            [self.mapView setRegion:region animated:YES];
            //self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else if ([placemarks count] == 0 && error == nil) {
            //NSLog(@"Found no placemarks.");
        } else if (error != nil) {
           // NSLog(@"An error occurred = %@", error);
        }
    }];
}

- (BOOL) limitTextViewTextLengthMin:(NSInteger)min max:(NSInteger)max textField:(UITextField*)textField warningText:(NSString*)text
{
    BOOL flag = NO;
    self.textViewInputingLabel.text = [NSString stringWithFormat:@"    %@",text];
    if (textField.text.length < min) {
        textField.inputAccessoryView = self.textViewInputingLabel;
        flag = NO;
    }
    else if(textField.text.length > max){
        textField.inputAccessoryView = self.textViewInputingLabel;
        flag = NO;
    }
    else{
        textField.inputAccessoryView = nil;
        flag = YES;
    }
    [textField reloadInputViews];
    return flag;
}

#pragma mark - *** Notification Selector ***
- (void)textFieldTextDidChange:(NSNotification*)notification
{
    UITextField* textField = notification.object;
    
    BOOL valid = YES;
    BOOL change = NO;
    if (textField == self.fullAddressTextfield) {
        valid = [self limitTextViewTextLengthMin:1 max:60 textField:textField warningText:@"请输1-60个字"];
        if (self.newHouse) {
            self.house.address = textField.text;
        }
        else{
           self.houseCopy.address = textField.text;
        }
        
        //change = ![self.houseCopy.title isEqualToString:self.house.title];
        if (!valid) {
            self.validFlag &= HAValueValidStateDetailAddress;
        }
        else{
            self.validFlag |= ~ HAValueValidStateDetailAddress;
        }
    }
    
    if (textField == self.cityAddressTextfield) {
        
    }
    
    if (textField == self.houseNumberTextfield) {
        valid = [self limitTextViewTextLengthMin:1 max:30 textField:textField warningText:@"请输1-30个字"];
        if (self.newHouse) {
            self.house.houseNumber = textField.text;
        }
        else{
             self.houseCopy.houseNumber = textField.text;
        }
       
        
        if (!valid) {
            self.validFlag &= HAValueValidStateHouseNumber;
        }
        else{
            self.validFlag |= ~ HAValueValidStateHouseNumber;
        }
    }
    
    change = ![self.house isEqualToHouse:self.houseCopy];
    BOOL validTest = (self.validFlag & HAValueValidStateNormal) == HAValueValidStateNormal;
    BOOL complete = self.newHouse ? self.house.address.length > 0 && self.house.houseNumber > 0 :  self.houseCopy.address.length > 0 && self.houseCopy.houseNumber > 0;
    if (change && validTest && complete) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
