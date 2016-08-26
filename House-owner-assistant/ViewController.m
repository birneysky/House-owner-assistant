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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)testAction:(id)sender {
    
    UINavigationController* hoaRoot = GetHOAKitRootViewController();
    [self presentViewController:hoaRoot animated:YES completion:nil];
}
- (IBAction)testPostionAction:(id)sender {
    //110100
   HASelectHousePositionViewController* pvc = [[HASelectHousePositionViewController alloc] initWithCityID:110100];
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
