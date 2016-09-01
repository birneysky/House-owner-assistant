//
//  HADiscountDataSourceDelegate.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HADiscountDataSourceDelegate.h"
#import "HAEditPickerDelegate.h"

@interface HADiscountDataSourceDelegate () <HAEditPickerDelegate>

@property(nonatomic,strong) NSArray* dataSource;
@property(nonatomic,weak) UIPickerView* weakPickView;

@end

@implementation HADiscountDataSourceDelegate

#pragma mark - *** Properties ***
- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@[@"5",@"6",@"7",@"8",@"9",@"10"],[[NSMutableArray alloc] initWithObjects:@"0",@"5", nil], nil];
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
    self.weakPickView = pickerView;
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
    NSMutableArray* array = self.dataSource[1];
    NSString* title = self.dataSource[0][row];
    if ([title isEqualToString:@"10"]) {
        [self.dataSource[1] removeObject:@"5"];
        [pickerView reloadComponent:1];
    }
    else if (array.count < 2){
        [array addObject:@"5"];
        [pickerView reloadComponent:1];
    }
    
    NSString* result = [self currentResult];
    
    if ([self.resultDelegate respondsToSelector:@selector(pickerView:didSelectResultText:)]) {
        //NSString* result = [NSString stringWithFormat:@"%d.%d 折",self.dataSource ]
        [self.resultDelegate pickerView:pickerView didSelectResultText:[result copy]];
    }
    
    if ([self.detailResultDelegate respondsToSelector:@selector(didSelectDiscount:)]) {
        [self.detailResultDelegate didSelectDiscount:[result floatValue] ];
    }
}

- (NSString*)currentResult
{
    NSUInteger lastIndex = self.dataSource.count - 1;
    NSMutableString* result = [[NSMutableString alloc] initWithCapacity:100];
    for (int i = 0; i <= lastIndex; i++) {
        NSUInteger index = [self.weakPickView selectedRowInComponent:i];
        [result appendFormat:@"%@.",self.dataSource[i][index]];
        if (i == lastIndex) {
            [result deleteCharactersInRange:NSMakeRange(result.length - 1, 1)];
        }
    }
    return [result copy];
}

- (NSString*)selectResult
{
    NSString* result = [self currentResult];

    if ([self.detailResultDelegate respondsToSelector:@selector(didSelectDiscount:)]) {
        [self.detailResultDelegate didSelectDiscount:[result floatValue] ];
    }
    return result;
}





@end
