//
//  HABathroomDataSourceDelegate.m
//  HOAKit
//
//  Created by zhangguang on 16/8/8.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HABathroomDataSourceDelegate.h"


@interface HABathroomDataSourceDelegate ()

@property(nonatomic,strong) NSArray* dataSource;
@property(nonatomic,weak) UIPickerView* weakPickView;
@property(nonatomic,strong) NSArray* nameArray;

@end

@implementation HABathroomDataSourceDelegate


#pragma mark - *** Properties ***
- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@[@"3",@"2",@"1",@"0"],@[@"3",@"2",@"1",@"0"], nil];
    }
    return _dataSource;
}

- (NSArray*)nameArray
{
    if (!_nameArray) {
        _nameArray = [[NSArray alloc] initWithObjects:@"公共",@"独立", nil];
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
    NSString* text = [NSString stringWithFormat:@"%@ %@",self.nameArray[component],self.dataSource[component][row]];
    return text;
}

- (NSString*)currentResult
{
    NSMutableString* result = [[NSMutableString alloc] initWithCapacity:100];
    for (int i = 0; i < self.nameArray.count; i++) {
        NSUInteger index = [self.weakPickView selectedRowInComponent:i];
        [result appendFormat:@"%@%@",self.nameArray[i],self.dataSource[i][index]];
    }
    
    return [result copy];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSString* restult = [self currentResult];
    if ([self.resultDelegate respondsToSelector:@selector(pickerView:didSelectResultText:)]) {
//        //NSString* result = [NSString stringWithFormat:@"%d.%d 折",self.dataSource ]
        [self.resultDelegate pickerView:pickerView didSelectResultText:restult];
    }
    [self callDetailResultDelegate];
}

- (NSString*)selectResult
{
//    NSUInteger index = [self.weakPickView selectedRowInComponent:0];
//    return self.dataSource[index];
    [self callDetailResultDelegate];
    return [self currentResult];
}

- (void)currentDetailResult:(NSInteger*)pResult len:(NSUInteger)len
{
    for (int i = 0; i < self.nameArray.count; i++) {
        NSUInteger index = [self.weakPickView selectedRowInComponent:i];
        *(pResult+i) = [self.dataSource[i][index] integerValue];
    }
}

- (void)callDetailResultDelegate{
    NSInteger detailResult[2] = {};
    [self currentDetailResult:detailResult len:2];
    if ([self.detailResultDelegate respondsToSelector:@selector(didSelectPublicBathroom:privateBathroom:)]) {
        [self.detailResultDelegate didSelectPublicBathroom:detailResult[0] privateBathroom:detailResult[1]];
    }
}

@end
