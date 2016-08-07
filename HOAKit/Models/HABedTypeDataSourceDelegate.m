//
//  HABedTypeDataSourceDelegate.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HABedTypeDataSourceDelegate.h"

@interface HABedTypeDataSourceDelegate ()

@property(nonatomic,strong) NSArray* dataSource;
@property(nonatomic,weak) UIPickerView* weakPickView;

@end

@implementation HABedTypeDataSourceDelegate

#pragma mark - *** Properties ***
- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"双人床",@"单人床",@"双层床",@"单人沙发床",@"双人沙发床",@"儿童床",@"园床",@"气垫床", nil];
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
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return self.dataSource.count;
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
    
    return self.dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

     NSUInteger index = [pickerView selectedRowInComponent:component];
    NSString* restult = self.dataSource[index];
    if ([self.resultDelegate respondsToSelector:@selector(pickerView:didSelectResultText:)]) {
        //NSString* result = [NSString stringWithFormat:@"%d.%d 折",self.dataSource ]
        [self.resultDelegate pickerView:pickerView didSelectResultText:restult];
    }
}

- (NSString*)selectResult
{
    NSUInteger index = [self.weakPickView selectedRowInComponent:0];
    return self.dataSource[index];
}

@end
