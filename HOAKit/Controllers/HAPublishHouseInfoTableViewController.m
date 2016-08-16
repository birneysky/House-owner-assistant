//
//  HAPublishHouseInfoTableViewController.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAPublishHouseInfoTableViewController.h"
#import "HARESTfulEngine.h"
#import "HAHouseFullInfo.h"
#import "HAHouseIntroduceViewController.h"
#import "HouseFacilitiesViewController.h"
#import "HAHouseAreaSelectViewController.h"
@interface HAPublishHouseInfoTableViewController ()

@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,strong) HAHouseFullInfo* houseFullInfo;

@end

@implementation HAPublishHouseInfoTableViewController

#pragma mark - ***Properties ***

- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"房屋标题与介绍",@"价格与交易规则",@"房源信息",@"床铺信息",@"位置区域",@"设施列表",@"出租方式与房源类型",@"地址", nil];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[HARESTfulEngine defaultEngine] fetchHouseInfoWithHouseID:self.houseId completion:^(HAHouseFullInfo *info) {
        self.houseFullInfo = info;
        NSLog(@"fetch house full info finished");
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseSummaryCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}


#pragma mark - *** TableView Delegate ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* text = self.dataSource[indexPath.row];
    /**@"房屋标题与介绍",@"价格与交易规则",@"房源信息",@"床铺信息",@"位置区域",@"设施列表",@"出租方式与房源类型",@"地址"*/
    if ([text isEqualToString:@"房屋标题与介绍"]) {
        [self performSegueWithIdentifier:@"push_house_introduce" sender:nil];
    }
    else if ([text isEqualToString:@"价格与交易规则"]){
        [self performSegueWithIdentifier:@"push_price_trading_rules" sender:nil];
    }
    else if ([text isEqualToString:@"房源信息"]){
        [self performSegueWithIdentifier:@"push_house_info" sender:nil];
    }
    else if ([text isEqualToString:@"床铺信息"]){
        [self performSegueWithIdentifier:@"push_house_bed_info" sender:nil];
    }
    else if ([text isEqualToString:@"出租方式与房源类型"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([text isEqualToString:@"地址"]){
        NSArray* vcs = self.navigationController.viewControllers;
        [self.navigationController popToViewController:vcs[vcs.count-3] animated:YES];
    }
    else if([text isEqualToString:@"设施列表"]){
        [self performSegueWithIdentifier:@"push_house_facilities" sender:nil];
    }
    else if([text isEqualToString:@"位置区域"]){
        [self performSegueWithIdentifier:@"push_house_area" sender:nil];
    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"push_house_introduce"]) {
        HAHouseIntroduceViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_facilities"]) {
        HouseFacilitiesViewController* vc = segue.destinationViewController;
        vc.houseId = self.houseId;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_area"]) {
        HAHouseAreaSelectViewController* vc = segue.destinationViewController;
        vc.cityId = self.houseFullInfo.house.city;
    }
}


@end
