//
//  HAEditHouseBenViewController.m
//  HOAKit
//
//  Created by birneysky on 16/8/7.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAEditHouseBenViewController.h"
#import "HAEditorNumberCell.h"
#import "HAEditPickerCell.h"
#import "HABedTypeDataSourceDelegate.h"

@interface HAEditHouseBenViewController ()

@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,strong) HABedTypeDataSourceDelegate* bedTypeDataSouce;

@end

@implementation HAEditHouseBenViewController

#pragma mark - *** Properties ***
- (NSArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"床型",@"长度",@"宽度",@"数量", nil];
    }
    return _dataSource;
}


- (HABedTypeDataSourceDelegate*) bedTypeDataSouce
{
    if (!_bedTypeDataSouce) {
        _bedTypeDataSouce = [[HABedTypeDataSourceDelegate alloc] init];
    }
    return _bedTypeDataSouce;
}

#pragma mark - *** Init **

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
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    NSString* text = self.dataSource[indexPath.row];
    if ([text isEqualToString:@"床型"]) {
       HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HABedTypeCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.bedTypeDataSouce;
        cell = pickerCell;
    }
    else {
        HAEditorNumberCell* editCell = [tableView dequeueReusableCellWithIdentifier:@"HABedSizeCell" forIndexPath:indexPath];
        editCell.unitName = @"m";
        cell = editCell;
    }
    
    
    // Configure the cell...
    cell.textLabel.text = text;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - ***Target Action  ***
- (IBAction)saveBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
