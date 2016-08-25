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
#import "HAActiveWheel.h"

@interface HAHouseInfoViewController ()<HAHouseTypeSelectDetailResult,HAHouseBathrommSelectDetailResult,HAEditorNumberCellDelegate>

@property (strong, nonatomic) IBOutlet UILabel *textViewInputingLabel;
@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,strong) HAHouseTypeDataSouceDelegate* houseTypeDataSource;

@property(nonatomic,strong) HABathroomDataSourceDelegate* bathroomDataSource;

@property (nonatomic,copy) HAHouse* houseCopy;

@property (nonatomic,assign) BOOL invalidFlag;

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
    
    self.houseCopy = self.house;
    if (self.house) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
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
    if ([text isEqualToString:@"户型"]) {
        HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.houseTypeDataSource;
        pickerCell.delegate = self;
        [pickerCell.textField setDefultText:@"1室0厅0厨0阳台"];
        //view = cell.accessoryView;
        if (self.house) {
            pickerCell.textField.text = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld阳台",self.house.roomNumber,self.house.hallNumber,self.house.kitchenNumber,self.house.balconyNumber];
        }
       
        cell = pickerCell;
    }
    else if([text isEqualToString:@"卫生间数量"] )
    {
        HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.bathroomDataSource;
        pickerCell.delegate = self;
        [pickerCell.textField setDefultText:@"公共0独立0"];
        
        if (self.house) {
            pickerCell.textField.text = [NSString stringWithFormat:@"公共%ld独立%ld",self.house.publicToiletNumber,self.house.toiletNumber];
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
                editorCell.textField.text = [NSString stringWithFormat:@"%ld",self.house.toliveinNumber];
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
    if (self.invalidFlag) {
        return;
    }
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
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [NETWORKENGINE modifyHouseGeneralInfoWithID:self.houseCopy.houseId
                                         params:self.houseCopy
                                     completion:^(HAHouse *house){
                                          [HAActiveWheel dismissForView:self.navigationController.view];
                                         [self.delegate houseDidChangned:house];
                                         [self.navigationController popViewControllerAnimated:YES];}
                                        onError:^(NSError *engineError) {
                                            [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
                                        }
     ];

}



#pragma mark - *** HAHouseTypeSelectDetailResult ***
- (void)didSelectRoom:(NSInteger)rNum hall:(NSInteger)hallNum cookroom:(NSInteger)cookNum balcony:(NSInteger)bNum
{
    self.houseCopy.roomNumber = rNum;
    self.houseCopy.hallNumber = hallNum;
    self.houseCopy.kitchenNumber = cookNum;
    self.houseCopy.balconyNumber = bNum;
    
    BOOL change = ![self.house isEqualToHouse:self.houseCopy];
    if (change) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void) didSelectPublicBathroom:(NSInteger) pubNum privateBathroom:(NSInteger)privateNum
{
    self.houseCopy.publicToiletNumber = pubNum;
    self.houseCopy.toiletNumber = privateNum;
    
    BOOL change = ![self.house isEqualToHouse:self.houseCopy];
    if (change) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - *** HAEditorNumberCellDelegate ***
- (void) textFieldDidEndEditing:(UITextField*)textfield
                       fromCell:(UITableViewCell*) cell
{
//    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
//    NSString* text = self.dataSource[indexPath.row];
//    
//    if ([text isEqualToString:@"房屋面积"]) {
//        self.houseNew.area = textfield.text;
//    }
//    if ([text isEqualToString:@"几位访客"]) {
//        self.houseNew.toliveinNumber = [textfield.text integerValue];
//    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField*)textField
                            fromCell:(UITableViewCell*)cell
{
    if(self.invalidFlag) return NO;
    else return YES;
}

- (void) textFieldTextDidChange:(UITextField*)textfield
                     changeText:(NSString*)text
                       fromCell:(UITableViewCell*) cell{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSString* textTitle = self.dataSource[indexPath.row];
//    
    if ([textTitle isEqualToString:@"房屋面积"]) {
//        self.houseCopy.area = textfield.text;
        self.textViewInputingLabel.text = @"    请输入0-99999数值";
    }
    if ([textTitle isEqualToString:@"几位访客"]) {
//        self.houseCopy.toliveinNumber = [textfield.text integerValue];
         self.textViewInputingLabel.text = @"    请输入1-10数值";
    }
    
    BOOL valid = [self.houseCopy setValue:text forChineseName:textTitle];
    if (!valid) {
        self.invalidFlag = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        textfield.inputAccessoryView = self.textViewInputingLabel;
        [textfield reloadInputViews];
    }
    else{
        textfield.inputAccessoryView = nil;
        [textfield reloadInputViews];
        self.invalidFlag = NO;
    }
    
    BOOL change = ![self.house isEqualToHouse:self.houseCopy];
    if (valid&&change) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
