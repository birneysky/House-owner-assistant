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
        _dataSource = [[NSArray alloc] initWithObjects:@"热水淋浴",@"沙发",@"沐浴露",@"电视",@"微波炉",@"电脑",@"空调",@"饮水机",@"冰箱",@"洗衣机",@"wifi",@"有线网络",@"有停车位",@"允许抽烟",@"允许做饭",@"允许带宠物",@"允许聚会", nil];
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
    // Configure the cell...
    cell.textLabel.text = text;
    
    cell.accessoryViewSelected = [self.factilities boolValueOfChineseName:text];
    
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

    [self.factilities setValue:cell.accessoryViewSelected forChineseName:text];


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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
    [self.factilities setValue:offCell.accessoryViewSelected forChineseName:text];
}

@end
