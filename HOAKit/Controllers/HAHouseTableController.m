//
//  HAHouseInfoTableController.m
//  House-owner-assistant
//
//  Created by birneysky on 16/7/28.
//  Copyright © 2016年 HA. All rights reserved.
//

#import "HAHouseTableController.h"
#import "HAFloatingButton.h"
#import "HARESTfulEngine.h"

@interface HAHouseTableController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet HAFloatingButton *addButton;

@end

@implementation HAHouseTableController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[HARESTfulEngine defaultEngine] fetchHouseItemsWithHouseOwnerID:1 onSucceeded:^(NSArray *listOfModelBaseObjects) {
//        
//    } onError:^(NSError *engineError) {
//        
//    }];
    
//    [[HARESTfulEngine defaultEngine] fetchHouseInfoWithHouseID:16 onSucceeded:^(HAJSONModel *aModelBaseObject) {
//        NSString* houseJson = [aModelBaseObject toJsonString];
//        NSLog(@"houseJson %@",houseJson);
//    } onError:^(NSError *engineError) {
//        
//    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HAHouseInfoCell" forIndexPath:indexPath];
    
    return cell;
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

@end
