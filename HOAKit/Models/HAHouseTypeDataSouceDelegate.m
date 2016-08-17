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
    self.weakPickView = pickerView;
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

    NSString* result = [self currentResult];
    
//    NSUInteger index = [pickerView selectedRowInComponent:component];
//    NSString* restult = self.dataSource[index];
    if ([self.resultDelegate respondsToSelector:@selector(pickerView:didSelectResultText:)]) {
//        //NSString* result = [NSString stringWithFormat:@"%d.%d 折",self.dataSource ]
        [self.resultDelegate pickerView:pickerView didSelectResultText:result];
    }
    
    [self callDetailResultDelegate];
}

- (void)currentDetailResult:(NSInteger*)pResult len:(NSUInteger)len
{
    for (int i = 0; i < self.nameArray.count; i++) {
        NSUInteger index = [self.weakPickView selectedRowInComponent:i];
        if (i == 0){
            *(pResult+i) = [self.dataSource[index] integerValue];
        }
        else{
              *(pResult+i) = [self.otherDataSource[index] integerValue];
        }
        
    }
}

- (NSString*)currentResult
{
    NSMutableString* result = [[NSMutableString alloc] initWithCapacity:100];
    for (int i = 0; i < self.nameArray.count; i++) {
        NSUInteger index = [self.weakPickView selectedRowInComponent:i];
        
        if (i == 0) {
            [result appendFormat:@"%@%@",self.dataSource[index],self.nameArray[i]];
        }
        else{
            [result appendFormat:@"%@%@",self.otherDataSource[index],self.nameArray[i]];
        }
    }
    
    return [result copy];
}

- (void)callDetailResultDelegate
{
    NSInteger detailResult[4] = {};
    [self currentDetailResult:detailResult len:4];
    if ([self.detailResultDelegate respondsToSelector:@selector(didSelectRoom:hall:cookroom:balcony:)]) {
        [self.detailResultDelegate didSelectRoom:detailResult[0] hall:detailResult[1] cookroom:detailResult[2] balcony:detailResult[3]];
    }
}

- (NSString*)selectResult
{
    [self callDetailResultDelegate];
    return [self currentResult];
}


@end
