//
//  AppDelegate.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "AppDelegate.h"
#import "Utility.h"
#import "Constants.h"
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h";

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@implementation AppDelegate
NSString *const FBSessionStateChangedNotification =
@"com.sparktech.AnonymoResurrected:FBSessionStateChangedNotification";
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
//    {
//        [[UINavigationBar appearance] setTintColor:[UIColor colorWith256RBGAArray:kDarkestGrayColor]];
//        [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWith256RBGAArray:kOrangeColor]];
//    }
//    else
//    {
//        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
//        [[UINavigationBar appearance] setTintColor:[UIColor colorWith256RBGAArray:kOrangeColor]];
//        
//        [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
//        [[UITabBar appearance] setBarTintColor:[UIColor colorWith256RBGAArray:kDarkestGrayColor]];
//        [[UITabBar appearance] setTintColor:[UIColor colorWith256RBGAArray:kOrangeColor]];
//        
//        self.window.tintColor = [UIColor colorWith256RBGAArray:kOrangeColor];
//        self.window.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
//    }
//
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Facebook Methods
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                [[FBRequest requestForGraphPath:@"me"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if(!error)
                    {
                        [FBSession activeSession].accessTokenData.accessToken;
                        NSString* firstName = [result objectForKey:@"first_name"];
                        NSString* lastName = [result objectForKey:@"last_name"];
                        
                        NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
                        NSString* username = [NSString stringWithFormat:@"%@_%@",firstName,lastName];
                        [user setValue:username forKey:@"Username"];
                        
                        NSString* facebookID = [result objectForKey:@"id"];
                        [user setValue:facebookID forKey:@"FacebookID"];
                        
                        NSString* email = [result objectForKey:@"email"];
                        [user setValue:email forKey:@"Email"];
                        [user synchronize]; //pentru a face modificarile
                        NSLog(@"%@ %@", firstName, lastName);
                        [self.delegate LoginWasSuccesfull:YES];
                    }
                }];
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    return [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"email"]
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

/*
* If we have a valid session at the time of openURL call, we handle
* Facebook transitions by passing the url argument to handleOpenURL
*/
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

//metoda logout

-(void)logOutSession
{
    [[FBSession activeSession]closeAndClearTokenInformation];
    LoginViewController* loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController* loginVCNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    //[self presentViewController:loginVCNav animated:NO completion:nil];
    
}



@end
