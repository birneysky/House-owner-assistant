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
#import "HAHouseItemCell.h"
#import "HAHouse.h"
#import "HAPublishHouseInfoTableViewController.h"

@interface HAHouseTableController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet HAFloatingButton *addButton;
@property (nonatomic,strong) NSArray* dataSource;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation HAHouseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    [[HARESTfulEngine defaultEngine] fetchHouseItemsWithHouseOwnerID:1 completion:^(NSArray<HAJSONModel *> *objects) {
        self.dataSource = objects;
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        [self.tableView reloadData];
    } onError:^(NSError *engineError) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HAHouseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
    
    HAHouse* item = self.dataSource[indexPath.section];
    
    [cell setCheckStatus:item.checkStatus];
    [cell setPrice:item.price];
    [cell setAddress:item.address];
    [cell setHouseType:item.houseType roomCount:item.roomNumber];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HAHouse* item = self.dataSource[indexPath.section];
    NSLog(@" checkStatus  %d",item.checkStatus);
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"push_publish_house"]) {
        NSIndexPath* indexPath = sender;
        HAHouse* item = self.dataSource[indexPath.section];
        HAPublishHouseInfoTableViewController* vc = segue.destinationViewController;
        vc.houseId = item.houseId;
    }
}


@end
