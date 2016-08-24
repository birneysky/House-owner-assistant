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
#import "HAHouseBedViewController.h"
#import "HAHouseInfoViewController.h"
#import "HAPriceAndTrandRulesTableController.h"
#import "HAAddHousePhotoViewController.h"
#import "HAHouseLocationViewController.h"
#import "HAHouseTypeTableViewController.h"

@interface HAPublishHouseInfoTableViewController ()<HADataExchangeDelegate>

@property(nonatomic,strong) NSArray* dataSource;



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
        [self.tableView reloadData];
        NSLog(@"fetch house full info finished");
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
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
        NSArray<UIViewController*>* vcs = self.navigationController.viewControllers;
        __block UIViewController* targetVC = nil;
        [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[HAHouseTypeTableViewController class]])
            {
                targetVC = obj;
            }
        }];
        if (targetVC) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"push_back_house_type_select" sender:nil];
        }
        
    }
    else if ([text isEqualToString:@"地址"]){
        NSArray<UIViewController*>* vcs = self.navigationController.viewControllers;
        __block UIViewController* targetVC = nil;
        [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[HAHouseLocationViewController class]])
            {
                targetVC = obj;
            }
        }];
        
        if (targetVC) {
            [self.navigationController popToViewController:targetVC animated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"push_location" sender:nil];
        }
        
    }
    else if([text isEqualToString:@"设施列表"]){
        [self performSegueWithIdentifier:@"push_house_facilities" sender:nil];
    }
    else if([text isEqualToString:@"位置区域"]){
        [self performSegueWithIdentifier:@"push_house_area" sender:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    UIColor* color = [UIColor colorWithRed:219 / 255.0f green:78 / 255.0f blue:32 / 255.0f alpha:1];
    if ([text isEqualToString:@"房屋标题与介绍"] && self.houseFullInfo.houseDescriptionComplete) {
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"价格与交易规则"] && self.houseFullInfo.priceInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"房源信息"] && self.houseFullInfo.houseGeneralInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"床铺信息"] && self.houseFullInfo.bedInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"出租方式与房源类型"] && self.houseFullInfo.rentTypeComplete){
        cell.textLabel.textColor = color;
        
    }
    else if ([text isEqualToString:@"地址"] && self.houseFullInfo.addressInfoComplete){
        cell.textLabel.textColor = color;
        
    }
    else if([text isEqualToString:@"设施列表"] && self.houseFullInfo.facilityInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if([text isEqualToString:@"位置区域"] && self.houseFullInfo.regionInfoComplete){
        cell.textLabel.textColor = color;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"push_house_introduce"]) {
        HAHouseIntroduceViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_facilities"]) {
        HouseFacilitiesViewController* vc = segue.destinationViewController;
        vc.houseId = self.houseId;
        vc.factilities = self.houseFullInfo.facility;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_area"]) {
        HAHouseAreaSelectViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.positionArray = self.houseFullInfo.positions;
        vc.delegate = self;
    }

    if([segue.identifier isEqualToString:@"push_house_bed_info"]){
        HAHouseBedViewController* vc = segue.destinationViewController;
        NSMutableArray* bes = [[NSMutableArray alloc] initWithArray:self.houseFullInfo.beds];
        vc.beds = bes;
        vc.houseId = self.houseFullInfo.house.houseId;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_info"]) {
        HAHouseInfoViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_price_trading_rules"]) {
        HAPriceAndTrandRulesTableController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_add_photoes"]) {
        HAAddHousePhotoViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.photoes = self.houseFullInfo.images;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_location"]) {
        HAHouseLocationViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_back_house_type_select"]) {
        HAHouseTypeTableViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }

}


#pragma mark - ***HADataExchangeDelegate  ***


- (void) houseDidChangned:(HAHouse*) house
{
    self.houseFullInfo.house = house;
    [self.tableView reloadData];
}

- (void) bedsOfHouseDidChange:(NSArray<HAHouseBed*>*) beds
{
    self.houseFullInfo.beds =beds;
    [self.tableView reloadData];
}

- (void) positionsOfHouseDidChange:(NSArray<HAHousePosition*>*) positions
{
    self.houseFullInfo.positions = positions;
    [self.tableView reloadData];
}

- (void) facilityOfHouseDidChange:(HAHouseFacility*) facility
{
    self.houseFullInfo.facility = facility;
    [self.tableView reloadData];
}

- (void) imagesOfHouseDidChange:(NSArray<HAHouseImage*>*) images
{
    self.houseFullInfo.images = images;
}


@end
