//
//  HAHouseIntroduceViewController.m
//  HOAKit
//
//  Created by zhangguang on 16/8/2.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseIntroduceViewController.h"

@interface HAHouseIntroduceViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UITextView *houseLiftTextView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *houseDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *houseLocationTextView;
@property (weak, nonatomic) IBOutlet UITextView *houseTrafficTextView;

@property (nonatomic,weak) UIView* firstResponderView;
@end

@implementation HAHouseIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.scrollView.contentOffset = CGPointMake(0, 44);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)dealloc
{
    NSLog(@"HAHouseIntroduceViewController dealloc ~");
}

#pragma mark - *** Target Action ***
- (IBAction)saveButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
//    NSArray* controllers = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:controllers[controllers.count - 3] animated:YES];
}

#pragma mark - *** TextField Delegate ***
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.titleTextField == textField) {
        [self.houseDescriptionTextView becomeFirstResponder];
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.firstResponderView = textField;
    return YES;
}

#pragma mark - *** UITextViewDelegate ***
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.firstResponderView = textView;
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = textView.frame;
    rect.size.height += 5;
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.houseDescriptionTextView == textView) {
            [self.houseLocationTextView becomeFirstResponder];
        }
        else if (self.houseLocationTextView == textView){
            [self.houseTrafficTextView becomeFirstResponder];
        }
        else if(self.houseTrafficTextView == textView){
            [self.houseLiftTextView becomeFirstResponder];
        }
        else if (self.houseLiftTextView == textView)
        {
            [self.houseLiftTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - *** Keyboard Notification Selector ***
- (void)keyboardDidShow:(NSNotification*)notification
{
    /*获取InputView 的区域*/
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    NSLog(@"scrollview origin %@",NSStringFromCGRect(self.scrollView.frame));
    CGRect newScrollViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, keyboardTop);
    NSLog(@"scrollview origin %@",NSStringFromCGRect(self.scrollView.frame));

    self.scrollView.frame = newScrollViewFrame;
    self.contentViewBottomConstraint.constant = keyboardTop;
    [self.scrollView scrollRectToVisible:self.firstResponderView.frame animated:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification
{

    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.contentViewBottomConstraint.constant = 0;
    CGRect rect = self.titleTextField.frame;
    rect.origin.y += 56;
    [self.scrollView scrollRectToVisible:rect animated:YES];

    
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
