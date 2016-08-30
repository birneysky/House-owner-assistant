//
//  HAPriceAndTrandRulesTableController.m
//  HOAKit
//
//  Created by zhangguang on 16/8/2.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAPriceAndTrandRulesTableController.h"
#import "HAEditorNumberCell.h"
#import "HAOffOnCell.h"
#import "HADiscountEditorCell.h"
#import "HAHouse.h"
#import "HARESTfulEngine.h"
#import "HAActiveWheel.h"

@interface HAPriceAndTrandRulesTableController () <UITextFieldDelegate,HADiscountEditorCellDelegate,HAOffOnCellDelegate,HAEditorNumberCellDelegate>

@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (strong, nonatomic) IBOutlet UILabel *textViewInputingLabel;
@property(nonatomic,strong) NSArray* dataSource;

@property (nonatomic,strong) NSMutableArray* cleaningDataSouce;

@property (nonatomic,copy) HAHouse* houseCopy;

@property (nonatomic,assign) BOOL invalidFlag;

@end

@implementation HAPriceAndTrandRulesTableController

#pragma mark - *** ***
- (NSArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@[@"日价"],@[@"押金",@"线上收取押金"],@[@"3天折扣",@"7天折扣",@"15天折扣",@"30天折扣"],self.cleaningDataSouce,@[@"退订规则"], nil];
        //@"平台提供洗漱用品"
    }
    return _dataSource;
}

- (NSMutableArray*)cleaningDataSouce
{
    if (!_cleaningDataSouce) {
        _cleaningDataSouce = [[NSMutableArray alloc] initWithObjects:@"需要第三方保洁", nil];
    }
    return _cleaningDataSouce;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    if (self.house) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    self.houseCopy = self.house;
    
    if(self.houseCopy.cleanType){
        [self.cleaningDataSouce addObject:@"平台提供洗漱用品"];
    }
    
    if (self.changePrice) {
        [self fetchHouseInfo];
    }
}


#pragma mark - *** Helper ***
- (void) fetchHouseInfo
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.coverView.frame = CGRectMake(0, 65, size.width, size.height -64 );
    [self.navigationController.view addSubview:self.coverView];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在载入";
    [[HARESTfulEngine defaultEngine] fetchHouseInfoWithHouseID:self.house.houseId completion:^(HAHouseFullInfo *info) {
        self.house = info.house;
        self.houseCopy = self.house;
        [HAActiveWheel dismissForView:self.navigationController.view delay:1];
        [self.coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
        [self.tableView reloadData];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"载入失败，请检查网络"];
        self.refreshBtn.hidden = NO;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray* array = self.dataSource[section];
    return array.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (4 == indexPath.section) {
        return 300.0f;
    }
    else{
        return 44.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    NSString* text = self.dataSource[indexPath.section][indexPath.row];
    cell.accessoryView = nil;

    if([text isEqualToString:@"线上收取押金"] ||
       [text isEqualToString:@"需要第三方保洁"] ||
       [text isEqualToString:@"平台提供洗漱用品"] ||
       [text isEqualToString:@"平台提供床品"]){	
        HAOffOnCell* switchCell = [tableView dequeueReusableCellWithIdentifier:@"HAPriceOnOffCell" forIndexPath:indexPath];
        switchCell.delegate = self;
        switchCell.accessoryViewSelected = [self.houseCopy boolValueOfChineseName:text];
        cell = switchCell;
    }
    
    if([text isEqualToString:@"日价"]||
       [text isEqualToString:@"押金"]){
        HAEditorNumberCell* editorCell = (HAEditorNumberCell*)[tableView dequeueReusableCellWithIdentifier:@"HAPriceNumberCell" forIndexPath:indexPath];
        editorCell.unitName = @"元";
        editorCell.delegate = self;
        editorCell.textField.text = [self.houseCopy stringValueOfChineseName:text];
        editorCell.textField.placeholder = [text isEqualToString:@"日价"] ?  @"请输入日价" : @"请输入押金";
        cell = editorCell;
        
    }
    ///@"7天折扣",@"15天折扣",@"30天折扣"
    if([text isEqualToString:@"3天折扣"]||
       [text isEqualToString:@"7天折扣"] ||
       [text isEqualToString:@"15天折扣"] ||
       [text isEqualToString:@"30天折扣"]){
        HADiscountEditorCell* discountCell = [tableView dequeueReusableCellWithIdentifier:@"HADiscountCell" forIndexPath:indexPath];
        discountCell.delegate = self;
        discountCell.unitName = @"折";
        discountCell.textField.text = [self.houseCopy stringValueOfChineseName:text];
        cell = discountCell;
    }
    
    if ([text isEqualToString:@"退订规则"]) {
        UITableViewCell* ttCell = [tableView dequeueReusableCellWithIdentifier:@"HAPriceRuleCell" forIndexPath:indexPath];
        return ttCell;
    }
    
    cell.textLabel.text = text;
    return cell;
}

//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (0 == section) {
//        return nil;
//    }
//    else if (1 == section){
//        return @"以下是非必填选项";
//    }
//    else{
//        return @"勾选一下部分，将分出部分收益给人员";
//    }
// 
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.invalidFlag) {
        return;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* textString = cell.textLabel.text;
    //@"平台提供洗漱用品"

    if ([textString isEqualToString:@"需要第三方保洁"]) {
        HAOffOnCell* offOnCell = (HAOffOnCell*)cell;
        NSInteger section = indexPath.section;
        NSMutableArray* mutableArray = self.dataSource[indexPath.section];
        if (!offOnCell.accessoryViewSelected) {
            //offOnCell.accessoryViewSelected = YES;
            [mutableArray addObject:@"平台提供洗漱用品"];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationMiddle];
            self.houseCopy.cleanType = YES;
        }
        else{
            //offOnCell.accessoryViewSelected = NO;
            [mutableArray removeLastObject];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationMiddle];
            self.houseCopy.cleanType = NO;
            self.houseCopy.platformToiletries = NO;
        }

    }
    
    if ([cell respondsToSelector:@selector(setAccessoryViewSelected:)]) {
        HAOffOnCell* offOnCell = (HAOffOnCell*)cell;
        offOnCell.accessoryViewSelected = ! offOnCell.accessoryViewSelected;
        if ([textString isEqualToString:@"平台提供洗漱用品"]) {
            self.houseCopy.platformToiletries = offOnCell.accessoryViewSelected;
        }
    }
    
    [cell.accessoryView becomeFirstResponder];
    
    BOOL change = ![self.house isEqualToHouse:self.houseCopy];
    if (change) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}


