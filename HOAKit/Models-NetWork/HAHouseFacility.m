//
//  HAHouseFacilitiy.m
//  HOAKit
//
//  Created by birneysky on 16/8/12.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseFacility.h"

@implementation HAHouseFacility

- (void) setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.houseId = [value integerValue];
    }
}

- (NSDictionary*) toFullDictionary
{
    NSDictionary* dic = [super toFullDictionary];
    NSMutableDictionary* mutableDic = [[NSMutableDictionary alloc] initWithDictionary:dic copyItems:NO];
    [mutableDic removeObjectForKey:@"houseId"];
    [mutableDic setObject:@(self.houseId) forKey:@"id"];
    [mutableDic removeObjectForKey:@"resetFlag"];
    return [mutableDic copy];
}

- (BOOL) boolValueOfChineseName:(NSString*)text
{
    BOOL value = NO;
    if ([text isEqualToString:@"热水淋浴"]) {
        value =  self.hotShower;
    }
    else if ([text isEqualToString:@"沙发"]){
        value = self.sofa;
    }
    else if ([text isEqualToString:@"沐浴露"]){
        value =  self.showerGel;
    }
    else if ([text isEqualToString:@"电视"]){
        value = self.tv;
    }
    else if ([text isEqualToString:@"微波炉"]){
        value = self.microwaveOven ;
    }
    else if ([text isEqualToString:@"电脑"]){
        value = self.computer;
    }
    else if ([text isEqualToString:@"空调"]){
        value = self.airCondition;
    }
    else if ([text isEqualToString:@"饮水机"]){
        value = self.drinkingFountain;
    }
    else if ([text isEqualToString:@"冰箱"]){
        value = self.refrigerator;
    }
    else if ([text isEqualToString:@"洗衣机"]){
        value = self.washer;
    }
    else if ([text isEqualToString:@"wifi"]){
        value = self.wifi;
    }
    else if ([text isEqualToString:@"有线网络"]){
        value = self.wiredNetwork;
    }
    else if ([text isEqualToString:@"有停车位"]){
        value = self.parkingSpace;
    }
    else if ([text isEqualToString:@"允许抽烟"]){
        value = self.smokingAllowed;
    }
    else if ([text isEqualToString:@"允许做饭"]){
        value = self.cookAllowed;
    }
    else if ([text isEqualToString:@"允许带宠物"]){
        value = self.petsAllowed;
    }
    else if ([text isEqualToString:@"允许聚会"]){
        value = self.partyAllowed;
    }
    return value;

}

- (void) setValue:(BOOL)value forChineseName:(NSString*)text
{
    if ([text isEqualToString:@"热水淋浴"]) {
        self.hotShower = value;
    }
    else if ([text isEqualToString:@"沙发"]){
        self.sofa = value;
    }
    else if ([text isEqualToString:@"沐浴露"]){
        self.showerGel = value;
    }
    else if ([text isEqualToString:@"电视"]){
        self.tv = value;
    }
    else if ([text isEqualToString:@"微波炉"]){
        self.microwaveOven = value;
    }
    else if ([text isEqualToString:@"电脑"]){
        self.computer = value;
    }
    else if ([text isEqualToString:@"空调"]){
        self.airCondition = value;
    }
    else if ([text isEqualToString:@"饮水机"]){
        self.drinkingFountain = value;
    }
    else if ([text isEqualToString:@"冰箱"]){
        self.refrigerator = value;
    }
    else if ([text isEqualToString:@"洗衣机"]){
        self.washer = value;
    }
    else if ([text isEqualToString:@"wifi"]){
        self.wifi = value;
    }
    else if ([text isEqualToString:@"有线网络"]){
        self.wiredNetwork = value;
    }
    else if ([text isEqualToString:@"有停车位"]){
        self.parkingSpace = value;
    }
    else if ([text isEqualToString:@"允许抽烟"]){
        self.smokingAllowed = value;
    }
    else if ([text isEqualToString:@"允许做饭"]){
        self.cookAllowed = value;
    }
    else if ([text isEqualToString:@"允许带宠物"]){
        self.petsAllowed = value;
    }
    else if ([text isEqualToString:@"允许聚会"]){
        self.partyAllowed = value;
    }

}


@end
