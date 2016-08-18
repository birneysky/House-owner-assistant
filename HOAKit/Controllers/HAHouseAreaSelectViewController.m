//
//  HAHouseAreaSelectViewController.m
//  HOAKit
//
//  Created by birneysky on 16/8/11.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseAreaSelectViewController.h"
#import "RTArealocationView.h"
#import "HARESTfulEngine.h"
#import "HARegion.h"
#import "HAHouse.h"
#import "HAAppDataHelper.h"
#import "HAHousePosition.h"

const NSInteger MAXLEVEL =  3;

@interface HAHouseAreaSelectViewController ()<ArealocationViewDelegate>

@property (nonatomic, strong) RTArealocationView *arealocationView;

@property (nonatomic, strong) NSMutableArray<HARegion*>* allRegions;

@property (nonatomic, strong) NSArray* regionNames;

//@property (nonatomic, strong) NSArray* selectedIndexs;

@property (nonatomic, strong) NSMutableDictionary<NSString*,HAHousePosition*>* positionDic;

@end

@implementation HAHouseAreaSelectViewController
{
    NSInteger _selectedIndexs[MAXLEVEL];
}

#pragma mark - *** Properties ***

- (RTArealocationView*) arealocationView
{
    if (!_arealocationView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _arealocationView = [[RTArealocationView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height-64)];
        _arealocationView.delegate = self;
    }
    return _arealocationView;
}

- (NSArray*) regionNames
{
    if (!_regionNames) {
        _regionNames = @[@"景点",@"车站/机场",@"地铁线路",@"商圈",@"行政区",@"医院",@"学校"];
    }
    return _regionNames;
}

- (NSMutableArray<HARegion*>*) allRegions
{
    if (!_allRegions) {
        _allRegions = [[NSMutableArray alloc] initWithCapacity:15];
        [self.regionNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HARegion* region = [[HARegion alloc] initWithName:obj];
            [_allRegions addObject:region];
        }];
    }
    return _allRegions;
}

#pragma mark - *** Init ***

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 初始化选择的cell

    NSInteger distictId = [self.regionNames indexOfObject:@"行政区"];
    NSArray* positions = [HAAppDataHelper positionsFromProvince:self.house.province city:self.house.city house:self.house.houseId];
    HARegion* region = self.allRegions[distictId];
    [region addItems:positions];
    // 显示 menu

    
    [[HARESTfulEngine defaultEngine] fetchPositionInfoWithCityID:self.cityId completion:^(NSArray<HAPosition *> *postions, NSArray<HASubWay *> *subways) {
        [postions enumerateObjectsUsingBlock:^(HAPosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HARegion* region = self.allRegions[obj.typeId - 1];
            [region addSubItem:obj];
        }];
        
        NSInteger index = [self.regionNames indexOfObject:@"地铁线路"];
        [subways enumerateObjectsUsingBlock:^(HASubWay * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HARegion* region = self.allRegions[index];
            if(1 == obj.levelType ){
                [region addSubItem:obj];
            }
            else{
                //obj.parentId;
                HASubWay* subWayLine = [region subItemWithID:obj.parentId];
                [subWayLine addItem:obj];
            }
        }];
        
        
//        NSInteger select[3] = {0,0,0};
//        [self.arealocationView selectRowWithSelectedIndex:select];
        [self.arealocationView showArealocationInView:self.view];
        
    } onError:^(NSError *engineError) {
        
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)arealocationView:(RTArealocationView *)arealocationView countForClassAtLevel:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {
    
    if (level==0) {
        
        return self.allRegions.count;
        //return 2;
    }else if (level==1) {
        return self.allRegions[index].subItems.count;
    }else {
        
        if (-1 == *selectedIndex) {
            return 0;
        }
//        NSArray* obj =self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems;
//        NSInteger xx = obj.count;
//        return self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems.count;
        HARegion* region = self.allRegions[selectedIndex[0]];
        NSArray* items = region.subItems;
        HAJSONModel* item = items[index];
        if([item isKindOfClass:[HASubWay class]])
        {
            HASubWay* subWay = item;
            return subWay.stations.count;
        }
        else{
            
            
            return 0;
        }
    }
}


- (NSString *)arealocationView:(RTArealocationView *)arealocationView titleForClass:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {

    if (level==0) {
        HARegion* region = self.allRegions[index];
        return region.name;
        
    }else if (level==1) {
        
//        HARegion* region = self.allRegions[selectedIndex[0]];
//        NSArray* postions =  region.subItems;
//        HAPosition* postion = postions[index];
        HAPosition* postion = self.allRegions[selectedIndex[0]].subItems[index];
        return postion.name;
        
    }else {
        HAJSONModel* item =  self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]];
        if ([item respondsToSelector:@selector(stations)]) {
            HASubWay* subWay = item;
            NSArray* stations = subWay.stations;
            HASubWay* station = stations[index];
            return station.name;
        }
        else{
            return @"";
        }
    }
    
    
    
    
}


- (void)arealocationView:(RTArealocationView *)arealocationView didSelectIndexsArray:(NSArray<NSNumber *> *)indexs
{
    [indexs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        _selectedIndexs[idx] = [obj integerValue];
    }];
//    self.selectedIndexs = indexs;
//    NSMutableString* text = [[NSMutableString alloc] init];
//    [self.selectedIndexs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [text appendFormat:@" %@",obj];
//    }];
//    NSLog(@"select index%@",text);
}

/**
 *  选取完毕执行的方法
 *
 *  @param arealocationView arealocationView
 *  @param selectedIndex           每一层选取结果的数组
 */
- (void)arealocationView:(RTArealocationView *)arealocationView finishChooseLocationAtIndexs:(NSInteger *)selectedIndex{
    NSLog(@"finishChooseLocationAtIndexs");
}


@end
