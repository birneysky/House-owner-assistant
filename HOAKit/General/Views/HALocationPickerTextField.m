//
//  HALocationPickerTextField.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HALocationPickerTextField.h"

@interface HALocationPickerTextField () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIPickerView* picker;

@property (nonatomic,strong) UIToolbar* toolbar;

@property (nonatomic,strong) NSDictionary* dataSource;

@end

@implementation HALocationPickerTextField

#pragma mark - *** Properties ***

- (UIPickerView*) picker
{
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _picker.showsSelectionIndicator = YES;
        _picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        self.picker.dataSource = self;
        self.picker.delegate = self;
    }
    return _picker;
}

- (UIToolbar*)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.barStyle = UIBarStyleBlackTranslucent;
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_toolbar sizeToFit];
        CGRect frame = self.toolbar.frame;
        frame.size.height = 44.0f;
        _toolbar.frame = frame;
        
        UIBarButtonItem* clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
        UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        _toolbar.items = @[clearBtn,spacer,doneBtn];
    }
    return _toolbar;
}

#pragma mark - *** Init ***

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.inputView = self.picker;
        self.inputAccessoryView = self.toolbar;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit.bundle/province" ofType:@"json"];
        
        NSData* data = [NSData dataWithContentsOfFile:path];
        
        NSError* error;
        self.dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        //NSLog(@"%@",dic);
    }
    return self;
}


- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width, bounds.size.height);
    
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 30, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (void)awakeFromNib
{
//    [self.picker selectRow:1 inComponent:0 animated:YES];
//    [self.picker selectRow:1 inComponent:1 animated:YES];
//    [self.picker selectRow:1 inComponent:2 animated:YES];
}

#pragma mark - *** Target Action ***
- (void)done
{
    [self resignFirstResponder];
    
    NSInteger provinceIndex = [self.picker selectedRowInComponent:0];
    NSInteger cityIndex = [self.picker selectedRowInComponent:1];
    NSInteger townIndex = [self.picker selectedRowInComponent:2];
    
    NSMutableString* address = [[NSMutableString alloc] initWithCapacity:100];
    double  lat = 0;
    double  lng = 0;
    
    NSArray* provinces = self.dataSource[@"child"];
    NSDictionary* provice = provinces[provinceIndex];
    lat = [provice[@"Lat"] doubleValue];
    lng = [provice[@"lng"] doubleValue];
    [address appendString:provice[@"Name"]];
    NSArray* citys = provice[@"child"];
    if (cityIndex < citys.count) {
        NSDictionary* city = citys[cityIndex];
        [address appendFormat:@"-%@",city[@"Name"]];
        lat = [city[@"Lat"] doubleValue];
        lng = [city[@"lng"] doubleValue];
        
        NSArray* towns = city[@"child"];
        if (townIndex < towns.count) {
            NSDictionary* town = towns[townIndex];
            [address appendFormat:@"-%@",town[@"Name"]];
            lat = [town[@"Lat"] doubleValue];
            lng = [town[@"lng"] doubleValue];
        }
    }
    
    
    
    NSLog(@"==> proviceIndex %d, cityIndex %d, townIndex %d",provinceIndex,cityIndex,townIndex);
    NSLog(@"==> address %@ lat %f lng %f",address,lat,lng);
    if ([self.pickerDelegate respondsToSelector:@selector(selectedObjectChangedForPickerTextField: address:latitude:longitude:)]) {
        [self.pickerDelegate selectedObjectChangedForPickerTextField:self address:[address copy] latitude:lat longitude:lng];
    }
}

- (void)clear
{
    //[self.pickerDelegate selectedObjectClearedForPickerTF:self];
    [self resignFirstResponder];
}


#pragma mark - *** UIPicker DataSource ***
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    NSInteger proviceIndex = [pickerView selectedRowInComponent:0];
    if(-1 == proviceIndex)
    {
        return count;
    }
    
    NSArray* provinces = self.dataSource[@"child"];
    if (0 == component) {
        count =  provinces.count;
    }
    else if (1 == component){
        NSDictionary* provice = provinces[proviceIndex];
        NSArray* citys = provice[@"child"];
        count = citys.count;
    }
    else{
        NSDictionary* provice = provinces[proviceIndex];
        NSArray* citys = provice[@"child"];
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
//        if (-1 == cityIndex) {
//            return count;
//        }
        if (cityIndex >= citys.count) {
            return count;
        }
        NSDictionary* city = citys[cityIndex];
        NSArray* twons = city[@"child"];
        
        count = twons.count;
    }
    return count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 100.0f;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //return [self.pickerData objectAtIndex:row];
    NSString* title = nil;
    NSInteger provinceIndex = [pickerView selectedRowInComponent:0];
    if(-1 == provinceIndex)
    {
        assert(0);
    }
    
    if(0 == component)
    {
        NSArray* provinces = self.dataSource[@"child"];
        NSDictionary* province = provinces[row];
        title = province[@"Name"];
    }
    else if (1 == component){
        NSArray* provinces = self.dataSource[@"child"];
        NSDictionary* province = provinces[provinceIndex];
        NSArray* citys = province[@"child"];
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        if (row >= citys.count) {
            return title;
        }
        NSDictionary* city =citys[row];
        title = city[@"Name"];
    }
    else{
        NSArray* provinces = self.dataSource[@"child"];
        NSDictionary* province = provinces[provinceIndex];
        NSArray* citys = province[@"child"];
        NSInteger cityIndex = [pickerView selectedRowInComponent:1];
        if (cityIndex >= citys.count) {
            return title;
        }
        NSDictionary* city = citys[cityIndex];
        NSArray* towns = city[@"child"];
        NSInteger townIndex = [pickerView selectedRowInComponent:2];
        if (row >= towns.count) {
            return title;
        }
        NSDictionary* town = towns[row];
        title = town[@"Name"];
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   if(0 == component)
    {
        if (34 == row) {
            
        }
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        //[pickerView selectRow:2 inComponent:1 animated:YES];
        //[pickerView selectRow:2 inComponent:2 animated:YES];
    }
   else if (1 == component){
       [pickerView reloadComponent:2];
       //[pickerView selectRow:2 inComponent:2 animated:YES];
   }
//    else
//    {
//        
//        [pickerView reloadComponent:0];
//    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
