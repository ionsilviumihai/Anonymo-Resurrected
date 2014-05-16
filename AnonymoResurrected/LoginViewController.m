//
//  ViewController.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "LoginViewController.h"
#import "AppModel.h"




@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"]) {
        self.userTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    }
    
    

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginUserPressed:(id)sender {
    
    AppModel *sharedModel = [AppModel sharedModel];
    
    sharedModel.usersFromServer = nil;

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
        [sharedModel sendGetRequestWithRelativeURL:nil
                                              data:nil
                                            succes:^(NSHTTPURLResponse *httpRequest, id response)
        {
            for (NSDictionary* userInfo in response)
            {
                [sharedModel.usersFromServer addObject:userInfo];
                
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
                        [self loginUserWasSuccessful];
                    }
                }
            }
            if (!areUserAndPasswordValide) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication error" message:@"Email/Password combination is not valid." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alert show];
            }
        }
                                             error:^(NSHTTPURLResponse *httpRequest)
        {
                    NSLog(@"S-a primit eroarea: %ld", (long)[httpRequest statusCode]);
        }
         ];
    }
}

- (IBAction)loginWithTwitterPressed:(id)sender
{
}

- (IBAction)loginWithFacebookPressed:(id)sender
{
    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
    //[self.view addSubview:loginView];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    [appDelegate setDelegate:self];
    [appDelegate openSessionWithAllowLoginUI:YES];
}

- (IBAction)loginWithGooglePlusPressed:(id)sender
{
}

#pragma mark TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return  YES;
}

#pragma Observers Handlers

-(void)loginUserWasSuccessful
{
    [self performSegueWithIdentifier:@"PresentMainTabController" sender:self];
}


@end
