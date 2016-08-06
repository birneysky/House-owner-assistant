//
//  ProvinceDataSourceDelegate.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAProvinceDataSourceDelegate.h"

@interface HAProvinceDataSourceDelegate ()

@property (nonatomic,strong) NSDictionary* dataSource;

@end

@implementation HAProvinceDataSourceDelegate

#pragma makr - *** Init ***
- (instancetype)init{
    if (self = [super init]) {
        [self configDataSource];
    }
    return self;
}

- (void)configDataSource
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit.bundle/province" ofType:@"json"];
    
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    self.dataSource = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
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

@end
