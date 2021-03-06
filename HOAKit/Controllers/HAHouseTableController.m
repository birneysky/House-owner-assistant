//
//  HAHouseInfoTableController.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/28.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAHouseTableController.h"
#import "HARESTfulEngine.h"
#import "HAHouseInfoBaseCell.h"
#import "HAHouse.h"
#import "HAPublishHouseInfoTableViewController.h"
#import "HAActiveWheel.h"
#import "HAHouseInfoItemCell.h"
#import "HOAKit.h"
#import "HAPriceAndTrandRulesTableController.h"
#import "HAAppDataHelper.h"

@interface HAHouseTableController ()<UITableViewDelegate,UITableViewDataSource,HAHouseInfoItemCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (nonatomic,strong) NSArray<HAHouse*>* dataSource;

@property (nonatomic,strong) NSMutableDictionary<NSString*,NSNumber*>* downloadingSets;

@end

@implementation HAHouseTableController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableDictionary<NSString*,NSNumber*>*) downloadingSets
{
    if (!_downloadingSets) {
        _downloadingSets = [[NSMutableDictionary alloc] init];
    }
    return _downloadingSets;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self fethHouseItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHouseInfo:) name:HAHouseModifyInformationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewHouse:) name:HANewHouseNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"房源";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.title = @"";
}

#pragma mark - *** Helper ***
- (void)fethHouseItem
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.coverView.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view addSubview:self.coverView];
    NSString* stogagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseFirstImages"];
    NSString* netPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在载入";
    [[HARESTfulEngine defaultEngine] fetchHouseItemsWithHouseOwnerID:[HOAKit defaultInstance].userId completion:^(NSArray<HAHouse*> *objects) {
        [self.coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0];
        self.dataSource = objects;
        
        [self.dataSource enumerateObjectsUsingBlock:^(HAHouse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* firstImagePath = [stogagePath stringByAppendingPathComponent:[obj.firstImage lastPathComponent]];
            NSString* firstImageNetPath = [netPath stringByAppendingPathComponent:[obj.firstImage lastPathComponent]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:firstImagePath]) {
                obj.firstImageLocalPath = firstImagePath;
            }else if([[NSFileManager defaultManager] fileExistsAtPath:firstImageNetPath]){
                obj.firstImageLocalPath = firstImageNetPath;
            }
        }];
        
        [HAActiveWheel dismissForView:self.navigationController.view];
        [self.tableView reloadData];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"载入失败，请检查网络"];
        self.refreshBtn.hidden = NO;
    }];
}


- (void)downloadImageFromURL:(NSString*)url atIndex:(NSInteger)index
{
    if ([self.downloadingSets objectForKey:url]) {
        return;
    }
    
    NSString* stogagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseFirstImages"];
    
    [self.downloadingSets setObject:@(index) forKey:url];
    [NETWORKENGINE downloadHouseImageWithURL:url storagePath:stogagePath
      completion:^(NSString *certificate, NSString *fileName) {
          NSInteger idx = [[self.downloadingSets objectForKey:url] integerValue];
          self.dataSource[idx].firstImageLocalPath = [stogagePath stringByAppendingPathComponent:[url lastPathComponent]];
          [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:idx]] withRowAnimation:UITableViewRowAnimationFade];
          [self.downloadingSets removeObjectForKey:url];
    } progress:^(NSString *certificate, float progress) {
        
    } onError:^(NSString *certificate, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:[stogagePath stringByAppendingString:[url lastPathComponent]] error:nil];
        [self.downloadingSets removeObjectForKey:url];
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
        return 170;
    }
    else{
        return 124;
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

    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HAHouse* item = self.dataSource[indexPath.section];
    NSString* checkText = [HAAppDataHelper TextFromCheckStatus:item.checkStatus operationStatus:item.operationStatus];
    HAHouseInfoBaseCell* itemcell = (HAHouseInfoBaseCell*)cell;
    [itemcell setCheckText:checkText];
    [itemcell setPrice:item.price];
    [itemcell setAddress:item.title];
    [itemcell setHouseType:item.houseType roomCount:item.roomNumber];
    if (item.firstImageLocalPath.length > 0) {
        [itemcell setHeadImage:[UIImage imageWithContentsOfFile:item.firstImageLocalPath]];
    }
    else if(item.firstImage.length > 0){
        [self downloadImageFromURL:item.firstImage atIndex:indexPath.section];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HAHouse* item = self.dataSource[indexPath.section];
    switch (item.checkStatus) {
        case 1://待审核
            // show toast;
            [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"当前房源正在审核"];
            break;
        case 2://通过
            [self performSegueWithIdentifier:@"push_publish_house" sender:[indexPath copy]];
            self.title=@"";
            break;
        case 3://已拒绝
            // show toast;
            break;
        case 4://补充材料
            [self performSegueWithIdentifier:@"push_publish_house" sender:[indexPath copy]];
            self.title = @"";
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
        NSIndexPath* indexPath = sender;
        HAHouse* item = self.dataSource[indexPath.section];
        HAPriceAndTrandRulesTableController* vc = segue.destinationViewController ;
        vc.changePrice = YES;
        vc.house = item;
    }
}

#pragma mark - *** HAHouseInfoItemCellDelegate ***
- (void)changePriceButtonClickedOfCell:(UITableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
   // HAHouse* item = self.dataSource[indexPath.row];
    [self performSegueWithIdentifier:@"push_price_trand_rule" sender:indexPath];
}

- (void)reviewCommentsButtonClickedOfCell:(UITableViewCell*)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    HAHouse* item = self.dataSource[indexPath.row];
    if( [[HOAKit defaultInstance].delegate respondsToSelector:@selector(reviewHouseCommentsOfHouseId:)]){
        [[HOAKit defaultInstance].delegate reviewHouseCommentsOfHouseId:item.houseId];
    }
}

#pragma mark - *** Target Action ***
- (IBAction)refreshBtnClicked:(id)sender {
    [self fethHouseItem];
}


#pragma mark - *** HAHouseModifyInformationNotification ***
- (void)updateHouseInfo:(NSNotification*)notification
{
    HAHouse* house = notification.object;
    __weak HAHouseTableController* weakSelf = self;
    [self.dataSource enumerateObjectsUsingBlock:^(HAHouse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.houseId == house.houseId) {
            obj.address     = house.address;
            obj.houseType   = house.houseType;
            obj.price       =  house.price;
            obj.checkStatus = house.checkStatus;
            obj.roomNumber = house.roomNumber;
            obj.title = house.title;
            if (![obj.firstImage isEqualToString:house.firstImage]) {
                obj.firstImage = house.firstImage;
                obj.firstImageLocalPath = house.firstImageLocalPath;
            }
            
            *stop = YES;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:idx]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
}

- (void)addNewHouse:(NSNotification*)notification
{
    if (notification.object) {
        NSMutableArray* array = [[NSMutableArray alloc] initWithArray:self.dataSource];
        [array addObject:notification.object];
        self.dataSource = [array copy];
        [self.tableView reloadData];
    }
}


@end
