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
#import "HOAKit.h"

@interface HAHouseInfoViewController ()<HAHouseTypeSelectDetailResult,HAHouseBathrommSelectDetailResult,HAEditorNumberCellDelegate,HAEditPickerCellDelegate>

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
        _dataSource = [[NSArray alloc] initWithObjects:@"房屋面积",@"户型",@"卫生间",@"可住人数", nil];
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


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (2 == self.houseCopy.checkStatus) {
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"房源已通过审核，不可修改"];
        return;
    }
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
        if (self.house) {
            pickerCell.textField.text = [NSString stringWithFormat:@"%ld室%ld厅%ld厨%ld阳台",(long)self.house.roomNumber,(long)(long)self.house.hallNumber,(long)self.house.kitchenNumber,(long)self.house.balconyNumber];
        }
       
        cell = pickerCell;
    }
    else if([text isEqualToString:@"卫生间"] )
    {
        HAEditPickerCell* pickerCell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
        pickerCell.pickerDataSouce = self.bathroomDataSource;
        pickerCell.delegate = self;
        [pickerCell.textField setDefultText:@"公共0独立0"];
        
        if (self.house) {
            pickerCell.textField.text = [NSString stringWithFormat:@"公共%ld独立%ld",(long)self.house.publicToiletNumber,(long)self.house.toiletNumber];
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
                editorCell.textField.placeholder = @"请输入面积";
            }
        }
        else if([text isEqualToString:@"可住人数"]){
            editorCell.unitName = @"人";
            if (self.house) {
                editorCell.textField.text = self.house.toliveinNumber > 0 ? [NSString stringWithFormat:@"%ld",(long)self.house.toliveinNumber] : @"";
                editorCell.textField.placeholder = @"请输入人数";
            }
        }
        
        editorCell.delegate = self;
        
        cell = editorCell;
    }
    
    
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

#pragma mark - *** Target Action ***

- (IBAction)saveButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.houseCopy.area.length <= 0) {
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"房屋面积未填写"];
        return;
    }
    else if(self.houseCopy.roomNumber <=0){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"户型未填写"];
        return;
    }
    else if (self.houseCopy.toiletNumber == 0 && self.houseCopy.publicToiletNumber ==  0){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"卫生间未填写"];
        return;
    }
    else if (self.houseCopy.toliveinNumber <=0){
      [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"可住人数未填写"];
      return;
    }
    
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [NETWORKENGINE modifyHouseGeneralInfoWithID:self.houseCopy.houseId
                                         params:self.houseCopy
                                     completion:^(HAHouse *house){
                                          [HAActiveWheel dismissForView:self.navigationController.view];
                                         [self.delegate houseDidChangned:house];
                                         [self.navigationController popViewControllerAnimated:YES];
                                         [[NSNotificationCenter defaultCenter] postNotificationName:HAHouseModifyInformationNotification object:house];
                                     }
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
    if (change && self.houseCopy.checkStatus != 2) {
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
    if (change && self.houseCopy.checkStatus != 2) {
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
  
    if ([textTitle isEqualToString:@"房屋面积"]) {
        self.textViewInputingLabel.text = @"    请输入0-99999数值";
    }
    if ([textTitle isEqualToString:@"可住人数"]) {
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
    if (valid&&change && self.house.checkStatus != 2) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

@end
