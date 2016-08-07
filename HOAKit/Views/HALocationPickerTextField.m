//
//  HALocationPickerTextField.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HALocationPickerTextField.h"
#import "HAProvinceDataSourceDelegate.h"

@interface HALocationPickerTextField () <UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) HAProvinceDataSourceDelegate* dataSourceDelegate;

@end

@implementation HALocationPickerTextField

#pragma mark - *** Properties ***
- (HAProvinceDataSourceDelegate*) dataSourceDelegate
{
    if (!_dataSourceDelegate) {
        _dataSourceDelegate = [[HAProvinceDataSourceDelegate alloc] init];
    }
    return _dataSourceDelegate;
}

#pragma mark - *** Init ***

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.pickerDelegate = self;
        self.pickerView.dataSource = self.dataSourceDelegate;
        self.pickerView.delegate = self.dataSourceDelegate;
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

#pragma mark - *** HAPickerTextFieldDelegate ***
- (void)selectedObjectDoneForPickerTextField:(HAPickerTextField*)pickerTF 
{
    NSInteger provinceIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger cityIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger townIndex = [self.pickerView selectedRowInComponent:2];
    
    NSMutableString* address = [[NSMutableString alloc] initWithCapacity:100];
    double  lat = 0;
    double  lng = 0;
    
    NSArray* provinces = self.dataSourceDelegate.dataSource[@"child"];
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
    if ([self.locationPickerDelegate respondsToSelector:@selector(selectedObjectChangedForPickerTextField: address:latitude:longitude:)]) {
        [self.locationPickerDelegate selectedObjectChangedForPickerTextField:self address:[address copy] latitude:lat longitude:lng];
    }
}

- (void)selectedObjectCancelForPickTextField:(HAPickerTextField*)pickerTF text:(NSString*)result
{
    
}


@end