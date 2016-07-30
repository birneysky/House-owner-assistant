//
//  HALocationPickerTextField.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HALocationPickerTextField.h"

@interface HALocationPickerTextField ()

@property (nonatomic,strong) UIPickerView* picker;
@property (nonatomic,strong) NSArray* pickerData;
@property (nonatomic,strong) UIToolbar* toolbar;

@end

@implementation HALocationPickerTextField

#pragma mark - *** Properties ***

- (UIPickerView*) picker
{
    if (!_picker) {
        _picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _picker.showsSelectionIndicator = YES;
        _picker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return _picker;
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
        self.inputView = self.picker;
        self.inputAccessoryView = self.toolbar;
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

#pragma mark - *** Target Action ***
- (void)done
{
    [self resignFirstResponder];
    if ([self.pickerDelegate respondsToSelector:@selector(selectedObjectChangedForPickerTextField:)]) {
        [self.pickerDelegate selectedObjectChangedForPickerTextField:self];
    }
}

- (void)clear
{
    //[self.pickerDelegate selectedObjectClearedForPickerTF:self];
    [self resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