#pragma mark - *** Cells Delegate ***
- (void)selectItemDoneForPickerTextField:(UITextField *)textfield fromCell:(UITableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSString* text = self.dataSource[indexPath.section][indexPath.row];
    [self.houseCopy setValue:textfield.text forChineseName:text];
    
}

- (void)offONButtonChangedFromCell:(UITableViewCell *)cell sender:(UIButton *)sender
{
    NSString* textString = cell.textLabel.text;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if ([textString isEqualToString:@"需要第三方保洁"]) {
        HAOffOnCell* offOnCell = (HAOffOnCell*)cell;
        NSInteger section = indexPath.section;
        NSMutableArray* mutableArray = self.dataSource[indexPath.section];
        if (offOnCell.accessoryViewSelected) {
            [mutableArray addObject:@"平台提供洗漱用品"];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationMiddle];
            self.houseCopy.cleanType = YES;
        }
        else{
            self.houseCopy.cleanType = NO;
            self.houseCopy.platformToiletries = NO;
            [mutableArray removeLastObject];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:section]] withRowAnimation:UITableViewRowAnimationMiddle];
        }
        
    }
    
    if ([textString isEqualToString:@"平台提供洗漱用品"]) {
        HAOffOnCell* offOnCell = (HAOffOnCell*)cell;
        self.houseCopy.platformToiletries = offOnCell.accessoryViewSelected;
    }
    
    
    if ([textString isEqualToString:@"线上收取押金"]) {
        HAOffOnCell* offOnCell = (HAOffOnCell*)cell;
        self.houseCopy.needDeposit = offOnCell.accessoryViewSelected;
    }
    
    BOOL change = ![self.house isEqualToHouse:self.houseCopy];
    if (change) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment  = NSTextAlignmentCenter;
    if (0 == section) {
        return nil;
    }
    else if (1 == section){
        lable.font = [UIFont systemFontOfSize:12.0f];
        lable.textColor = [UIColor colorWithRed:172/255.0f green:172/255.0f blue:172/255.0f alpha:1];
        CGRect frame = lable.frame;
        frame.size.height = 21.0f;
        lable.frame = frame;
        lable.text = @"以下是非必填选项";
    }
    else if(2 == section){
        lable.text = @"折扣";
        lable.font = [UIFont systemFontOfSize:12.0f];
        lable.textColor = [UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1];
    }
    else if (3==section){
        lable.text = @"保洁方式";
        lable.font = [UIFont systemFontOfSize:12.0f];
        lable.textColor = [UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1];
    }
    else if (4 == section){
        lable.text = @"退订规则";
        lable.font = [UIFont systemFontOfSize:12.0f];
        lable.textColor = [UIColor colorWithRed:113/255.0f green:113/255.0f blue:113/255.0f alpha:1];
    }

    return lable;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - *** Target Action ***

- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
    [NETWORKENGINE modifyHouseGeneralInfoWithID:self.houseCopy.houseId
                                         params:self.houseCopy
                                     completion:^(HAHouse* house){
                                         [HAActiveWheel dismissForView:self.navigationController.view];
                                         [self.delegate houseDidChangned:house];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     } onError:^(NSError *engineError) {
                                         [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
        
    }];
 
}
- (IBAction)refreshBtnClicked:(id)sender {
    [self fetchHouseInfo];
}

#pragma mark - *** HAEditorNumberCellDelegate ***
- (void)textFieldDidEndEditing:(UITextField *)textfield fromCell:(UITableViewCell *)cell
{
    //    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    //     NSString* text = self.dataSource[indexPath.section][indexPath.row];
    //
    //    [self.houseCopy setValue:[textfield.text floatValue] forChineseName:text];
    
}

- (BOOL) textFieldShouldBeginEditing:(UITextField*)textField
                            fromCell:(UITableViewCell*)cell
{
    if(self.invalidFlag) return NO;
    else return YES;
}

- (void) textFieldTextDidChange:(UITextField*)textfield
                    changeText:(NSString*)text
                       fromCell:(UITableViewCell*) cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSString* titleText = self.dataSource[indexPath.section][indexPath.row];
    
    BOOL valid =  [self.houseCopy setValue:text forChineseName:titleText];
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

#pragma mark - *** HAOffOnCellDelegate ***
- (BOOL) offOnButtonShouldResponseEvent:(UIButton*)offOnBtn
                               fromCell:(UITableViewCell*)cell
{
    if(self.invalidFlag) return NO;
    else return YES;
}
@end
