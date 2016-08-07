//
//  PickerViewDidSelectResultDelegate.h
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

@protocol HAEditPickerDelegate <NSObject>

@optional

- (void)pickerView:(UIPickerView *)pickerView didSelectResultText:(NSString*)text;

@end
