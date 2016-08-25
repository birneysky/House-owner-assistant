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
#import "HAPublishHouseInfoTableViewController.h"
#import "HAActiveWheel.h"

@interface HAHouseTypeTableViewController ()<HAOffOnCellDelegate>

@property (nonatomic,strong) NSArray* dataSource;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) NSArray* rentTypeDataSource;
@property (weak, nonatomic) IBOutlet UIButton *wholeBtn;
@property (weak, nonatomic) IBOutlet UIButton *singleBtn;

@property (nonatomic,assign) BOOL isNewHouse;

@property (nonatomic,copy) HAHouse* houseCopy;

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
    if (self.house.houseId > 0) {
        self.selectedIndex = self.house.houseType - 1;
        if (self.house.rentType == 1) {
            self.wholeBtn.selected = YES;
        }
        else if (self.house.rentType == 2){
            self.wholeBtn.selected = YES;
        }
        self.isNewHouse = NO;
        self.houseCopy = self.house;
    }
    else{
        self.isNewHouse = YES;
        self.house.rentType = 1;
        self.wholeBtn.selected = YES;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
    HAOffOnCell* offOnCell = (HAOffOnCell*)cell;
    offOnCell.delegate = self;
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
    NSArray* arrayIndexPathes = [tableView indexPathsForVisibleRows];
   [tableView reloadRowsAtIndexPaths:arrayIndexPathes withRowAnimation:UITableViewRowAnimationFade];
    if (self.isNewHouse) {
        self.house.houseType = self.selectedIndex + 1;
    }
    else{
        self.houseCopy.houseType = self.selectedIndex + 1;
    }
    
    [self checkHouseInfo];
   
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
#pragma mark - *** Helper ***
- (void) checkHouseInfo
{
    if (self.isNewHouse) {
        if (self.house.rentType > 0 && self.house.houseType > 0) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
    else{
        BOOL change = ![self.house isEqualToHouse:self.houseCopy];
        if (change) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        else{
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"push_publish_house"]) {
        HAPublishHouseInfoTableViewController* vc = segue.destinationViewController;
        vc.houseId = self.house.houseId;
    }
}

#pragma mark - *** Target Action ***
- (IBAction)wholeBtnClicked:(UIButton*)sender {
    if (sender.selected) {
        return;
    }
    if(self.isNewHouse){
        self.house.rentType = 1;
    }
    else{
        self.houseCopy.rentType = 1;
    }
    
    
    sender.selected = !sender.selected;
    if (sender.selected && self.singleBtn.selected) {
        self.singleBtn.selected = NO;
    }
    
    [self checkHouseInfo];
}

- (IBAction)signleBtnClicked:(UIButton*)sender {
    if (sender.selected) {
        return;
    }
    if(self.isNewHouse){
        self.house.rentType = 2;
    }
    else{
        self.houseCopy.rentType = 2;
    }
    
    
    sender.selected = !sender.selected;
    if (sender.selected && self.wholeBtn.selected) {
        self.wholeBtn.selected = NO;
    }
    
    [self checkHouseInfo];
}

- (IBAction)okBtnClicked:(id)sender {
    self.house.landlordId = 1;
    //self.house.houseNumber = @"9000-1234";
    if (self.isNewHouse) {
        [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在新建房源";
        [[HARESTfulEngine defaultEngine] createNewHouseWithModel:self.house completion:^(HAHouse *object) {
            self.house = object;
             [HAActiveWheel dismissForView:self.navigationController.view];
            [self performSegueWithIdentifier:@"push_publish_house" sender:sender];
        } onError:^(NSError *engineError) {
            [HAActiveWheel dismissViewDelay:2 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
        }];
    }else{
        BOOL change = ![self.house isEqualToHouse:self.houseCopy];
        if (change) {
            [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
            [NETWORKENGINE modifyHouseGeneralInfoWithID:self.houseCopy.houseId
                                                 params:self.houseCopy
                                             completion:^(HAHouse* hosue){
                                                 [self.delegate houseDidChangned:hosue];
                                                 [HAActiveWheel dismissForView:self.navigationController.view];
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }  onError:^(NSError *engineError) {
                                                 [HAActiveWheel dismissViewDelay:2 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
                
            }];
        }
        else{
          [self.navigationController popViewControllerAnimated:YES];
        }
        
    }

    
 
}


#pragma mark - *** HAOffOnCellDelegate ***
-(void)offONButtonChangedFromCell:(UITableViewCell*)cell sender:(UIButton*)sender;
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    self.selectedIndex = indexPath.row;
    
    if (self.isNewHouse) {
        self.house.houseType = self.selectedIndex + 1;
    }
    else{
        self.houseCopy.houseType = self.selectedIndex + 1;
    }
    
    NSArray* arrayIndexPathes = [self.tableView indexPathsForVisibleRows];
    [self.tableView reloadRowsAtIndexPaths:arrayIndexPathes withRowAnimation:UITableViewRowAnimationFade];
    
     [self checkHouseInfo];
}


@end
