//
//  HAHouseAreaSelectViewController.m
//  HOAKit
//
//  Created by ; on 16/8/11.
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


#pragma mark - *** Properties ***

- (RTArealocationView*) arealocationView
{
    if (!_arealocationView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _arealocationView = [[RTArealocationView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
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

- (NSMutableDictionary<NSString*,HAHousePosition*>*) positionDic
{
    if (!_positionDic) {
        _positionDic = [[NSMutableDictionary alloc] initWithCapacity:20];
    }
    return _positionDic;
}

#pragma mark - *** Init ***

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    // 初始化选择的cell

    NSInteger distictId = [self.regionNames indexOfObject:@"行政区"];
    NSArray* positions = [HAAppDataHelper positionsFromProvince:self.house.province city:self.house.city house:self.house.houseId];
    HARegion* region = self.allRegions[distictId];
    [region addItems:positions];
    // 显示 menu

    //加载该房源已选的位置区域信息
    [self.positionArray enumerateObjectsUsingBlock:^(HAHousePosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString* key = [NSString stringWithFormat:@"%d-%d",obj.positionTypeId,obj.positionId];
        [self.positionDic setObject:obj forKey:key];
    }];
    
    //请求房源所在城市的位置区域信息。
    [[HARESTfulEngine defaultEngine] fetchPositionInfoWithCityID:self.house.city completion:^(NSArray<HAPosition *> *postions, NSArray<HASubWay *> *subways) {
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
    }else if (level==1) {
        if (-1 == *selectedIndex) {
            return 0;
        }
        return self.allRegions[selectedIndex[0]].subItems.count;
    }else {
        if (-1 == *selectedIndex) {
            return 0;
        }
        return self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems.count;
    }
}


- (NSString *)arealocationView:(RTArealocationView *)arealocationView titleForClass:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {

    if (level==0) {
        return self.allRegions[index].name;
    }else if (level==1) {
        return self.allRegions[selectedIndex[0]].subItems[index].name;
    }else {
        return  self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems[index].name;
    }
}

- (BOOL)isSelectedLocationInAreaLocationView:(RTArealocationView*)arealocationView atLevel:(NSInteger)level selectedIndex:(NSInteger*)selectedIndex index:(NSInteger)index
{

    if (0 == level) {
        return NO;
    }
//    if(-1 == selectedIndex[level]){
//        return NO;
//    }
    NSInteger type = 0;
    NSInteger postionId = 0;
    if (1 == level) {
        type = self.allRegions[selectedIndex[0]].subItems[index].typeId;
        postionId = self.allRegions[selectedIndex[0]].subItems[index].positionId;
    }
    else if (2 == level) {
        type = self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems[index].typeId;
        postionId = self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems[index].positionId;
    }
    
    NSString* key = [NSString stringWithFormat:@"%d-%d",type,postionId];

    if ([self.positionDic objectForKey:key]){
        return YES;
    }
    else{
        return NO;
    }
}


- (void)arealocationView:(RTArealocationView *)arealocationView atLevel:(NSInteger)level finishChooseLocationAtIndexs:(NSInteger *)selectedIndex{
    NSInteger type = 0;
    NSInteger postionId = 0;
   
    if (1 == level) {
        type = self.allRegions[selectedIndex[0]].subItems[selectedIndex[level]].typeId;
        postionId = self.allRegions[selectedIndex[0]].subItems[selectedIndex[level]].positionId;
    }
    if (2 == level) {
        type = self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems[selectedIndex[level]].typeId;
        postionId = self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems[selectedIndex[level]].positionId;
    }
    
    NSString* key = [NSString stringWithFormat:@"%d-%d",type,postionId];
    if ([self.positionDic objectForKey:key]) {
        [self.positionDic removeObjectForKey:key];
    }
    else{
        HAHousePosition* position = [[HAHousePosition alloc] init];
        position.uniqueId = 0;
        position.houseId = self.house.houseId;
        position.positionId = postionId;
        position.positionTypeId = type;
        [self.positionDic setObject:position forKey:key];
    }
}

#pragma mark - *** Taget action ***
- (IBAction)resetBtnClciked:(id)sender {
    
    [[HARESTfulEngine defaultEngine] modifyHousePositionWithArray:[self.positionDic allValues] completion:^(NSArray<HAHousePosition*>* positions){
        [self.delegate positionsOfHouseDidChange:positions];
        [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSError *engineError) {
        
    }];
    
    
}

@end
