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
#import "HAHouse.h"
#import "HARESTfulEngine.h"

@interface HAHouseInfoViewController ()<HAHouseTypeSelectDetailResult,HAHouseBathrommSelectDetailResult,HAEditorNumberCellDelegate>

@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,strong) HAHouseTypeDataSouceDelegate* houseTypeDataSource;

@property(nonatomic,strong) HABathroomDataSourceDelegate* bathroomDataSource;

@property (nonatomic,copy) HAHouse* houseNew;

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
        _houseTypeDataSource.detailResultDelegate = self;
    }
    return _houseTypeDataSource;
}


- (HABathroomDataSourceDelegate*)bathroomDataSource{
    if (!_bathroomDataSource) {
        _bathroomDataSource = [[HABathroomDataSourceDelegate alloc] init];
        _bathroomDataSource.detailResultDelegate = self;
    }
    return _bathroomDataSource;
}

//- (HAHouse*) houseNew
//{
//    if (!_houseNew) {
//        _houseNew = [[HAHouse alloc] init];
//    }
//    return _houseNew;
//}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    self.houseNew = self.house;
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
        [pickerCell.textField setDefultText:@"1室0厅0厨0阳台"];
        //view = cell.accessoryView;
        if (self.house) {
            pickerCell.textField.text = [NSString stringWithFormat:@"%d室%d厅%d厨%d阳台",self.house.roomNumber,self.house.hallNumber,self.house.kitchenNumber,self.house.balconyNumber];
        }
       
        cell = pickerCell;
    }
    else if([text isEqualToString:@"卫生间数量"] )
    {
        HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.bathroomDataSource;
        [pickerCell.textField setDefultText:@"公共0独立0"];
        
        if (self.house) {
            pickerCell.textField.text = [NSString stringWithFormat:@"公共%d独立%d",self.house.publicToiletNumber,self.house.toiletNumber];
        }
        cell = pickerCell;
    }
    else{
        HAEditorNumberCell* editorCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoEditorrCell" forIndexPath:indexPath];
        if([text isEqualToString:@"房屋面积"])
        {
            editorCell.unitName = @"平";
            if (self.house) {
                editorCell.textField.text = self.house.area;
            }
        }
        else if([text isEqualToString:@"几位访客"]){
            editorCell.unitName = @"人";
            if (self.house) {
                editorCell.textField.text = [NSString stringWithFormat:@"%d",self.house.toliveinNumber];
            }
        }
        
        editorCell.delegate = self;
        
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
    
    [self.view endEditing:YES];
    
    [[HARESTfulEngine defaultEngine] modifyHouseGeneralInfoWithID:self.house.houseId params:self.houseNew completion:^{
        [self.navigationController popViewControllerAnimated:YES]; 
    } onError:^(NSError *engineError) {
        
    }];

}



#pragma mark - *** HAHouseTypeSelectDetailResult ***
- (void)didSelectRoom:(NSInteger)rNum hall:(NSInteger)hallNum cookroom:(NSInteger)cookNum balcony:(NSInteger)bNum
{
    self.houseNew.roomNumber = rNum;
    self.houseNew.hallNumber = hallNum;
    self.houseNew.kitchenNumber = cookNum;
    self.houseNew.balconyNumber = bNum;
}

- (void) didSelectPublicBathroom:(NSInteger) pubNum privateBathroom:(NSInteger)privateNum
{
    self.houseNew.publicToiletNumber = pubNum;
    self.houseNew.toiletNumber = privateNum;
}


- (void) textFieldDidEndEditing:(UITextField*)textfield
                       fromCell:(UITableViewCell*) cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSString* text = self.dataSource[indexPath.row];
    
    if ([text isEqualToString:@"房屋面积"]) {
        self.houseNew.area = textfield.text;
    }
    if ([text isEqualToString:@"几位访客"]) {
        self.houseNew.toliveinNumber = [textfield.text integerValue];
    }
}

@end
