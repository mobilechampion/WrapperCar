//
//  EmailFormControllerViewController.m
//  HeartCMS
//
//  Created by Nguyen Thanh Hung on 10/2/14.
//  Copyright (c) 2014 NguyenHung. All rights reserved.
//

#import "EmailFormControllerViewController.h"
#import <MessageUI/MessageUI.h>
#import "TextFieldTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "ButtonTableViewCell.h"

@interface EmailFormControllerViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *activeField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *emailTextField;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextView *enquiryTextView;


@end

@implementation EmailFormControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    
    [self.tableView setBackgroundView:nil];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 3) {
        return 70;
    }
    
    return 102;
}

#define tCancel  999

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tblCell = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
            cell.nameTextField.text = @"NAME";
            cell.textField.delegate = self;
            self.nameTextField = cell.textField;
            tblCell = cell;
        }
            break;
            
        case 1:
        {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
            cell.nameTextField.text = @"E-MAIL";
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textField.delegate = self;
            self.emailTextField = cell.textField;
            tblCell = cell;
        }
            break;
            
            
        case 2:
        {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldTableViewCell" forIndexPath:indexPath];
            cell.nameTextField.text = @"PHONE NUMBER";
            cell.textField.delegate = self;
            self.phoneTextField = cell.textField;
            cell.textField.keyboardType = UIKeyboardTypeNamePhonePad;
            tblCell = cell;
        }
            break;
            
        case 3:
        {
            TextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextViewTableViewCell" forIndexPath:indexPath];
            cell.nameLabel.text = @"ENQUIRY";
            self.enquiryTextView = cell.textView;
            cell.textView.delegate = self;
            
            
            cell.textView.layer.masksToBounds = YES;
            cell.textView.layer.cornerRadius = 8;
            
            tblCell = cell;
        }
            break;
            
        case 4:{
            ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell" forIndexPath:indexPath];
            
            cell.button.layer.masksToBounds = YES;
            cell.button.layer.cornerRadius = 8;
            [cell.button setTitle:@"SUBMIT" forState:UIControlStateNormal];
            
            tblCell = cell;
        }
            break;
            
        default:
        {
            ButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonTableViewCell" forIndexPath:indexPath];
            
            cell.button.layer.masksToBounds = YES;
            cell.button.layer.cornerRadius = 8;
            [cell.button setTitle:@"CANCEL" forState:UIControlStateNormal];
            [cell.button setBackgroundColor:[UIColor grayColor]];
            cell.button.tag = tCancel;
            tblCell = cell;
        }
            break;
    }
    
    tblCell.backgroundView = nil;
    tblCell.backgroundColor = [UIColor clearColor];
    
    return tblCell;
}


#pragma mark -

#pragma mark - UITextFieldDelegate

-( BOOL )textFieldShouldReturn:( UITextField *)textField{
    [textField resignFirstResponder ];
    return YES ;
}

- ( BOOL )textFieldShouldBeginEditing:( UITextField *)textField
{
    _activeField = textField;
    return YES ;
}
- ( void )textFieldDidEndEditing:( UITextField *)textField
{
    _activeField = nil ;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    self.activeField = textView;
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    _activeField = nil;
    
    return YES;
}

#pragma mark - Keyboard Notification

- ( void )registerForKeyboardNotifications
{
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (keyboardWasShown:) name : UIKeyboardWillShowNotification object : nil ];
    [[ NSNotificationCenter defaultCenter ] addObserver : self selector : @selector (keyboardWillBeHidden:) name : UIKeyboardWillHideNotification object : nil ];
}

- ( void ) unregisterForKeyboardNotifications
{
    [[ NSNotificationCenter defaultCenter ] removeObserver : self name : UIKeyboardWillShowNotification object : nil ];
    [[ NSNotificationCenter defaultCenter ] removeObserver : self name : UIKeyboardWillHideNotification object : nil ];
}

// Called when the UIKeyboardDidShowNotification is sent.
- ( void )keyboardWasShown:( NSNotification *)aNotification
{
    NSDictionary * info = [aNotification userInfo ];
    CGSize kbSize = [[info objectForKey : UIKeyboardFrameBeginUserInfoKey ] CGRectValue ]. size ;
    
    
    CGFloat min = MIN (kbSize. width , kbSize. height );
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, min, 0.0);
    _tableView . contentInset = contentInsets;
    _tableView . scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self . tableView . frame ;
    aRect. size . height -= min;
    if (! CGRectContainsPoint (aRect, _activeField . frame . origin ) ) {
        [ self . tableView scrollRectToVisible : _activeField . frame animated : YES ];
    } else if ([_activeField isKindOfClass:[UITextView class]]) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- ( void )keyboardWillBeHidden:( NSNotification *)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero ;
    _tableView . contentInset = contentInsets;
    _tableView . scrollIndicatorInsets = contentInsets;
}

- ( void )viewDidLayoutSubviews
{
    _tableView . contentSize = self . view . frame . size ;
}


- (IBAction)submitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([(UIButton *)sender tag] == tCancel) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    NSString *name = _nameTextField.text;
    
    NSString *email = _emailTextField.text;
    
    NSString *phone = _phoneTextField.text;
    
    NSString *enquiry = _enquiryTextView.text;
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    [picker setToRecipients:@[@"wrapapp@heartcms.com"]];

    [picker setSubject:@"I Have one request"];
    picker.mailComposeDelegate = self;
    
    
    
    NSString *emailBody = [NSString stringWithFormat:@"Hey,\nMy Name is: %@\nEmail: %@\nPhone Number: %@, ENQUIRY: %@", name, email, phone, enquiry];
    [picker setMessageBody:emailBody isHTML:NO];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    if (result == MFMailComposeResultSent || result == MFMailComposeResultSaved) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
