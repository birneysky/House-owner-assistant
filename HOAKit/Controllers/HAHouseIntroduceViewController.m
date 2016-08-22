//
//  HAHouseIntroduceViewController.m
//  HOAKit
//
//  Created by zhangguang on 16/8/2.
//  Copyright © 2016年 birneysky. All rights reserved.
//

#import "HAHouseIntroduceViewController.h"
#import "HAHouse.h"
#import "HARESTfulEngine.h"

@interface HAHouseIntroduceViewController ()<UITextViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UITextView *houseLiftTextView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextView *houseDescriptionTextView;
@property (weak, nonatomic) IBOutlet UITextView *houseLocationTextView;
@property (weak, nonatomic) IBOutlet UITextView *houseTrafficTextView;

@property (weak, nonatomic) IBOutlet UITextView *houseCommentTextView;
@property (strong, nonatomic) IBOutlet UILabel *textViewInputingLabel;
@property (nonatomic,weak) UIView* firstResponderView;


@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) CGFloat contentOffset;

@property (nonatomic,copy) HAHouse* houseCopy;

@property (nonatomic,assign) PRTValidState validFlag;



@end

@implementation HAHouseIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.scrollView.contentOffset = CGPointMake(0, 44);
    self.validFlag = PRTValidStateNormal;
    if (self.house) {
        self.titleTextView.text = self.house.title;
        self.houseDescriptionTextView.text = self.house.houseDescription;
        self.houseLocationTextView.text = self.house.position;
        self.houseTrafficTextView.text = self.house.traffic;
        self.houseLiftTextView.text = self.house.surroundings;
        self.houseCommentTextView.text = self.house.remarks;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    self.houseCopy = self.house;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    
    
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

    CGRect rect = [self.view convertRect:self.houseCommentTextView.frame fromView:self.scrollView];
    //NSLog(@"viewframe %@,rect %@",NSStringFromCGRect(self.view.frame),NSStringFromCGRect(rect));
    if (rect.origin.y + rect.size.height > self.view.frame.size.height) {
        self.contentOffset = (rect.origin.y + rect.size.height  - self.view.frame.size.height)  + 64;
        self.contentViewBottomConstraint.constant = self.contentOffset ;
        [self.scrollView layoutIfNeeded];
    }
       NSLog(@"scroll frame %@,contentsize %@,contentofffset %@,torect %@",NSStringFromCGRect(self.scrollView.frame),NSStringFromCGSize(self.scrollView.contentSize),NSStringFromCGPoint(self.scrollView.contentOffset),NSStringFromCGRect(rect));
}


- (void)dealloc
{
    NSLog(@"HAHouseIntroduceViewController dealloc ~");
}

