//
//  HAHouseFullInfo.m
//  HOAKit
//
//  Created by zhangguang on 16/8/15.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseFullInfo.h"

@implementation HAHouseFullInfo

- (BOOL) houseImageComplete
{
    return self.images.count >= 5 ;
}

- (BOOL) houseGeneralInfoComplete
{
    return self.house.area.length > 0 && self.house.roomNumber > 0 && self.house.toliveinNumber > 0 && (self.house.toiletNumber > 0 || self.house.publicToiletNumber > 0);
}

- (BOOL) bedInfoComplete
{
    return self.beds.count > 0;
}

- (BOOL) houseDescriptionComplete
{
    return self.house.title.length > 0 && self.house.houseDescription.length > 0;
}

- (BOOL) facilityInfoComplete
{
//    if (self.facility) {
//        return YES;
//    }
//    else{
//        return NO;
//    }

    if( self.facility.hotShower &&
       self.facility.sofa &&
       self.facility.showerGel &&
       self.facility.tv &&
       self.facility.microwaveOven &&
       self.facility.computer &&
       self.facility.airCondition &&
       self.facility.drinkingFountain &&
       self.facility.refrigerator &&
       self.facility.washer &&
       self.facility.wifi &&
       self.facility.wiredNetwork &&
       self.facility.parkingSpace &&
       self.facility.smokingAllowed &&
       self.facility.cookAllowed &&
       self.facility.petsAllowed &&
       self.facility.partyAllowed){
        return NO;
    }
    else{
        return YES;
    }
}

- (BOOL) priceInfoComplete
{
    return self.house.price > 0;
}

- (BOOL) regionInfoComplete
{
    return self.positions.count > 0;
}
- (BOOL) addressInfoComplete
{
    return self.house.address.length > 0 && self.house.houseNumber.length > 0;
}

- (BOOL) rentTypeComplete
{
    return self.house.rentType > 0;
}

@end
