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
#import "HAHouseBed.h"
#import "HAAppDataHelper.h"
#import "HARESTfulEngine.h"
#import "HAActiveWheel.h"

@interface HAEditHouseBenViewController () <HAEditPickerCellDelegate,HAEditorNumberCellDelegate,HAHouseBedTypeSelectDetailResult>

@property(nonatomic,strong) NSArray* dataSource;

@property(nonatomic,strong) HABedTypeDataSourceDelegate* bedTypeDataSouce;

@property(nonatomic,assign) BOOL isNewBed;

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
        _bedTypeDataSouce.detailResultDelegate = self;
    }
    return _bedTypeDataSouce;
}

- (HAHouseBed*)bed
{
    if (!_bed) {
        _bed = [[HAHouseBed alloc] init];
    }
    return _bed;
}

#pragma mark - *** Init **

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);

    //如果不设置表示添加床铺信息，这里不要使用self.bed.
    if (_bed) {
        self.isNewBed = NO;

    }
    else{
        self.isNewBed = YES;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
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
        pickerCell.delegate = self;
        pickerCell.textField.text = [HAAppDataHelper bedName:self.bed.bedTypeId] ;
        pickerCell.textField.placeholder = @"请输入床型";
        cell = pickerCell;
    }
    else {
        HAEditorNumberCell* editCell = [tableView dequeueReusableCellWithIdentifier:@"HABedSizeCell" forIndexPath:indexPath];
        editCell.unitName = @"m";
        if([text isEqualToString:@"数量"]){
            editCell.unitName = @"张";
            NSString* value = self.bed.number <= 0 ? @"" : [NSString stringWithFormat:@"%ld",(long)self.bed.number];
            editCell.textField.text = value;
            editCell.textField.placeholder = @"请输入数量";
        }
        else if([text isEqualToString:@"长度"]){
            NSString* value = self.bed.length <= 0 ? @"" : [NSString stringWithFormat:@"%.1f",self.bed.length];
            editCell.textField.text = value;
            editCell.textField.placeholder = @"请输入长度";
        }
        else if ([text isEqualToString:@"宽度"]){
            NSString* value = self.bed.width <= 0 ? @"" : [NSString stringWithFormat:@"%.1f",self.bed.width];
            editCell.textField.text = value;
            editCell.textField.placeholder = @"请输入宽度";
        }
        
       
        editCell.delegate = self;
        cell = editCell;
    }

    cell.textLabel.text = text;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.accessoryView becomeFirstResponder];
}

#pragma mark - *** Helper ***
- (void) checkBedInfoCompleteness
{
    if (self.bed.bedTypeId > 0 && self.bed.width > 0 && self.bed.length > 0 && self.bed.number > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - *** HAHouseBedTypeSelectDetailResult ***
- (void)didSelectBedType:(NSInteger)type
{
//    if (!self.isNewBed) {
//        return;
//    }
    self.bed.bedTypeId = type;
    [self checkBedInfoCompleteness];
}

#pragma mark - *** Textfield pickeer delegate ***
- (void)selectItemDoneForPickerTextField:(UITextField*)textfield
                                fromCell:(UITableViewCell*) cell
{
//    if (!self.isNewBed) {
//        return;
//    }
    NSString* text = cell.textLabel.text;
    if ([text isEqualToString:@"床型"]) {
        self.bed.bedTypeId = [HAAppDataHelper typeForBedName:textfield.text];
    }
    
    [self checkBedInfoCompleteness];
}

#pragma mark - ***Target Action  ***
- (IBAction)saveBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    self.bed.houseId = self.houseId;
    if (self.isNewBed) {
        [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在添加";
        [[HARESTfulEngine defaultEngine] addHouseBed:self.bed completion:^(HAHouseBed *object) {
            [HAActiveWheel dismissForView:self.navigationController.view];
            if ([self.delegate respondsToSelector:@selector(houseBedInfoDidEndEditing:)]) {
                [self.delegate houseBedInfoDidEndEditing:object];
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        } onError:^(NSError *engineError) {
            [HAActiveWheel dismissViewDelay:2 forView:self.navigationController.view warningText:@"添加失败，请检查网络"];
        }];
    }
    else{
         [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在添加";
        [NETWORKENGINE modifyHouseBed:self.bed completion:^(HAHouseBed *bed) {
            self.bed.length = bed.length;
            self.bed.width = bed.width;
            self.bed.number = bed.number;
            self.bed.bedTypeId = bed.bedTypeId;
             [HAActiveWheel dismissForView:self.navigationController.view];
            [self.navigationController popViewControllerAnimated:YES];
        } onError:^(NSError *engineError) {
             [HAActiveWheel dismissViewDelay:2 forView:self.navigationController.view warningText:@"添加失败，请检查网络"];
        }];
    }

}

#pragma mark - *** HAEditorNumberCellDelegate ***
- (void) textFieldTextDidChange:(UITextField*)textfield
                     changeText:(NSString*)text
                       fromCell:(UITableViewCell*) cell{
    
//    if (!self.isNewBed) {
//        return;
//    }
    NSString* textTitle = cell.textLabel.text;
    if ([textTitle isEqualToString:@"长度"]) {
        self.bed.length = [text floatValue];
    }
    else if ([textTitle isEqualToString:@"宽度"]){
        self.bed.width = [text floatValue];
    }
    else if ([textTitle isEqualToString:@"数量"]){
        self.bed.number = [text integerValue];
    }
    
    [self checkBedInfoCompleteness];
}
@end
