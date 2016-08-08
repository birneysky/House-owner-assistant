//
//  HAHouseTypeDataSouceDelegate.m
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseTypeDataSouceDelegate.h"


@interface HAHouseTypeDataSouceDelegate ()

@property(nonatomic,strong) NSArray* dataSource;

@property (nonatomic,strong) NSArray* otherDataSource;

@property(nonatomic,weak) UIPickerView* weakPickView;

@property (nonatomic,strong) NSArray* nameArray;


@end

@implementation HAHouseTypeDataSouceDelegate

- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"9+", nil];
    }
    return _dataSource;
}

- (NSArray*) otherDataSource
{
    if (!_otherDataSource) {
        _otherDataSource = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"9+", nil];
    }
    return _otherDataSource;
}


- (NSArray*) nameArray
{
    if (!_nameArray) {
        _nameArray = [[NSArray alloc] initWithObjects:@"室",@"厅",@"厨",@"阳台", nil];
    }
    return _nameArray;
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
    return self.nameArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (0 == component) {
        return self.dataSource.count;
    }
    else{
        return self.otherDataSource.count;
    }
    
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
    NSString* text = nil;
    if (0 == component) {
        text = [NSString stringWithFormat:@"%@ %@",self.dataSource[row],self.nameArray[component]];
    }
    else{
        text = [NSString stringWithFormat:@"%@ %@",self.otherDataSource[row],self.nameArray[component]];
    }
    
    return text;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
//    NSUInteger index = [pickerView selectedRowInComponent:component];
//    NSString* restult = self.dataSource[index];
//    if ([self.resultDelegate respondsToSelector:@selector(pickerView:didSelectResultText:)]) {
//        //NSString* result = [NSString stringWithFormat:@"%d.%d 折",self.dataSource ]
//        [self.resultDelegate pickerView:pickerView didSelectResultText:restult];
//    }
}

- (NSString*)selectResult
{
    NSUInteger index = [self.weakPickView selectedRowInComponent:0];
    return self.dataSource[index];
}


@end
