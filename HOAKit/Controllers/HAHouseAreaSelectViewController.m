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

@interface HAHouseAreaSelectViewController ()<ArealocationViewDelegate>

@property (nonatomic, strong) RTArealocationView *arealocationView;

@property (nonatomic, strong) NSArray *allAreas;

@property (nonatomic, strong) NSMutableArray* allRegions;

@end

@implementation HAHouseAreaSelectViewController

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

- (NSMutableArray*) allRegions
{
    if (!_allRegions) {
        NSArray* names = @[@"景点",@"车站/机场",@"地铁线路",@"商圈",@"行政区",@"医院",@"学校"];
        _allRegions = [[NSMutableArray alloc] initWithCapacity:15];
        [names enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            HARegion* region = [[HARegion alloc] initWithName:obj];
            [_allRegions addObject:region];
        }];
    }
    return _allRegions;
}

- (NSArray*)allAreas
{
    if (!_allAreas) {
        NSArray *cw = @[@"北京南站",@"永定门",@"崇文门",@"天桥"];
        NSArray *hd = @[@"五道口",@"航天桥",@"北大/清华/学院路",@"五棵松体育馆",@"上地工业园区",@"公主坟",@"大钟寺/交通大学",@"中关村/人民大学",@"北京展览馆/首都体育馆"];
        NSArray *myx = @[@"密云城区/密云水库",@"古北水镇"];
        
        NSDictionary *xzq1 = @{@"district":@"崇文区",@"commercial":cw};
        NSDictionary *xzq2 = @{@"district":@"海淀区",@"commercial":hd};
        NSDictionary *xzq3 = @{@"district":@"密云县",@"commercial":myx};
        _allAreas = @[xzq1,xzq2,xzq3];
    }
    return _allAreas;
}

#pragma mark - *** Init ***

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 初始化选择的cell
    //NSInteger select[3] = {0,1,2};
    //[self.arealocationView selectRowWithSelectedIndex:select];
    // 显示 menu
    [self.arealocationView showArealocationInView:self.view];
    
    [[HARESTfulEngine defaultEngine] fetchPositionInfoWithCityID:self.cityId completion:^(NSArray<HAPosition *> *postions, NSArray<HASubWay *> *subways) {
        
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
        
        return 2;
        
    }else if (level==1) {
        
        return self.allAreas.count;
        
    }else {
        
        NSDictionary *dict = self.allAreas[index];
        
        NSArray *comArr = dict[@"commercial"];
        
        return comArr.count;
        
    }
}



/**
 *  cell的标题
 *
 *  @param arealocationView arealocationView
 *  @param level            层级
 *  @param index            cell索引
 *  @param selectedIndex    所有选中的索引数组
 *
 *  @return cell的标题
 */
- (NSString *)arealocationView:(RTArealocationView *)arealocationView titleForClass:(NSInteger)level index:(NSInteger)index selectedIndex:(NSInteger *)selectedIndex {
    
    if (level==0) {
        
        return @"全城";
        
    }else if (level==1) {
        
        NSDictionary *dict = self.allAreas[index];
        
        return dict[@"district"];
        
    }else {
        
        NSDictionary *dict = self.allAreas[selectedIndex[1]];
        
        NSArray *comArr = dict[@"commercial"];
        
        return comArr[index];
        
    }
    
}


/**
 *  选取完毕执行的方法
 *
 *  @param arealocationView arealocationView
 *  @param selectedIndex           每一层选取结果的数组
 */
- (void)arealocationView:(RTArealocationView *)arealocationView finishChooseLocationAtIndexs:(NSInteger *)selectedIndex{
    
    for (int i=0; i<3; i++) {
        
        NSLog(@"%ld",selectedIndex[i]);
    }
}


@end
