//
//  HAHouseBedViewController.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseBedViewController.h"
#import "HAEditHouseBenViewController.h"
#import "HABedInfoCell.h"
#import "HAHouseBed.h"
#import "HAAppDataHelper.h"
#import "HARESTfulEngine.h"
#import "HAActiveWheel.h"

@interface HAHouseBedViewController ()<HAEditHouseBenViewControllerDelegate,HABedInfoCellDelegate>


@end

@implementation HAHouseBedViewController

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"添加床铺";
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.beds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HABedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HABedInfoCell" forIndexPath:indexPath];
    
    HAHouseBed* bed = self.beds[indexPath.row];

    cell.typeText = [HAAppDataHelper bedName:bed.bedTypeId];
    cell.sizeText = [NSString stringWithFormat:@"%.1f x %.1f",bed.length,bed.width];
    cell.delegate = self;
    return cell;
}

#pragma mark - *** Target Action ***
- (IBAction)saveBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - *** HABedInfoCellDelegate ***
- (void)deleteButtonClickedFromCell:(UITableViewCell *)cell sender:(UIButton *)sender
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    HAHouseBed* targetBed = self.beds[indexPath.row];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在删除";
    [[HARESTfulEngine defaultEngine] removeHouseBedWithID:targetBed.bedId completion:^{
        [self.beds removeObjectAtIndex:indexPath.row];
        [self.delegate bedsOfHouseDidChange:[self.beds copy]];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [HAActiveWheel dismissForView:self.navigationController.view];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:2 forView:self.navigationController.view warningText:@"删除失败，请检查网络"];
    }];

}

#pragma mark - *** HAEditHouseBenViewControllerDelegate ***
- (void)houseBedInfoDidEndEditing:(HAHouseBed *)bed
{
    __block BOOL exist = NO;
    [self.beds enumerateObjectsUsingBlock:^(HAHouseBed * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.bedId == bed.bedId) {
            exist = YES;
            *stop = YES;
        }
    }];
    if (!exist) {
      [self.beds addObject:bed];
    }
    [self.delegate bedsOfHouseDidChange:[self.beds copy]];
    [self.tableView reloadData];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     HAEditHouseBenViewController* vc = segue.destinationViewController;
    vc.houseId = self.houseId;
    if ([segue.identifier isEqualToString:@"house_add_bed"]) {
    
        vc.delegate = self;
        
    }
    else if ([segue.identifier isEqualToString:@"house_edit_bed"])
    {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        vc.bed = self.beds[indexPath.row];
        vc.delegate = self;
        
    }
}

@end
