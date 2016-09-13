//
//  HAPublishHouseInfoTableViewController.m
//  House-owner-assistant
//
//  Created by zhangguang on 16/7/29.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAPublishHouseInfoTableViewController.h"
#import "HARESTfulEngine.h"
#import "HAHouseFullInfo.h"
#import "HAHouseIntroduceViewController.h"
#import "HouseFacilitiesViewController.h"
#import "HAHouseAreaSelectViewController.h"
#import "HAHouseBedViewController.h"
#import "HAHouseInfoViewController.h"
#import "HAPriceAndTrandRulesTableController.h"
#import "HAAddHousePhotoViewController.h"
#import "HAHouseLocationViewController.h"
#import "HAHouseTypeTableViewController.h"
#import "HAActiveWheel.h"
#import "HOAkit.h"

@interface HAPublishHouseInfoTableViewController ()<HADataExchangeDelegate>

@property(nonatomic,strong) NSArray* dataSource;


@property (strong, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageview;
@property (weak, nonatomic) IBOutlet UILabel *pictureCountLabel;

@property (weak, nonatomic) HAAddHousePhotoViewController* addPhotoVC;

@end

@implementation HAPublishHouseInfoTableViewController

#pragma mark - ***Properties ***

- (NSArray*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] initWithObjects:@"房屋标题与介绍",@"价格与交易规则",@"房源信息",@"设施列表",@"床铺信息",@"位置区域",@"出租方式与房源类型",@"地址", nil];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.coverView.frame = CGRectMake(0, 0, size.width, size.height - 64);
    self.navigationItem.rightBarButtonItem.enabled = NO;

    [self fetchHouseInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    self.title = @"发布房源";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.title = @"";
}

