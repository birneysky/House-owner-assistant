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
#import "HAActiveWheel.h"
#import "HOAKit.h"

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
@property (weak, nonatomic) IBOutlet UILabel *stupidLabel;

@property(nonatomic,strong) UIDynamicAnimator* animator;
@property(nonatomic,strong) HALeapBehavior* behavior;
@property(nonatomic,assign) HAValueValidState validFlag;

@property (nonatomic,copy) HAHouse* houseCopy;

@property (nonatomic,assign) BOOL newHouse;

@property (nonatomic,assign) BOOL latAndLngValidityFlag;

@end


void GCJ02FromBD09(double gg_lat, double gg_lon, double* bd_lat, double* bd_lon)

{
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    
    double x = gg_lon - 0.0065, y = gg_lat - 0.006;
    
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    
    *bd_lon = z * cos(theta);
    
    *bd_lat = z * sin(theta);
    
}

void BD09FromGCJ02(double gg_lat, double gg_lon, double* bd_lat, double* bd_lon)

{
    double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    
    double x = gg_lon , y = gg_lat;
    
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    
    *bd_lon = z * cos(theta) +  0.0065;
    
    *bd_lat = z * sin(theta) + + 0.006;
    
}

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
    [self.mapView layoutIfNeeded];
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
    self.cityAddressTextfield.locationPickerDelegate = self;
    UIImageView* leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HOAKit.bundle/HA_Green_Location_Icon"]];
    leftView.frame = CGRectMake(0, 0, 30, 30);
    UIImageView* rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HOAKit.bundle/HA_Arrow_Down"]];
    rightView.frame = CGRectMake(0, 0, 20, 20);
    self.cityAddressTextfield.leftView = leftView;
    self.cityAddressTextfield.rightView = rightView;
    self.validFlag = HAValueValidStateNormal;
    if(_house)
    {
        self.navigationItem.rightBarButtonItem.title = @"修改";
        self.fullAddressTextfield.text = self.house.address;
        self.cityAddressTextfield.text = [HAAppDataHelper provincesAndCityAddress:self.house.province city:self.house.city distict:self.house.distict];
        self.houseNumberTextfield.text = self.house.houseNumber;
        self.fullAddressTextfield.returnKeyType = UIReturnKeyDone;
        
        double lat = 0;
        double lng = 0;
        BD09FromGCJ02(self.house.lat, self.house.lng, &lat, &lng);
        CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
        CLLocationCoordinate2D coord = [loc coordinate];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
        [self.mapView setRegion:region animated:YES];
        self.houseCopy = self.house;
        self.latAndLngValidityFlag = YES;   
    }
    else{
        self.newHouse = YES;
    }
    
    //self.navigationItem.rightBarButtonItem.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"地理位置";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - *** Target Action ***
- (IBAction)canelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextBtnclicked:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];
    BOOL flag = [self checkAdressValidity];
    if (!flag) {
        return;
    }
    
    if ([sender.title isEqualToString:@"下一步"]) {
        [self performSegueWithIdentifier:@"push_house_type" sender:nil];
    }
    else{
        [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
        [NETWORKENGINE modifyHouseGeneralInfoWithID:self.houseCopy.houseId
                                             params:self.houseCopy
                                         completion:^(HAHouse* house){
                                             [self.delegate houseDidChangned:house];
                                             [HAActiveWheel dismissForView:self.navigationController.view];
                                             [self.navigationController popViewControllerAnimated:YES];
                                             [[NSNotificationCenter defaultCenter] postNotificationName:HAHouseModifyInformationNotification object:house];
                                         }
                                            onError:^(NSError *engineError) {
                                                 [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
                                            
        }];
        
    }
}

#pragma mark - *** MKMapViewDelegate ***
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{

}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{

}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.locationPromptView.hidden = YES;
    [self.behavior addItem:self.locationPointImgView];
    CLLocationCoordinate2D mapCenterCoordinate =
        [self.mapView convertPoint:self.mapView.center toCoordinateFromView:self.mapView];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:mapCenterCoordinate.latitude longitude:mapCenterCoordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            self.stupidLabel.text = placemark.name;
        }
        else if (error == nil && [array count] == 0)
        {
             NSLog(@"No results were returned.");
             self.stupidLabel.text = @"拖动地图标记房源位置";
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
            self.stupidLabel.text = @"拖动地图标记房源位置";
        }
    }];
}


