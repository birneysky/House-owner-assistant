//
//  ViewController.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/30.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "ViewController.h"
#import <HOAKit/HOAViewController.h>

@interface ViewController ()

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
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"HOAKit" ofType:@"bundle"];
    NSBundle* bundle = [NSBundle bundleWithPath:path];
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"House-owner-assistant" bundle:bundle];
    HOAViewController* nav = [sb instantiateViewControllerWithIdentifier:@"house_owner_assisnt_nav"];
    [self presentViewController:nav animated:YES completion:nil];
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
