//
//  UserRegistrationTableViewController.h
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserRegistrationTableViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField  *locationCityTextField;
@property (weak, nonatomic) IBOutlet UITextField  *mailTextField;
@property (weak, nonatomic) IBOutlet UITextField  *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField  *confirmPasswordTextField;

- (IBAction)registerUser:(UIButton *)sender;

@end
