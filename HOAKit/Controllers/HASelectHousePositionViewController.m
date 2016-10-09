//
//  HASelectHousePositionViewController.m
//  HOAKit
//
//  Created by zhangguang on 16/8/26.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HASelectHousePositionViewController.h"
#import "HARegion.h"
#import "RTArealocationView.h"
#import "HAActiveWheel.h"
#import "HARESTfulEngine.h"
#import "HAPosition.h"
#import "HAAppDataHelper.h"

@interface HASelectHousePositionViewController ()


@property (nonatomic, strong) RTArealocationView *arealocationView;

@property (nonatomic, strong) NSMutableArray<HARegion*>* allRegions;

@property (nonatomic, strong) NSArray* regionNames;

@end

@implementation HASelectHousePositionViewController

#pragma mark - *** Properties ***
- (RTArealocationView*) arealocationView
{
    if (!_arealocationView) {
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _arealocationView = [[RTArealocationView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        _arealocationView.delegate = self;
        _arealocationView.selectionStyle = RTViewSelectionStyleSingle;
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
- (instancetype) initWithProvinceId:(NSInteger)pid cityId:(NSInteger)cid
{
    if (self = [super init]) {
        self.cityId = cid;
        self.provinceId = pid;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearBtnClicked:)];
    rightItem.tintColor = [UIColor colorWithRed:245 / 255.0f green:2 / 255.0f blue:63 / 255.0f alpha:1];
    self.navigationItem.rightBarButtonItem = rightItem;
    /*
     1:景点
     2:车站/机场
     3:地铁线路  *  打星号的不一样
     4:商圈
     5:行政区 *
     6:医院
     7:学校
     */
    
    NSInteger distictId = [self.regionNames indexOfObject:@"行政区"];
    NSArray* positions = [HAAppDataHelper positionsFromProvince:self.provinceId city:self.cityId house:0];
    HARegion* region = self.allRegions[distictId];
    [region addItems:positions];
    
    

    
    self.title = @"选择位置";
    [HAActiveWheel showHUDAddedTo:self.view].processString = @"正在载入";
    [[HARESTfulEngine defaultEngine] fetchPositionInfoWithCityID:self.cityId completion:^(NSArray<HAPosition *> *postions, NSArray<HASubWay *> *subways) {
        [postions enumerateObjectsUsingBlock:^(HAPosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSInteger offset = obj.typeId >=5 ? 2 : 1;
//            HARegion* region = self.allRegions[obj.typeId - offset];
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
        if (self.positionTypeSelected > 0) {
            //NSInteger offset = self.positionTypeSelected >=5 ? self.positionTypeSelected -2 : self.positionTypeSelected - 1;
            NSInteger offset = self.positionTypeSelected - 1;

            NSInteger select[3] = {offset,-1,-1};
            [self.arealocationView selectRowWithSelectedIndex:select];
        }

        [self.arealocationView showArealocationInView:self.view];
        [HAActiveWheel dismissForView:self.view];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.view warningText:@"载入失败，请检查网络"];
    }];

    
}


- (NSInteger)arealocationView:(RTArealocationView *)arealocationView countForClassAtLevel:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {
    if (level==0) {
        return self.allRegions.count;
    }else if (level==1) {
        if (-1 == selectedIndex[0]) {
            return 0;
        }
        return self.allRegions[selectedIndex[0]].subItems.count;
    }else {
        if (-1 == selectedIndex[1]) {
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
    
    NSString* key = [NSString stringWithFormat:@"%ld-%ld",type,postionId];
    
    NSString* selectKey =  [NSString stringWithFormat:@"%ld-%ld",self.positionTypeSelected,self.positionIdSelected];
    if ([key isEqualToString:selectKey]){
        return YES;
    }
    else{
        return NO;
    }
}


- (void)arealocationView:(RTArealocationView *)arealocationView atLevel:(NSInteger)level finishChooseLocationAtIndexs:(NSInteger *)selectedIndex{

    HAPosition* position = nil;
    if (1 == level) {
        position = self.allRegions[selectedIndex[0]].subItems[selectedIndex[level]];
    }
    if (2 == level) {
        position = self.allRegions[selectedIndex[0]].subItems[selectedIndex[1]].subItems[selectedIndex[level]];
    }
    
    
    self.positionTypeSelected = position.typeId;
    self.positionIdSelected = position.positionId;
    
    if ([self.delegate respondsToSelector:@selector(didSelectHousePosition:)]) {
        [self.delegate didSelectHousePosition:position];
    }
    
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.5];
    //[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - *** Action ***

- (void) clearBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(clearSelectPostions)]) {
        [self.delegate clearSelectPostions];
    }
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:0.5];
    //[self.navigationController popViewControllerAnimated:YES];
}

@end
