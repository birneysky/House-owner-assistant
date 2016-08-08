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

@interface HAPriceAndTrandRulesTableController () <UITextFieldDelegate,HADiscountEditorCellDelegate,HAOffOnCellDelegate,HAEditorNumberCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *ppLabel;

@property(nonatomic,strong) NSArray* dataSource;

@end

@implementation HAPriceAndTrandRulesTableController

#pragma mark - *** ***
- (NSArray*)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@[@"日价"],@[@"押金",@"线上收取押金"],@[@"3天折扣",@"7天折扣",@"15天折扣",@"30天折扣"],@[@"需要第三方保洁",@"平台提供洗漱用品"], nil];
    }
    return _dataSource;
}

#pragma mark - *** Init ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.tableView.sectionFooterHeight = 280;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    NSLog(@"footview %p %@,lable %p lableFrame %@",self.tableView.tableFooterView,NSStringFromClass([self.tableView.tableFooterView class]),self.ppLabel,NSStringFromCGRect(self.ppLabel.frame));
//    self.ppLabel.frame = CGRectMake(0, 0, 600, 300);
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    NSString* text = self.dataSource[indexPath.section][indexPath.row];
    cell.accessoryView = nil;

    if([text isEqualToString:@"线上收取押金"]        ||
       [text isEqualToString:@"需要第三方保洁"]   ||
       [text isEqualToString:@"平台提供洗漱用品"] ||
       [text isEqualToString:@"平台提供床品"]){
        HAOffOnCell* switchCell = [tableView dequeueReusableCellWithIdentifier:@"HAPriceOnOffCell" forIndexPath:indexPath];
        switchCell.delegate = self;
        cell = switchCell;
    }
    
    if([text isEqualToString:@"日价"]||
       [text isEqualToString:@"押金"]){
        HAEditorNumberCell* editorCell = (HAEditorNumberCell*)[tableView dequeueReusableCellWithIdentifier:@"HAPriceNumberCell" forIndexPath:indexPath];
        editorCell.unitName = @"元";
        editorCell.delegate = self;
        cell = editorCell;
        
    }
    ///@"7天折扣",@"15天折扣",@"30天折扣"
    if([text isEqualToString:@"3天折扣"]||
       [text isEqualToString:@"7天折扣"] ||
       [text isEqualToString:@"15天折扣"] ||
       [text isEqualToString:@"30天折扣"]){
        HADiscountEditorCell* discountCell = [tableView dequeueReusableCellWithIdentifier:@"HADiscountCell" forIndexPath:indexPath];
        discountCell.delegate = self;
        cell = discountCell;
    }
    cell.textLabel.text = text;
    return cell;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return nil;
    }
    else if (1 == section){
        return @"以下是非必填选项";
    }
    else{
        return @"勾选一下部分，将分出部分收益给人员";
    }
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.accessoryView becomeFirstResponder];
}


#pragma mark - *** Cells Delegate ***
- (void)selectItemDoneForPickerTextField:(UITextField *)textfield fromCell:(UITableViewCell *)cell
{
     NSLog(@"selectItemDoneForPickerTextField");
}

- (void)offONButtonChangedFromCell:(UITableViewCell *)cell sender:(UIButton *)sender
{
    NSLog(@"switchButtonChangedFromCell");
}

- (void)textFieldDidEndEditing:(UITextField *)textfield fromCell:(UITableViewCell *)cell
{
   NSLog(@"textFieldDidEndEditing");
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel* lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lable.textAlignment  = NSTextAlignmentCenter;
    if (0 == section) {
        return nil;
    }
    else if (1 == section){
        lable.text = @"以下是非必填选项";
    }
    else if(2 == section){
        lable.text = @"折扣";
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
    [self.navigationController popViewControllerAnimated:YES];
}


@end
