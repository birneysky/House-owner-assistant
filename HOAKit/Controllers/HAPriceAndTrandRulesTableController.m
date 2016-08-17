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

@interface HAPriceAndTrandRulesTableController () <UITextFieldDelegate,HADiscountEditorCellDelegate,HAOffOnCellDelegate,HAEditorNumberCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ppLabel;

@property(nonatomic,strong) NSArray* dataSource;

@property (nonatomic,strong) NSMutableArray* cleaningDataSouce;

@property (nonatomic,copy) HAHouse* houseCopy;

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
    self.houseCopy = self.house;
    
    if(self.houseCopy.cleanType){
        [self.cleaningDataSouce addObject:@"平台提供洗漱用品"];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    NSLog(@"footview %p %@,lable %p lableFrame %@",self.tableView.tableFooterView,NSStringFromClass([self.tableView.tableFooterView class]),self.ppLabel,NSStringFromCGRect(self.ppLabel.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString* textString = cell.textLabel.text;
    //@"平台提供洗漱用品"

    if ([textString isEqualToString:@"需要第三方保洁"]) {
        HAOffOnCell* offOnCell = cell;
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
        HAOffOnCell* offOnCell = cell;
        offOnCell.accessoryViewSelected = ! offOnCell.accessoryViewSelected;
        if ([textString isEqualToString:@"平台提供洗漱用品"]) {
            self.houseCopy.platformToiletries = offOnCell.accessoryViewSelected;
        }
    }
    

    
    [cell.accessoryView becomeFirstResponder];
}


#pragma mark - *** Cells Delegate ***
- (void)selectItemDoneForPickerTextField:(UITextField *)textfield fromCell:(UITableViewCell *)cell
{
     NSLog(@"selectItemDoneForPickerTextField");
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    NSString* text = self.dataSource[indexPath.section][indexPath.row];
    [self.houseCopy setValue:[textfield.text floatValue] forChineseName:text];
    
}

- (void)offONButtonChangedFromCell:(UITableViewCell *)cell sender:(UIButton *)sender
{
    NSLog(@"switchButtonChangedFromCell");
    NSString* textString = cell.textLabel.text;
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if ([textString isEqualToString:@"需要第三方保洁"]) {
        HAOffOnCell* offOnCell = cell;
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
        HAOffOnCell* offOnCell = cell;
        self.houseCopy.platformToiletries = offOnCell.accessoryViewSelected;
    }
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textfield fromCell:(UITableViewCell *)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
     NSString* text = self.dataSource[indexPath.section][indexPath.row];
    
    [self.houseCopy setValue:[textfield.text floatValue] forChineseName:text];
   
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

- (IBAction)saveButtonClicked:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [[HARESTfulEngine defaultEngine] modifyHouseGeneralInfoWithID:self.houseCopy.houseId params:self.houseCopy completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSError *engineError) {
        
    }];
 
}


@end
