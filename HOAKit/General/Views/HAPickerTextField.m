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
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _pickerView;
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