#pragma mark - *** HALocationPickerTextFieldDelegate ***

- (void)selectedObjectChangedForPickerTextField:(HALocationPickerTextField *)pickerTF address:(NSString *)address province:(NSInteger)pid city:(NSInteger)cid distict:(NSInteger)did
{
    self.house.province = pid;
    self.house.city = cid;
    self.house.distict = did;

    self.cityAddressTextfield.text = address;
    self.locationPromptView.hidden = YES;
    [self.behavior addItem:self.locationPointImgView];
    
    [self geocodeAddressString:address ignoreLatAndLng:YES];
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
        self.houseNumberTextfield.text.length > 0 ? [textField resignFirstResponder] : [self.houseNumberTextfield becomeFirstResponder];
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
        if(2 == self.houseCopy.checkStatus)
        {
            [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"房源已通过审核，不可修改"];
            return NO;
        }
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

        [self geocodeAddressString:self.fullAddressTextfield.text ignoreLatAndLng:NO];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    HAHouseTypeTableViewController* destController = segue.destinationViewController;
    if ([destController respondsToSelector:@selector(setHouse:)]) {
        [destController setHouse:self.house];
    }
}

#pragma mark - *** Helper ***
- (void)geocodeAddressString:(NSString*)address ignoreLatAndLng:(BOOL) ignore{
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            CLLocationDegrees lat = firstPlacemark.location.coordinate.latitude;
            CLLocationDegrees lng = firstPlacemark.location.coordinate.longitude;
            double blat = 0;
            double blng = 0;
            GCJ02FromBD09(lat,lng,&blat,&blng);
            if(!ignore){
                if (self.newHouse) {
                    self.house.lat = blat;
                    self.house.lng = blng;
                    self.house.address = address;
                }
                else{
                    self.houseCopy.lat = blat;
                    self.houseCopy.lng = blng;
                    self.house.address = address;
                }
                
                self.latAndLngValidityFlag = YES;
                //[self checkAdressValidity];
            }

            CLLocation *loc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
            CLLocationCoordinate2D coord = [loc coordinate];
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
            [self.mapView setRegion:region animated:YES];
        }
        else if ([placemarks count] == 0 && error == nil) {

        } else if (error != nil) {

            [self.view endEditing:YES];
            [HAActiveWheel showErrorHUDAddedTo:self.navigationController.view errText:@"输入地址有误"];
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
        
        if (!valid) {
            self.validFlag &= HAValueValidStateDetailAddress;
        }
        else{
            self.validFlag |= ~ HAValueValidStateDetailAddress;
        }
        
        self.latAndLngValidityFlag = NO;
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
    
    //[self checkAdressValidity];
}

#pragma mark - *** Helper ***
- (BOOL)checkAdressValidity
{
    BOOL change = ![self.house isEqualToHouse:self.houseCopy];
    BOOL validTest = (self.validFlag & HAValueValidStateNormal) == HAValueValidStateNormal;
    if(self.cityAddressTextfield.text.length <= 0)
    {
         [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"请选择城市"];
    }
    else if (self.house.address.length <= 0) {
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"请先填写详细位置"];
        
    }else if (self.house.houseNumber.length <=0)
    {
         [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"请先填写门牌号"];
    }
    BOOL complete = self.newHouse ? self.house.address.length > 0 && self.house.houseNumber > 0 :  self.houseCopy.address.length > 0 && self.houseCopy.houseNumber > 0;
    if (change && validTest && complete && self.latAndLngValidityFlag) {
        //self.navigationItem.rightBarButtonItem.enabled = YES;
        return YES;
    }
    else{
        //self.navigationItem.rightBarButtonItem.enabled = NO;
        return NO;
    }
}


@end
