//
//  HAHouseInfoTableController.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/28.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAHouseTableController.h"
#import "HAFloatingButton.h"
#import "HARESTfulEngine.h"
#import "HAHouseInfoBaseCell.h"
#import "HAHouse.h"
#import "HAPublishHouseInfoTableViewController.h"
#import "HAActiveWheel.h"
#import "HAHouseInfoItemCell.h"

@interface HAHouseTableController ()<UITableViewDelegate,UITableViewDataSource,HAHouseInfoItemCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HAFloatingButton *addButton;
@property (nonatomic,strong) NSArray* dataSource;
@end

@implementation HAHouseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在载入";
    [[HARESTfulEngine defaultEngine] fetchHouseItemsWithHouseOwnerID:1 completion:^(NSArray<HAHouse*> *objects) {
        self.dataSource = objects;
        [HAActiveWheel dismissForView:self.navigationController.view];
        [self.tableView reloadData];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"载入失败，请检查网络"];
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HAHouse* item = self.dataSource[indexPath.section];
    if (2 == item.checkStatus) {
        return 180;
    }
    else{
        return 125;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HAHouseInfoBaseCell *cell = nil;
    
    HAHouse* item = self.dataSource[indexPath.section];
    
    if (2 == item.checkStatus) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        HAHouseInfoItemCell* itemCell = (HAHouseInfoItemCell*)cell;
        itemCell.delegate = self;
    }
    else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoBaseCell" forIndexPath:indexPath];
    }
    
    [cell setCheckStatus:item.checkStatus];
    [cell setPrice:item.price];
    [cell setAddress:item.address];
    [cell setHouseType:item.houseType roomCount:item.roomNumber];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HAHouse* item = self.dataSource[indexPath.section];
    switch (item.checkStatus) {
        case 1://待审核
            // show toast;
            break;
        case 2://通过
            [self performSegueWithIdentifier:@"push_publish_house" sender:[indexPath copy]];
            break;
        case 3://已拒绝
            // show toast;
            break;
        case 4://补充材料
            [self performSegueWithIdentifier:@"push_publish_house" sender:[indexPath copy]];
            break;
    }
}

//#pragma mark - *** ***
//- (void)fetchHouseInfoWithHouseId:(NSInteger)houseId{
//    
//    [[HARESTfulEngine defaultEngine] fetchHouseInfoWithHouseID:houseId completion:^(HAHouseFullInfo *info) {
//        self.houseFullInfo = info;
//        [self.tableView reloadData];
//        NSLog(@"fetch house full info finished");
//    } onError:^(NSError *engineError) {
//        
//    }];
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"push_publish_house"]) {
        NSIndexPath* indexPath = sender;
        HAHouse* item = self.dataSource[indexPath.section];
        HAPublishHouseInfoTableViewController* vc = segue.destinationViewController;
        vc.houseId = item.houseId;
    }
    
    if ([segue.identifier isEqualToString:@"push_price_trand_rule"]) {
        
    }
}

#pragma mark - *** HAHouseInfoItemCellDelegate ***
- (void)changePriceButtonClickedOfCell:(UITableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
   // HAHouse* item = self.dataSource[indexPath.row];
    [self performSegueWithIdentifier:@"push_price_trand_rule" sender:indexPath];
}

@end
