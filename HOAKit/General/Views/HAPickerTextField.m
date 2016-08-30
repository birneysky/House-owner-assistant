//
//  HAPickerTextField.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAPickerTextField.h"


@interface HAPickerTextField ()

@property (nonatomic,strong) UIPickerView* pickerView;

@property (nonatomic,strong) UIToolbar* toolbar;

@end

@implementation HAPickerTextField

#pragma mark - *** Properties ***

- (UIPickerView*) pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _pickerView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerView;
}

- (UIToolbar*)toolbar
{
    if (!_toolbar) {
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.barStyle = UIBarStyleDefault;
        _toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_toolbar sizeToFit];
        
        //_toolbar.barTintColor = [UIColor whiteColor];
        CGRect frame = self.toolbar.frame;
        frame.size.height = 44.0f;
        _toolbar.frame = frame;
        
        UIBarButtonItem* clearBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
        clearBtn.tintColor = [UIColor blackColor];
        UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
        doneBtn.tintColor = [UIColor blackColor];
        _toolbar.items = @[clearBtn,spacer,doneBtn];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43, screenSize.width, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1];
        [_toolbar addSubview:lineView];
    }
    return _toolbar;
}

#pragma mark - *** Init ***
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureInputView];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configureInputView];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self configureInputView];
    }
    return self;
}

- (void)configureInputView
{
    self.inputView = self.pickerView;
    self.inputAccessoryView = self.toolbar;
}

- (void) setDefultText:(NSString*)text
{
    self.text = text;
}




#pragma mark - *** Target Action ***
- (void)done
{
    [self resignFirstResponder];
    if ([self.pickerDelegate respondsToSelector:@selector(selectedObjectDoneForPickerTextField:)]) {
        [self.pickerDelegate selectedObjectDoneForPickerTextField:self];
    }
}

- (void)clear
{
    [self resignFirstResponder];
    if ([self.pickerDelegate respondsToSelector:@selector(selectedObjectCancelForPickTextField:)]) {
        [self.pickerDelegate selectedObjectCancelForPickTextField:self];
    }
}

@end