#pragma mark - *** Target Action ***
- (IBAction)saveButtonClicked:(id)sender {
    [self.view endEditing:YES];
    
    [[HARESTfulEngine defaultEngine] modifyHouseGeneralInfoWithID:self.houseCopy.houseId params:self.houseCopy completion:^{
         [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSError *engineError) {
        
    }];
   
//    NSArray* controllers = self.navigationController.viewControllers;
//    [self.navigationController popToViewController:controllers[controllers.count - 3] animated:YES];
}

//#pragma mark - *** TextField Delegate ***
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    if (self.titleTextView == textField) {
//        [self.houseDescriptionTextView becomeFirstResponder];
//        return NO;
//    }
//    return YES;
//}
//
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    self.firstResponderView = textField;
//    return YES;
//}
#pragma mark - *** Helper ***
- (BOOL) limitTextViewTextLengthMin:(NSInteger)min max:(NSInteger)max textView:(UITextView*)textView warningText:(NSString*)text
{
    BOOL flag = NO;
    self.textViewInputingLabel.text = [NSString stringWithFormat:@"    %@",text];
    if (textView.text.length < min) {
        textView.inputAccessoryView = self.textViewInputingLabel;
        flag = NO;
    }
    else if(textView.text.length > max){
        textView.inputAccessoryView = self.textViewInputingLabel;
        flag = NO;
    }
    else{
        textView.inputAccessoryView = nil;
        flag = YES;
    }
    [textView reloadInputViews];
    return flag;
}


#pragma mark - *** UITextViewDelegate ***
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.firstResponderView = textView;
    //textView.text = @"";
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = self.firstResponderView.frame;
    rect.size.height += 5;
    rect.origin.y += self.keyboardHeight ;//self.scrollView.contentSize.height - self.scrollView.frame.size.height;

   // rect = [self.scrollView convertRect:rect fromView:nil];
//    NSLog(@"scroll frame %@,contentsize %@,contentofffset %@,torect %@",NSStringFromCGRect(self.scrollView.frame),NSStringFromCGSize(self.scrollView.contentSize),NSStringFromCGPoint(self.scrollView.contentOffset),NSStringFromCGRect(rect));
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
    if (self.titleTextView == textView) {
        if(self.validFlag | PRTValidStateTitle == PRTValidStateTitle)
        {
            self.textViewInputingLabel.text = @"   请输入5-20个字";
        }
    }
    else if (self.houseDescriptionTextView == textView){
        if(self.validFlag | PRTValidStateDescription == PRTValidStateDescription)
        {
            self.textViewInputingLabel.text = @"   请输入0-250个字";
        }
    }
    else if (self.houseLocationTextView == textView){
        if(self.validFlag | PRTValidStatePosition == PRTValidStatePosition)
        {
            self.textViewInputingLabel.text = @"   请输入0-250个字";
        }
    }
    else if (self.houseTrafficTextView == textView){
        if(self.validFlag | PRTValidStateTraffic == PRTValidStateTraffic)
        {
            self.textViewInputingLabel.text = @"   请输入0-250个字";
        }
    }
    else if (self.houseLiftTextView == textView){
        if(self.validFlag | PRTValidStateSurroundings == PRTValidStateSurroundings)
        {
            self.textViewInputingLabel.text = @"   请输入0-250个字";
        }
    }
    else if (self.houseCommentTextView == textView){
        if(self.validFlag | PRTValidStateRemarks == PRTValidStateRemarks)
        {
            self.textViewInputingLabel.text = @"   请输入0-250个字";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*
     self.titleTextView.text = self.house.title;
     self.houseDescriptionTextView.text = self.house.houseDescription;
     self.houseLocationTextView.text = self.house.position;
     self.houseTrafficTextView.text = self.house.traffic;
     self.houseLiftTextView.text = self.house.surroundings;
     self.houseCommentTextView.text = self.house.remark;

     */
    if (self.titleTextView == textView) {
        self.houseCopy.title = textView.text;
    }
    else if (self.houseDescriptionTextView == textView){
        self.houseCopy.houseDescription = textView.text;
    }
    else if (self.houseLocationTextView == textView){
        self.houseCopy.position = textView.text;
    }
    else if (self.houseTrafficTextView == textView){
        self.houseCopy.traffic = textView.text;
    }
    else if (self.houseLiftTextView == textView){
        self.houseCopy.surroundings = textView.text;
    }
    else if (self.houseCommentTextView == textView){
        self.houseCopy.remarks = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.titleTextView == textView) {
            [self.houseDescriptionTextView becomeFirstResponder];
        }
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
            [self.houseCommentTextView becomeFirstResponder];
        }
        else if (self.houseCommentTextView == textView){
            [self.houseCommentTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - *** TextView Notification Selector ***
- (void)textViewTextDidChanged:(NSNotification*)notify
{
    UITextView* textView = notify.object;
    NSInteger length = textView.text.length;
    BOOL valid = YES;
    BOOL change = NO;

    if(textView == self.titleTextView){
        valid = [self limitTextViewTextLengthMin:5 max:20 textView:textView warningText:@"请输入5-20个字"];
               self.houseCopy.title = textView.text;
        //change = ![self.houseCopy.title isEqualToString:self.house.title];
        if (!valid) {
            self.validFlag &= PRTValidStateTitle;
        }
        else{
            self.validFlag |= ~ PRTValidStateTitle;
        }
        
    }
    
    if (self.houseDescriptionTextView == textView ){
       valid = [self limitTextViewTextLengthMin:0 max:250 textView:textView warningText:@"请输入0-250个字"];
        self.houseCopy.houseDescription = textView.text;
        if (!valid) {
            self.validFlag &= PRTValidStateDescription;
        }
        else{
            self.validFlag |= ~ PRTValidStateDescription;
        }
    }
    else if (self.houseLocationTextView == textView){
        valid = [self limitTextViewTextLengthMin:0 max:250 textView:textView warningText:@"请输入0-250个字"];
        self.houseCopy.position = textView.text;
        if (!valid) {
            self.validFlag &= PRTValidStatePosition;
        }
        else{
            self.validFlag |= ~ PRTValidStatePosition;
        }
    }
    else if (self.houseTrafficTextView == textView){
        valid = [self limitTextViewTextLengthMin:0 max:250 textView:textView warningText:@"请输入0-250个字"];
        self.houseCopy.traffic = textView.text;
        if (!valid) {
            self.validFlag &= PRTValidStateTraffic;
        }else{
             self.validFlag |= ~ PRTValidStateTraffic;
        }
    }
    else if (self.houseLiftTextView == textView){
        valid = [self limitTextViewTextLengthMin:0 max:250 textView:textView warningText:@"请输入0-250个字"];
        self.houseCopy.surroundings = textView.text;
        if (!valid) {
            self.validFlag &= PRTValidStateSurroundings;
        }{
             self.validFlag |= ~ PRTValidStateSurroundings;
        }
    }
    else if (self.houseCommentTextView == textView){
        valid = [self limitTextViewTextLengthMin:0 max:250 textView:textView warningText:@"请输入0-250个字"];
        self.houseCopy.remarks = textView.text;
        if (!valid) {
            self.validFlag &= PRTValidStateRemarks;
        }
        else{
             self.validFlag |= ~ PRTValidStateRemarks;
        }
    }

    change = ![self.house isEqualToHouse:self.houseCopy];
    BOOL validTest = (self.validFlag & PRTValidStateNormal) == PRTValidStateNormal;
    if (change && validTest) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - *** Keyboard Notification Selector ***
- (void)keyboardDidShow:(NSNotification*)notification
{
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y ;
    //NSLog(@"keyboarTop %f",keyboardTop);
    //NSLog(@"height %f",self.view.bounds.size.height - keyboardRect.size.height);
    //CGRect newScrollViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, keyboardTop);
    self.keyboardHeight = keyboardRect.size.height;
    self.contentViewBottomConstraint.constant = keyboardRect.size.height + self.contentOffset;
    //[self.scrollView updateConstraintsIfNeeded];
    [self.scrollView layoutIfNeeded];
    //self.scrollViewConstraint.constant = keyboardRect.size.height;
    //self.scrollView.frame = newScrollViewFrame;
    
}

- (void)keyboardWillHide:(NSNotification*)notification
{
//    self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    CGRect rect = self.titleTextView.frame;
    rect.origin.y -= 15;
    [self.scrollView scrollRectToVisible:rect animated:YES];
    
}

- (void)keyboardDidHide
{
    self.contentViewBottomConstraint.constant = self.contentOffset;
    
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
