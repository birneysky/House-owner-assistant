//
//  ViewController.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/30.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "ViewController.h"
#import <HOAKit/HOAKit.h>

@interface ViewController ()<HASelectHousePositionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userIdTextField;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = version;
    
    [HOAKit defaultInstance].token = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyTmFtZSI6IjMy56ys5LiJ5LujIiwiZXhwIjowLCJ1c2VySWQiOjEsImlhdCI6MTQ3NDI3Mzc0MCwiaXNzdWVyIjoiaHR0cHM6Ly93d3cueWltZWkuY29tLyJ9._IM9uqdUnlVcE0P7YMxAfYYK0ahEVpODrs_RFuVmkxg";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testAction:(id)sender {
    NSInteger userId = [self.userIdTextField.text integerValue];
    if (0 != userId) {
        [HOAKit defaultInstance].userId = userId;
    }
    else{
       [HOAKit defaultInstance].userId = 1;
    }
    

    UINavigationController* hoaRoot = [HOAKit defaultInstance].rootViewController;
    [self presentViewController:hoaRoot animated:YES completion:nil];
}
- (IBAction)testPostionAction:(id)sender {
    //110100
    HASelectHousePositionViewController* pvc = [[HASelectHousePositionViewController alloc] initWithProvinceId:110000 cityId:110100];
    pvc.delegate = self;
    pvc.positionTypeSelected = 1;
    pvc.positionIdSelected = 586;
    [self.navigationController pushViewController:pvc animated:YES];
    
}



- (void)didSelectHousePosition:(id<HAGeneralPosition>)position
{
    NSLog(@"position Name %@ type %ld, positionId %ld",position.name,position.typeId,position.positionId);
}

- (void)clearSelectPostions
{
    NSLog(@"postion name");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
