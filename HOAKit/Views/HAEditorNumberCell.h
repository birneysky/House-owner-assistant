//
//  HAEditorCell.h
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HAEditorNumberCell : UITableViewCell

@property (nonatomic,readonly) UITextField* textField;

@property (nonatomic,copy) NSString* unitName;

@end
