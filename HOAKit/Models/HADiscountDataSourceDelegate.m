//
//  HADiscountDataSourceDelegate.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HADiscountDataSourceDelegate.h"

@interface HADiscountDataSourceDelegate ()

@property(nonatomic,strong) NSArray* dataSource;

@end

@implementation HADiscountDataSourceDelegate

#pragma mark - *** Properties ***
- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@[@"5",@"6",@"7",@"8",@"9"],@[@"0",@"5"], nil];
    }
    return _dataSource;
}


#pragma makr - *** Init ***
- (instancetype)init{
    if (self = [super init]) {
        [self configDataSource];
    }
    return self;
}

- (void)configDataSource
{
}

#pragma mark - *** UIPicker DataSource ***
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataSource.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray* array = self.dataSource[component];
    return array.count;
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
    
    return self.dataSource[component][row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}



@end
