//
//  ViewController.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpRequests.h"
#import "AppModel.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"]) {
        self.userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUserPressed:(id)sender {
    AppModel *sharedModel = [AppModel sharedModel];
    
    __block BOOL areUserAndPasswordValide = NO;
    
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if ([self.userTextField.text isEqualToString:@""] && [self.passwordTextField.text isEqualToString:@""])  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entry error"
                                                        message:@"You did not provide any details for authetification"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }
    else
        if([self.userTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Entry error"
                                                            message:@"Please complete all fields."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    else
    {
        //luam toti userii din baza de date
        [HttpRequests getAllUserssuccess:^(id data) {
            for (NSDictionary* userInfo in data)
            {
                NSLog(@"%@", userInfo);
                [sharedModel.users addObject:userInfo];
                
                if ([self.userTextField.text isEqualToString:[userInfo objectForKey:@"name"]])
                {
                    if([self.passwordTextField.text isEqualToString:[userInfo objectForKey:@"password"]])
                    {
                        NSLog(@"Userul cu id: %@ s-a logat!", [userInfo objectForKey:@"id"]);
                        [[NSUserDefaults standardUserDefaults] setObject:self.userTextField.text forKey:@"userUsername"];
                        [[NSUserDefaults standardUserDefaults] setObject:userInfo[@"id"] forKey:@"userID"];
                        
                        [sharedModel.userLoggedIn setObject:userInfo[@"email"] forKey:@"email"];
                        [sharedModel.userLoggedIn setObject:userInfo[@"id"] forKey:@"id"];
                        [sharedModel.userLoggedIn setObject:userInfo[@"name"] forKey:@"name"];
                        [sharedModel.userLoggedIn setObject:userInfo[@"password"] forKey:@"password"];
                        NSLog(@"S-a copiat in shared dicitonary: %@", sharedModel.userLoggedIn);
                        areUserAndPasswordValide = YES;
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!areUserAndPasswordValide) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication error" message:@"Email/Password combination is not valid." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                }
            });
            
        }];

    }

}

- (IBAction)loginWithTwitterPressed:(id)sender {
}

- (IBAction)loginWithFacebookPressed:(id)sender {
}

- (IBAction)loginWithGooglePlusPressed:(id)sender {
}

#pragma mark TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}
@end
