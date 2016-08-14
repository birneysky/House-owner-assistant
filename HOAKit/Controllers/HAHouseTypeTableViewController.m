//
//  HAHouseTypeTableViewController.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAHouseTypeTableViewController.h"
#import "HAOffOnCell.h"
#import "HAHouse.h"
#import "HARESTfulEngine.h"

@interface HAHouseTypeTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic,strong) NSArray* dataSource;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) NSArray* rentTypeDataSource;
@end

@implementation HAHouseTypeTableViewController

#pragma mark - *** Properties ***
- (NSArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"民居",@"公寓",@"独栋别墅",@"客栈",@"阁楼",@"四合院",@"海边小屋",@"林间小屋",@"豪宅",@"城堡",@"树屋",@"船舱",@"房车",@"冰屋", nil];
    }
    return _dataSource;
}

- (NSArray*) rentTypeDataSource
{
    if (!_rentTypeDataSource) {
        _rentTypeDataSource = [[NSArray alloc] initWithObjects:@"整套出租",@"单间出租", nil];
    }
    return _rentTypeDataSource;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = -1;
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
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseTypeCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - *** UITableViewDelegate ***
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HAOffOnCell* offOnCell = cell;
    cell.textLabel.text = self.dataSource[indexPath.row];
    if (self.selectedIndex == indexPath.row) {
        offOnCell.accessoryViewSelected = YES;
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        //cell.accessoryType = UITableViewCellAccessoryNone;
        offOnCell.accessoryViewSelected = NO;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
    self.house.houseType = self.selectedIndex + 1;
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
- (IBAction)wholeBtnClicked:(UIButton*)sender {
    self.house.rentType = 1;
    sender.selected = !sender.selected;
}

- (IBAction)signleBtnClicked:(UIButton*)sender {
    self.house.rentType = 2;
    sender.selected = !sender.selected;
}

- (IBAction)okBtnClicked:(id)sender {
    self.house.landlordId = 1;
    self.house.houseNumber = @"9000-1234";
//    [[HARESTfulEngine defaultEngine] createNewHouseWithHAJSONModel:self.house onSucceeded:^(HAJSONModel *aModelBaseObject) {
//        NSLog(@"aModelBaseObject %@",[aModelBaseObject toJsonString]);
//    } onError:^(NSError *engineError) {
//        
//    }];
    
    [self performSegueWithIdentifier:@"push_publish_house" sender:sender];
}
@end