#pragma mark - *** Helper ****
- (void)fetchHouseInfo{
    [self.view addSubview:self.coverView];
    [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在载入";
    [[HARESTfulEngine defaultEngine] fetchHouseInfoWithHouseID:self.houseId completion:^(HAHouseFullInfo *info) {
        self.houseFullInfo = info;
        [self.coverView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1];
        [self.tableView reloadData];
        if (2 == self.houseFullInfo.house.checkStatus || 1 == self.houseFullInfo.house.checkStatus) {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.submitBtn.hidden = YES;
        }
        NSArray* viewControllers = self.navigationController.viewControllers;
        self.navigationController.viewControllers = @[viewControllers.firstObject,self];
        if (self.houseFullInfo.images.count <= 0) {
            [HAActiveWheel dismissForView:self.navigationController.view delay:1];
            return;
        }
        NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
        NSString* headerImgPath = [basePath stringByAppendingPathComponent:[self.houseFullInfo.images.firstObject.imagePath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:headerImgPath]) {
            UIImage* headerImg = [UIImage imageWithContentsOfFile:headerImgPath];

            self.houseFullInfo.images.firstObject.localPath = headerImgPath;
            [self configHeaderImage];
            [HAActiveWheel dismissForView:self.navigationController.view delay:1];
        }
        else{
            [self downloadHeaderImage];
        }
        self.pictureCountLabel.text = [NSString stringWithFormat:@"%d",self.houseFullInfo.images.count];
    } onError:^(NSError *engineError) {
        [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"载入失败，请检查网络"];
        self.refreshBtn.hidden = NO;
    }];
}

- (void)downloadHeaderImage
{
    NSString* basePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HouseImagesNet"];
    if(self.houseFullInfo.images.firstObject){
        HAHouseImage* imageItem = self.houseFullInfo.images.firstObject;
        NSString* path = [basePath stringByAppendingPathComponent:[imageItem.imagePath lastPathComponent]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            imageItem.localPath = path;
            [self configHeaderImage];
            return;
        }
        [NETWORKENGINE downloadHouseImageWithPath:self.houseFullInfo.images.firstObject.imagePath completion:^(NSString *certificate, NSString *fileName) {
            NSString* headerImgPath = [basePath stringByAppendingPathComponent:fileName];
            self.houseFullInfo.images.firstObject.localPath = headerImgPath;
            [self configHeaderImage];
            [HAActiveWheel dismissForView:self.navigationController.view delay:1];
        } progress:^(NSString *certificate, float progress) {
            
        } onError:^(NSString *certificate, NSError *error) {
            [HAActiveWheel dismissForView:self.navigationController.view delay:1];
            NSString* headerImgPath = [basePath stringByAppendingPathComponent:[self.houseFullInfo.images.firstObject.imagePath lastPathComponent]];
            NSLog(@"remove headImagePath %@",headerImgPath);
            [[NSFileManager defaultManager] removeItemAtPath:headerImgPath error:nil];
        }];
    }
    else{
        [HAActiveWheel dismissForView:self.navigationController.view delay:1];
    }

    
    
}

- (void)configHeaderImage
{
    HAHouseImage* imageItem = self.houseFullInfo.images.firstObject;
    UIImage* image = [UIImage imageWithContentsOfFile:imageItem.localPath];
    if (image) {
        CIFilter* gaussFileter = [CIFilter filterWithName:@"CIGaussianBlur"];
        CIImage* inputImage = [CIImage imageWithCGImage:image.CGImage];
        [gaussFileter setValue:inputImage forKey:@"inputImage"];
        [gaussFileter setValue:@(5.0) forKey:@"inputRadius"];
        CIImage* outputimage = gaussFileter.outputImage;
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef resultImage =[context createCGImage:outputimage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        self.headerImageview.image = [UIImage imageWithCGImage:resultImage];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseSummaryCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}


#pragma mark - *** TableView Delegate ***

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* text = self.dataSource[indexPath.row];

    if ([text isEqualToString:@"房屋标题与介绍"]) {
        [self performSegueWithIdentifier:@"push_house_introduce" sender:nil];
    }
    else if ([text isEqualToString:@"价格与交易规则"]){
        [self performSegueWithIdentifier:@"push_price_trading_rules" sender:nil];
    }
    else if ([text isEqualToString:@"房源信息"]){
        [self performSegueWithIdentifier:@"push_house_info" sender:nil];
    }
    else if ([text isEqualToString:@"床铺信息"]){
        [self performSegueWithIdentifier:@"push_house_bed_info" sender:nil];
    }
    else if ([text isEqualToString:@"出租方式与房源类型"]){
        NSArray<UIViewController*>* vcs = self.navigationController.viewControllers;
        __block UIViewController* targetVC = nil;
        [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[HAHouseTypeTableViewController class]])
            {
                targetVC = obj;
            }
        }];
        if (targetVC) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"push_back_house_type_select" sender:nil];
        }
        
    }
    else if ([text isEqualToString:@"地址"]){
        NSArray<UIViewController*>* vcs = self.navigationController.viewControllers;
        __block UIViewController* targetVC = nil;
        [vcs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj isKindOfClass:[HAHouseLocationViewController class]])
            {
                targetVC = obj;
            }
        }];
        
        if (targetVC) {
            [self.navigationController popToViewController:targetVC animated:YES];
        }
        else{
            [self performSegueWithIdentifier:@"push_location" sender:nil];
        }
        
    }
    else if([text isEqualToString:@"设施列表"]){
        [self performSegueWithIdentifier:@"push_house_facilities" sender:nil];
    }
    else if([text isEqualToString:@"位置区域"]){
        [self performSegueWithIdentifier:@"push_house_area" sender:nil];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* text = self.dataSource[indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    UIColor* color = [UIColor colorWithRed:245 / 255.0f green:2 / 255.0f blue:63 / 255.0f alpha:1];
    if ([text isEqualToString:@"房屋标题与介绍"] && self.houseFullInfo.houseDescriptionComplete) {
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"价格与交易规则"] && self.houseFullInfo.priceInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"房源信息"] && self.houseFullInfo.houseGeneralInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"床铺信息"] && self.houseFullInfo.bedInfoComplete){
        cell.textLabel.textColor = color;
    }
    else if ([text isEqualToString:@"出租方式与房源类型"] && self.houseFullInfo.rentTypeComplete){
        cell.textLabel.textColor = color;
        
    }
    else if ([text isEqualToString:@"地址"] && self.houseFullInfo.addressInfoComplete){
        cell.textLabel.textColor = color;
        
    }
    else if([text isEqualToString:@"设施列表"] && self.houseFullInfo.facilityInfoComplete && !self.firstEnter){
        cell.textLabel.textColor = color;
    }
    else if([text isEqualToString:@"位置区域"] && self.houseFullInfo.regionInfoComplete){
        cell.textLabel.textColor = color;
    }
}


#pragma mark - *** Target Action ***
- (IBAction)reloadBtnClicked:(id)sender {
    [self fetchHouseInfo];
}
- (IBAction)addBtnClicked:(UIButton *)sender {
    if (self.addPhotoVC) {
        [self.navigationController pushViewController:self.addPhotoVC animated:YES];
    }
    else{
        [self performSegueWithIdentifier:@"push_add_photoes" sender:sender];
    }
 
}

