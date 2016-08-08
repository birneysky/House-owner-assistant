//
//  HAHouseInfoViewController.m
//  HOAKit
//
//  Created by birneysky on 16/8/6.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseInfoViewController.h"
#import "HAEditorNumberCell.h"
#import "HAHouseTypeDataSouceDelegate.h"
#import "HABathroomDataSourceDelegate.h"
#import "HAEditPickerCell.h"


@interface HAHouseInfoViewController ()

@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,strong) HAHouseTypeDataSouceDelegate* houseTypeDataSource;

@property(nonatomic,strong) HABathroomDataSourceDelegate* bathroomDataSource;

@end

@implementation HAHouseInfoViewController

#pragma mark- *** Properties ***
- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"房屋面积",@"户型",@"卫生间数量",@"几位访客", nil];
    }
    return _dataSource;
}

- (HAHouseTypeDataSouceDelegate*)houseTypeDataSource
{
    if (!_houseTypeDataSource) {
        _houseTypeDataSource = [[HAHouseTypeDataSouceDelegate alloc] init];
    }
    return _houseTypeDataSource;
}


- (HABathroomDataSourceDelegate*)bathroomDataSource{
    if (!_bathroomDataSource) {
        _bathroomDataSource = [[HABathroomDataSourceDelegate alloc] init];
    }
    return _bathroomDataSource;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
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
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    UIView* view  = nil;
    NSString* text = self.dataSource[indexPath.row];
    if ([text isEqualToString:@"户型"]) {
        HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.houseTypeDataSource;
        //view = cell.accessoryView;
        cell = pickerCell;
    }
    else if([text isEqualToString:@"卫生间数量"] )
    {
        HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.bathroomDataSource;
        cell = pickerCell;
    }
    else{
        HAEditorNumberCell* editorCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoEditorrCell" forIndexPath:indexPath];
        if([text isEqualToString:@"房屋面积"])
        {
            editorCell.unitName = @"m2";
        }
        else if([text isEqualToString:@"几位访客"]){
            editorCell.unitName = @"人";
        }
        
        cell = editorCell;
    }
    
    // Configure the cell...
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.accessoryView becomeFirstResponder];
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

- (IBAction)saveButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
