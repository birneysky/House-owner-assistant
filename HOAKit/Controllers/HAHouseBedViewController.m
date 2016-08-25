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

//@property(nonatomic,strong) NSMutableArray* dataSource;

@end

@implementation HAHouseBedViewController
#pragma mark - *** Properties ***
//- (NSMutableArray*)dataSource
//{
//    if (!_dataSource) {
//        _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
//    }
//    return _dataSource;
//}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //HABed* bed  = self.dataSource[indexPath.row];
    HAHouseBed* bed = self.beds[indexPath.row];
    // Configure the cell...
//    cell.textLabel.text = bed.type;
//    
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f x %.1f",bed.length,bed.width];
    cell.typeText = [HAAppDataHelper bedName:bed.bedTypeId];
    cell.sizeText = [NSString stringWithFormat:@"%.1f x %.1f",bed.length,bed.width];
    cell.delegate = self;
    return cell;
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     HAEditHouseBenViewController* vc = segue.destinationViewController;
    vc.houseId = self.houseId;
    if ([segue.identifier isEqualToString:@"house_add_bed"]) {
    
        vc.delegate = self;
        
    }
    else if ([segue.identifier isEqualToString:@"house_edit_bed"])
    {
        //UITableViewCell* cell = sender;
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        vc.bed = self.beds[indexPath.row];
        vc.delegate = self;
        
    }
}


#pragma mark - *** ***


@end