- (IBAction)submitBtnClicked:(id)sender {
    if (self.houseFullInfo.houseDescriptionComplete &&
        self.houseFullInfo.priceInfoComplete &&
        self.houseFullInfo.houseGeneralInfoComplete &&
        self.houseFullInfo.bedInfoComplete &&
        self.houseFullInfo.rentTypeComplete &&
        self.houseFullInfo.addressInfoComplete &&
        self.houseFullInfo.facilityInfoComplete &&
        self.houseFullInfo.regionInfoComplete) {
        
        [HAActiveWheel showHUDAddedTo:self.navigationController.view].processString = @"正在处理";
        self.houseFullInfo.house.checkStatus = 1;
        [NETWORKENGINE submitHouseInfoForCheckOfHouseId:self.houseFullInfo.house.houseId
                                                 params:self.houseFullInfo.house
                                             completion:^(HAHouse* house){
                                                 self.houseFullInfo.house = house;
                                                 [HAActiveWheel dismissForView:self.navigationController.view delay:1];
                                                 if (1 == house.checkStatus) {
                                                     self.submitBtn.hidden = YES;
                                                 }
                                             }
                                                onError:^(NSError *engineError) {
                                                 [HAActiveWheel dismissViewDelay:3 forView:self.navigationController.view warningText:@"处理失败，请检查网络"];
            
        }];
        
    }
    else if (!self.houseFullInfo.houseImageComplete){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"图片少于5张"];
    }
    else if(!self.houseFullInfo.houseDescriptionComplete){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"房源标题与介绍未完善"];
    }
    else if(!self.houseFullInfo.priceInfoComplete){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"价格与交易规则未完善"];
    }
    else if(!self.houseFullInfo.houseGeneralInfoComplete){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"房源信息未完善"];
    }
    else if (!!self.firstEnter){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"设施列表未完善"];
    }
    else if(!self.houseFullInfo.bedInfoComplete){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"床铺信息未完善"];
    }
    else if(!self.houseFullInfo.regionInfoComplete){
        [HAActiveWheel showPromptHUDAddedTo:self.navigationController.view text:@"位置区域未完善"];
    }

    
}

- (IBAction)reviewBtnClicked:(id)sender {
    
    if ([[HOAKit defaultInstance].delegate respondsToSelector:@selector(previewHouseInformationOfHouseId:)]) {
        [[HOAKit defaultInstance].delegate previewHouseInformationOfHouseId:self.houseId];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"push_house_introduce"]) {
        HAHouseIntroduceViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_facilities"]) {
        HouseFacilitiesViewController* vc = segue.destinationViewController;
        vc.houseId = self.houseId;
        vc.factilities = self.houseFullInfo.facility;
        vc.delegate = self;
        self.firstEnter = NO;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_area"]) {
        HAHouseAreaSelectViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.positionArray = self.houseFullInfo.positions;
        vc.delegate = self;
    }

    if([segue.identifier isEqualToString:@"push_house_bed_info"]){
        HAHouseBedViewController* vc = segue.destinationViewController;
        NSMutableArray* bes = [[NSMutableArray alloc] initWithArray:self.houseFullInfo.beds];
        vc.beds = bes;
        vc.houseId = self.houseFullInfo.house.houseId;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_house_info"]) {
        HAHouseInfoViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_price_trading_rules"]) {
        HAPriceAndTrandRulesTableController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_add_photoes"]) {
        HAAddHousePhotoViewController* vc = segue.destinationViewController;
        self.addPhotoVC = vc;
        vc.house = self.houseFullInfo.house;
        vc.photoes = self.houseFullInfo.images;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_location"]) {
        HAHouseLocationViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"push_back_house_type_select"]) {
        HAHouseTypeTableViewController* vc = segue.destinationViewController;
        vc.house = self.houseFullInfo.house;
        vc.delegate = self;
    }

}


#pragma mark - ***HADataExchangeDelegate  ***


- (void) houseDidChangned:(HAHouse*) house
{
    self.houseFullInfo.house = house;
    [self.tableView reloadData];
}

- (void) bedsOfHouseDidChange:(NSArray<HAHouseBed*>*) beds
{
    self.houseFullInfo.beds =beds;
    [self.tableView reloadData];
}

- (void) positionsOfHouseDidChange:(NSArray<HAHousePosition*>*) positions
{
    self.houseFullInfo.positions = positions;
    [self.tableView reloadData];
}

- (void) facilityOfHouseDidChange:(HAHouseFacility*) facility
{
    self.houseFullInfo.facility = facility;
    [self.tableView reloadData];
}

- (void) imagesOfHouseDidChange:(NSArray<HAHouseImage*>*) images
{
    self.houseFullInfo.images = images;
    self.pictureCountLabel.text = [NSString stringWithFormat:@"%d",images.count];
    HAHouseImage* imageItem = images.firstObject;
    UIImage* image = [UIImage imageWithContentsOfFile:imageItem.localPath];
    if (image) {
         CIFilter* gaussFileter = [CIFilter filterWithName:@"CIGaussianBlur"];
        CIImage* inputImage = [CIImage imageWithCGImage:image.CGImage];
        [gaussFileter setValue:inputImage forKey:@"inputImage"];
        [gaussFileter setValue:@(2.0) forKey:@"inputRadius"];
        CIImage* outputimage = gaussFileter.outputImage;
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef resultImage =[context createCGImage:outputimage fromRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        self.headerImageview.image = [UIImage imageWithCGImage:resultImage];
    }
   
}


@end
