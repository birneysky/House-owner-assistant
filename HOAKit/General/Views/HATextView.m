//
//  HATextView.m
//  HOAKit
//
//  Created by birneysky on 16/8/4.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HATextView.h"

@interface HATextView ()

@property(nonatomic,weak) UILabel* placeholderLable;

@end

@implementation HATextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configView];
    }
    return self;
}

- (void)configView
{
    //self.backgroundColor= [UIColor clearColor];
    
    UILabel *placeholderLabel = [[UILabel alloc]init];//添加一个占位label
    
    placeholderLabel.backgroundColor= [UIColor clearColor];
    
    placeholderLabel.numberOfLines=0; //设置可以输入多行文字时可以自动换行
    placeholderLabel.font = self.font;
    placeholderLabel.text = self.placeholder;
    placeholderLabel.textColor = [UIColor colorWithRed:196/255.0f green:196/255.0f blue:202/255.0f alpha:1];
    [self addSubview:placeholderLabel];
    
    
    self.placeholderLable= placeholderLabel; //赋值保存
    
    
    //self.font= [UIFont systemFontOfSize:15]; //设置默认的字体
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self]; //通知:监听文字的改变
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    

    CGFloat x = 5;
    CGFloat y = 8;
    CGFloat width = self.bounds.size.width - x * 2.0;
    
    //根据文字计算高度
    
    CGSize maxSize =CGSizeMake(width,MAXFLOAT);
    
    CGFloat height= [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLable.font} context:nil].size.height;
    
    self.placeholderLable.frame = CGRectMake(x, y, width, height);
    
}


- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    self.placeholderLable.text = _placeholder;
}

#pragma mark - ***Notification Selector ***

- (void)textDidChange {
    
    self.placeholderLable.hidden = self.hasText;
    
}


@end
