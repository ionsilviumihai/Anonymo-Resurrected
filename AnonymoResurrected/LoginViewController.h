//
//  ViewController.h
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginUserPressed:(id)sender;
- (IBAction)loginWithTwitterPressed:(id)sender;
- (IBAction)loginWithFacebookPressed:(id)sender;
- (IBAction)loginWithGooglePlusPressed:(id)sender;

@end
