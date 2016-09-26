//
//  HouseFacilitiesViewController.m
//  HOAKit
//
//  Created by zhangguang on 16/8/11.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HouseFacilitiesViewController.h"
#import "HAOffOnCell.h"
#import "HAHouseFacility.h"
#import "HARESTfulEngine.h"
#import "HAActiveWheel.h"

@interface HouseFacilitiesViewController ()<HAOffOnCellDelegate>

@property (nonatomic,strong) NSArray* dataSource;

@end

@implementation HouseFacilitiesViewController

#pragma mark - *** Properties ***
- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"热水淋浴",@"沙发",/*@"沐浴露",*/@"电视",@"微波炉",@"电脑",@"空调",@"饮水机",@"冰箱",@"洗衣机",@"wifi",@"有线网络",@"有停车位",@"允许抽烟",@"允许做饭",@"允许带宠物",@"允许聚会", nil];
    }
    
    return _dataSource;
}

- (HAHouseFacility*) factilities
{
    if (!_factilities) {
        _factilities = [[HAHouseFacility alloc] init];
    }
    return _factilities;
}

#pragma mark - **** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请务必配备电视，沙发，淋浴和wifi" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HAOffOnCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HAFacilitiesCell" forIndexPath:indexPath];
    
    NSString* text = self.dataSource[indexPath.row];
    cell.textLabel.text = text;
    
    cell.accessoryViewSelected = ![self.factilities boolValueOfChineseName:text];
    
    cell.delegate = self;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HAOffOnCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(setAccessoryViewSelected:)]) {
        cell.accessoryViewSelected = !cell.accessoryViewSelected;
    }
    
    NSString* text = self.dataSource[indexPath.row];

    [self.factilities setValue:!cell.accessoryViewSelected forChineseName:text];


}

#pragma mark - *** Target Action ***
- (IBAction)okButtonClicked:(id)sender {
    self.factilities.houseId = self.houseId;
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [NETWORKENGINE modifyHouseFacilitiesWithHouseID:self.houseId
                                             params:self.factilities
                                         completion:^(HAHouseFacility* facility) {
                                             [HAActiveWheel dismissForView:self.navigationController.view];
                                            [self.delegate facilityOfHouseDidChange:facility];
                                             [self.navigationController popViewControllerAnimated:YES];
                                         } onError:^(NSError *engineError) {
                                            [HAActiveWheel dismissViewDelay:2 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
        
    }];

}


#pragma mark - *** HAOffOnCellDelegate ***
- (void) offONButtonChangedFromCell:(UITableViewCell *)cell sender:(UIButton *)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSString* text = self.dataSource[indexPath.row];
    HAOffOnCell* offCell = (HAOffOnCell*)cell;
    [self.factilities setValue:!offCell.accessoryViewSelected forChineseName:text];
}

@end
