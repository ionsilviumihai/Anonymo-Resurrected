//
//  SocialViewController.m
//  Torah
//
//  Created by Radu-Tudor Ionescu on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+PercentEscapes.h"
#import "Constants.h"
#import "AppModel.h"
#import "Utility.h"
#import "SocialViewController.h"


#define kFacebookAppID @"180391098808790"
#define kGooglePlusClientId @"867987844829-ag1mth31seigpojkehegmm6bdgnm1ac7.apps.googleusercontent.com"

@interface SocialViewController ()

@property (nonatomic) int socialActionType;

@property (nonatomic, strong) ACAccountStore *twitterAccountStore;
@property (nonatomic, strong) NSArray *twitterAccounts;

- (void)refreshTwitterAccountsForNotification:(NSNotification *)notification;

@end

@implementation SocialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Facebook", @"Twitter", @"Google Plus", @"Mail", nil];
    self.shareActionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    self.shareActionSheet.cancelButtonIndex = 4;
    self.shareActionSheet.tag = kSocialActionTypeShare;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTwitterAccountsForNotification:)
                                                 name:ACAccountStoreDidChangeNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [FBSettings setDefaultAppID:kFacebookAppID];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateSocialView
{
    // should be implemented by subclasses
}

- (void)sendAccessToken:(NSString *)accessToken toServerAndLoginForSocialNetworkName:(NSString *)socialNetworkName;
{
    [self sendAccessToken:accessToken accessSecretKey:nil toServerAndLoginForSocialNetworkName:socialNetworkName];
}

- (void)sendAccessToken:(NSString *)accessToken accessSecretKey:(NSString *)accessSecretKey toServerAndLoginForSocialNetworkName:(NSString *)socialNetworkName
{
    NSLog(@"Login user with social network : %@\n\tToken : %@\n\tSecret : %@", socialNetworkName, accessToken, accessSecretKey);
    [self.activityIndicator startAnimating];
   
    NSString *socialNetworkDisplayName;
    if ([socialNetworkName isEqualToString:@"facebook"]) socialNetworkDisplayName = @"Facebook";
    else if ([socialNetworkName isEqualToString:@"google"]) socialNetworkDisplayName = @"Google Plus";
    else if ([socialNetworkName isEqualToString:@"twitter"]) socialNetworkDisplayName = @"Twitter";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPostSocialLoginURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:90.0];
    
    NSMutableDictionary *requestParams = [@{@"account_type" : socialNetworkName, @"access_token": accessToken} mutableCopy];
    if ([socialNetworkName isEqualToString:@"twitter"])
    {
        NSString *mailAddress = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterMailAddress"];

        [requestParams setObject:mailAddress forKey:@"email"];
        [requestParams setObject:accessSecretKey forKey:@"access_token_secret"];
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:NULL];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *postString = [NSString stringWithFormat:@"{\"user\":%@}", jsonString];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"Login POST String : %@",postString);
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setValue:[NSString stringWithFormat:@"%d",[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *requestQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:requestQueue
                           completionHandler:^(NSURLResponse *postResponse, NSData *data, NSError *error) {
                               
                               BOOL authenticationFailed = YES;
                               
                               NSLog(@"Error : %@",[error localizedDescription]);
                               NSLog(@"Status Code :  %d",[(NSHTTPURLResponse *)postResponse statusCode]);
                               
                               if (!error)
                               {
                                   if (data)
                                   {
                                       id response = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:NSJSONReadingAllowFragments
                                                                                       error:nil];
                                       
                                       NSLog(@"Server response: %@",response);
                                       
                                       NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)postResponse;
                                       if ([httpResponse statusCode] != kHTTPStatusCodeCreateSuccess)
                                       {
                                           NSLog(@"Authentication failed");
                                           authenticationFailed = NO;
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               UIAlertView *failedAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed to Sign In with %@", socialNetworkDisplayName]
                                                                                                         message:@"Please make sure that you have an Internet connection and try again."
                                                                                                        delegate:self
                                                                                               cancelButtonTitle:@"Ok"
                                                                                               otherButtonTitles:nil];
                                               failedAlertView.tag = kAlertCodeRequestError;
                                               [failedAlertView show];
                                           });
                                       }
                                       else if ([response isKindOfClass:[NSDictionary class]])
                                       {
                                           authenticationFailed = NO;
                                           
                                           NSDictionary *user = response;
                                           NSString *token = [user objectForKey:@"auth_token"];
                                           NSNumber *userID = [user objectForKey:@"user_id"];

                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"Welocome to iPi!"
                                                                                                          message:[NSString stringWithFormat:@"You have successfully signed in with %@.", socialNetworkDisplayName]
                                                                                                         delegate:self
                                                                                                cancelButtonTitle:@"Ok"
                                                                                                otherButtonTitles:nil];
                                               successAlertView.tag = kAlertCodeSuccess;
                                               [successAlertView show];
                                           });
                                           
                                           [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
                                           [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"userID"];
                                           [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoShareOnFacebook"];
                                           [[NSUserDefaults standardUserDefaults] setInteger:kNotificationFrequencyInstant forKey:@"notificationFrequency"];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           
                                           NSLog(@"User did login with token : %@",token);
                                           [[AppModel sharedModel] requestSettingsFromServer];
                                       }
                                   }
                               }
                               if (authenticationFailed)
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       UIAlertView *failedAlertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Failed to Sign In with %@", socialNetworkDisplayName]
                                                                                                 message:@"Please make sure that you have an Internet connection and try again."
                                                                                                delegate:self
                                                                                       cancelButtonTitle:@"Ok"
                                                                                       otherButtonTitles:nil];
                                       failedAlertView.tag = kAlertCodeRequestError;
                                       [failedAlertView show];
                                   });
                               }
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   [self.activityIndicator stopAnimating];
                               });
                           }];
}

#pragma mark Getters and Setters

- (ACAccountStore *)twitterAccountStore
{
    if (!_twitterAccountStore)
    {
        _twitterAccountStore = [[ACAccountStore alloc] init];
    }
    return _twitterAccountStore;
}

- (TWAPIManager *)twitterAPIManager
{
    if (!_twitterAPIManager)
    {
        _twitterAPIManager = [[TWAPIManager alloc] init];
    }
    return _twitterAPIManager;
}

#pragma mark Action sheet delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kSocialActionTypeShare)
    {
        if (self.isViewVisible)
        {
            if (buttonIndex == kShareOptionFacebook)
            {
                [self shareOnFacebook];
            }
            else if (buttonIndex == kShareOptionTwitter)
            {
                [self shareOnTwitter];
            }
            else if (buttonIndex == kShareOptionGooglePlus)
            {
                [self shareOnGooglePlus];
            }
            else if (buttonIndex == kShareOptionMail)
            {
                [self shareViaMail];
            }
        }
    }
    else if (actionSheet.tag == kSocialActionTypeLogin)
    {
        if (buttonIndex != actionSheet.cancelButtonIndex)
        {
            [self.activityIndicator startAnimating];
            
            [self.twitterAPIManager performReverseAuthForAccount:self.twitterAccounts[buttonIndex]
                                                     withHandler:^(NSData *responseData, NSError *error) {
                                                         
                                                         if (responseData)
                                                         {
                                                             NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                             
                                                             NSLog(@"Reverse Auth process returned response: %@", responseString);
                                                             
                                                             NSArray *paramsComponents = [responseString componentsSeparatedByString:@"&"];
                                                             NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:paramsComponents.count];
                                                             
                                                             for (NSString *param in paramsComponents)
                                                             {
                                                                 NSArray *paramComponents = [param componentsSeparatedByString:@"="];
                                                                 [params setObject:[paramComponents lastObject] forKey:[paramComponents firstObject]];
                                                             }
                                                             
                                                             params[@"accountIndex"] = @(buttonIndex);
                                                             
                                                             [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"twitterAuthParams"];
                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                             
                                                             NSString *accessToken = params[@"oauth_token"];
                                                             NSString *accessSecretKey = params[@"oauth_token_secret"];
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{

                                                                 [self sendAccessToken:accessToken accessSecretKey:accessSecretKey toServerAndLoginForSocialNetworkName:@"twitter"];
                                                             });
                                                         }
                                                         else
                                                         {
                                                             NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                                                         }
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                             [self.activityIndicator stopAnimating];
                                                         });
                                                     }];
        }
    }
    else if (actionSheet.tag == kSocialActionTypeFriends)
    {
        if (buttonIndex != actionSheet.cancelButtonIndex)
        {
            [self.activityIndicator startAnimating];
            
            [self.twitterAPIManager performReverseAuthForAccount:self.twitterAccounts[buttonIndex]
                                                     withHandler:^(NSData *responseData, NSError *error) {
                                                         
                                                         if (responseData)
                                                         {
                                                             NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                             
                                                             NSLog(@"Reverse Auth process returned response: %@", responseString);
                                                             
                                                             NSArray *paramsComponents = [responseString componentsSeparatedByString:@"&"];
                                                             NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:paramsComponents.count];
                                                             
                                                             for (NSString *param in paramsComponents)
                                                             {
                                                                 NSArray *paramComponents = [param componentsSeparatedByString:@"="];
                                                                 [params setObject:[paramComponents lastObject] forKey:[paramComponents firstObject]];
                                                             }
                                                             
                                                             [[NSUserDefaults standardUserDefaults] setObject:params forKey:@"twitterAuthParams"];
                                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                                             
                                                             
                                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                                 
                                                                 [self requestTwitterFollowers];
                                                             });
                                                         }
                                                         else
                                                         {
                                                             NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
                                                         }
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             [self.activityIndicator stopAnimating];
                                                         });
                                                     }];
        }
    }
}

#pragma mark Facebook

- (void)loginWithFacebook
{
    if (FBSession.activeSession.isOpen)
    {
        NSLog(@"Facebook session is opened");
        [self sendAccessToken:FBSession.activeSession.accessTokenData.accessToken toServerAndLoginForSocialNetworkName:@"facebook"];
    }
    else 
    {
        NSLog(@"Facebook session is NOT opened");
        
        // Use this for in-app Web View login
        /*
        FBSession *session = [[FBSession alloc] initWithPermissions:@[@"publish_stream"]];
        [FBSession setActiveSession:session];
        [session openWithBehavior:FBSessionLoginBehaviorForcingWebView
                completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        */
        // Use this for OS > Facebook > Safari login
        [FBSession openActiveSessionWithPublishPermissions:@[@"email", @"read_stream", @"user_about_me", @"user_birthday", @"user_relationship_details", @"user_relationships", @"user_friends"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             NSLog(@"Facebook login error : %@", [error localizedDescription]);
             if (error) 
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                     [alert show];
                 });
             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self updateSocialView];
                     [self sendAccessToken:FBSession.activeSession.accessTokenData.accessToken toServerAndLoginForSocialNetworkName:@"facebook"];
                 });
             }
         }];
    }    
}

- (void)logoutFromFacebook
{
    [FBSession.activeSession closeAndClearTokenInformation];
    [self updateSocialView];
}

- (void)shareOnFacebook
{
    if (FBSession.activeSession.isOpen && [FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        NSLog(@"Facebook session is opened");
        
        [self presentFacebookFeedDialog];
    }
    else
    {
        NSLog(@"Facebook session is NOT opened");
        
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if (error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed"
                                                                     message:@"Please make sure you have access to the internet and try again."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                     [alert show];
                 });
             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self updateSocialView];
                     [self presentFacebookFeedDialog];
                 });
             }
         }];
    }
}

- (void)presentFacebookFeedDialog
{
    NSLog(@"Should present facekook dialog!");
    
    if ([self isKindOfClass:[ItemViewController class]])
    {
        NSDictionary *item = ((ItemViewController *)self).item;
        NSNumber *itemID = item[@"id"];
        NSString *title = item[@"title"];
        NSString *imageURLString = item[@"image_url"];
        
        NSString *itemShareText = [NSString stringWithFormat:@"Hey! Check out %@ on iPi.", title];
        NSString *itemWebURL = [NSString stringWithFormat:kShareItemWebURLformat, itemID];
        
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       // title, @"name",
                                       // caption, @"caption",
                                       itemShareText, @"description",
                                       itemWebURL, @"link",
                                       imageURLString, @"picture",
                                       nil];
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:FBSession.activeSession
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      
                                                      if (error)
                                                      {
                                                          NSLog(@"Error publishing on facebook");
                                                      }
                                                      else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted)
                                                          {
                                                              NSLog(@"User canceled publishing on facebook");
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"User did publish on facebook");
                                                          }
                                                      }
                                                  }];
    }
    else if ([self isKindOfClass:[ItemsViewController class]])
    {
        NSDictionary *collection = ((ItemsViewController *)self).collection;
     
        NSMutableDictionary *params = nil;
        if (collection)
        {
            NSNumber *collectionID = collection[@"id"];
            NSString *title = collection[@"name"];
            NSNumber *collectionOwnerID = collection[@"user_id"];

            NSString *collectionShareText;
            
            NSNumber *authUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            if ([authUserID isEqualToNumber:collectionOwnerID])
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out my %@ collection on iPi.", title];
            }
            else
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out this %@ collection on iPi.", title];
            }
            NSString *collectionWebURL = [NSString stringWithFormat:kShareCollectionWebURLformat, collectionID];
            
            // Put together the dialog parameters
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      title, @"name",
                      // caption, @"caption",
                      collectionShareText, @"description",
                      collectionWebURL, @"link",
                      //imageURLString, @"picture",
                      nil];
        }
        else
        {
            NSNumber *userID = ((ItemsViewController *)self).userID;
            if (!userID) userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];

            NSString *title = @"My wishlist";
            NSString *wishlistWebURL = [NSString stringWithFormat:kShareWishlistWebURLformat, userID];
            NSString *wishlistShareText = @"Hey! Check out my wishlist on iPi.";

            // Put together the dialog parameters
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      title, @"name",
                      // caption, @"caption",
                      wishlistShareText, @"description",
                      wishlistWebURL, @"link",
                      //imageURLString, @"picture",
                      nil];
        }
        
        // Invoke the dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:FBSession.activeSession
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      
                                                      if (error)
                                                      {
                                                          NSLog(@"Error publishing on facebook");
                                                      }
                                                      else
                                                      {
                                                          if (result == FBWebDialogResultDialogNotCompleted)
                                                          {
                                                              NSLog(@"User canceled publishing on facebook");
                                                          }
                                                          else
                                                          {
                                                              NSLog(@"User did publish on facebook");
                                                          }
                                                      }
                                                  }];
    }
}

- (void)autoShareOnFacebook
{
    if (FBSession.activeSession.isOpen && [FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        NSLog(@"Facebook session is opened");
        
        AppModel *sharedModel = [AppModel sharedModel];
        NSMutableDictionary *item = sharedModel.createdItem;
        // if ([item[@"postedOnFacebook"] boolValue] == NO)
        {
            [item setObject:@YES forKey:@"postedOnFacebook"];
            
            NSNumber *itemID = item[@"id"];
            NSString *title = item[@"title"];
            NSString *imageURLString = item[@"image_url"];
            
            NSString *itemShareText = [NSString stringWithFormat:@"Hey! Check out %@ on iPi.", title];
            NSString *itemWebURL = [NSString stringWithFormat:kShareItemWebURLformat, itemID];
            
            // Put together the dialog parameters
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           // title, @"name",
                                           // caption, @"caption",
                                           itemShareText, @"description",
                                           itemWebURL, @"link",
                                           imageURLString, @"picture",
                                           nil];
            
            // Share without dialog
            [FBRequestConnection startWithGraphPath:@"me/feed"
                                         parameters:params
                                         HTTPMethod:@"POST"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      
                                      if (error)
                                      {
                                          NSLog(@"Error publishing on facebook");
                                      }
                                      else
                                      {
                                          NSLog(@"Published item automatically on facebook");
                                      }
            }];
        }
    }
    else
    {
        NSLog(@"Facebook session is NOT opened");
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if (error)
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed"
                                                                 message:@"Please make sure you have access to the internet and try again."
                                                                delegate:nil
                                                       cancelButtonTitle:@"Ok"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self updateSocialView];
                 });
                 
                 AppModel *sharedModel = [AppModel sharedModel];
                 NSMutableDictionary *item = sharedModel.createdItem;
                 // if ([item[@"postedOnFacebook"] boolValue] == NO)
                 {
                     [item setObject:@YES forKey:@"postedOnFacebook"];

                     NSNumber *itemID = item[@"id"];
                     NSString *title = item[@"title"];
                     NSString *imageURLString = item[@"image_url"];
                     
                     NSString *itemShareText = [NSString stringWithFormat:@"Hey! Check out %@ on iPi.", title];
                     NSString *itemWebURL = [NSString stringWithFormat:kShareItemWebURLformat, itemID];
                     
                     // Put together the dialog parameters
                     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                    // title, @"name",
                                                    // caption, @"caption",
                                                    itemShareText, @"description",
                                                    itemWebURL, @"link",
                                                    imageURLString, @"picture",
                                                    nil];
                     
                     // Share without dialog
                     [FBRequestConnection startWithGraphPath:@"me/feed"
                                                  parameters:params
                                                  HTTPMethod:@"POST"
                                           completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                               
                                               if (error)
                                               {
                                                   NSLog(@"Error publishing on facebook");
                                               }
                                               else
                                               {
                                                   NSLog(@"Published item automatically on facebook");
                                               }
                                           }];
                 }
             }
         }];
    }
}

- (void)initiateRequestForFacebookFriends
{
    if (FBSession.activeSession.isOpen && [FBSession.activeSession.permissions indexOfObject:@"user_friends"] == NSNotFound)
    {
        NSLog(@"Facebook session is opened");
        
        [self requestFacebookFriends];
    }
    else
    {
        NSLog(@"Facebook session is NOT opened");
        [FBSession openActiveSessionWithPublishPermissions:@[@"user_friends"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if (error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed"
                                                                     message:@"Please make sure you have access to the internet and try again."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                     [alert show];
                 });
             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self requestFacebookFriends];
                 });
             }
         }];
    }
}

- (void)requestFacebookFriends
{
    [self.activityIndicator startAnimating];
    
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              
                              if (error)
                              {
                                  NSLog(@"Error: %@", [error description]);
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Request Facebook Friends"
                                                                                      message:@"Please enable iPi to use your Facebook account and make sure that you are connected to the Internet."
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"Ok"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                      
                                      [self.activityIndicator stopAnimating];
                                  });
                              }
                              else
                              {
                                  AppModel *sharedModel = [AppModel sharedModel];
                                  sharedModel.facebookFriends = [result[@"data"] mutableCopy];
                                  
                                  for (int i = 0; i < sharedModel.facebookFriends.count; i++)
                                  {
                                      NSMutableDictionary *friend = [sharedModel.facebookFriends[i] mutableCopy];
                                      
                                      friend[@"isSocialNetworkFriend"] = @YES;
                                      friend[@"provider_uid"] = friend[@"id"];
                                      friend[@"display_name"] = friend[@"name"];
                                      friend[@"image_url"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=100&width=100", friend[@"id"]];
                                      
                                      [friend removeObjectForKey:@"id"];
                                      [friend removeObjectForKey:@"name"];
                                      
                                      [sharedModel.facebookFriends replaceObjectAtIndex:i withObject:friend];
                                  }
                                  
                                  // NSLog(@"Facebook friends: %@", sharedModel.facebookFriends);
                              }
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  [self updateSocialView];
                              });
                          }];
}

- (void)sendInvitationToFacebookFriend:(NSDictionary *)friend
{
    [self.activityIndicator startAnimating];
 
    if (FBSession.activeSession.isOpen && [FBSession.activeSession.permissions indexOfObject:@"publish_stream"] == NSNotFound)
    {
        NSLog(@"Facebook session is opened");
        
        [self inviteFacebookFriend:friend];
    }
    else
    {
        NSLog(@"Facebook session is NOT opened");
        [FBSession openActiveSessionWithPublishPermissions:@[@"publish_stream"]
                                           defaultAudience:FBSessionDefaultAudienceEveryone
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error)
         {
             if (error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Login Failed"
                                                                     message:@"Please make sure you have access to the internet and try again."
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Ok"
                                                           otherButtonTitles:nil];
                     [alert show];
                 });
             }
             else if (FB_ISSESSIONOPENWITHSTATE(status))
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self inviteFacebookFriend:friend];
                 });
             }
         }];
    }
}

- (void)inviteFacebookFriend:(NSDictionary *)friend
{
    NSDictionary *params = @{@"to" : friend[@"provider_uid"]};
    
    [FBWebDialogs presentRequestsDialogModallyWithSession:FBSession.activeSession
                                                  message:@"Hey! I'm using iPi and I think you should join in too!"
                                                    title:@"Join iPi"
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          NSLog(@"Invite error : %@", [error  localizedDescription]);
                                                          // NSLog(@"Response : %@", result);
                                                          
                                                          if (error)
                                                          {
                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Faild to Send Invitation"
                                                                                                              message:@"Please make sure you have access to the internet and try again."
                                                                                                             delegate:nil
                                                                                                    cancelButtonTitle:@"Ok"
                                                                                                    otherButtonTitles:nil];
                                                              [alert show];
                                                          }
                                                          else
                                                          {
                                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invitation Sent"
                                                                                                              message:[NSString stringWithFormat:@"Your friend %@ was invited to join iPi!", friend[@"display_name"]]
                                                                                                             delegate:nil
                                                                                                    cancelButtonTitle:@"Ok"
                                                                                                    otherButtonTitles:nil];
                                                              [alert show];
                                                          }
                                                          
                                                          [self.activityIndicator stopAnimating];
                                                      });
                                                  }];
}

#pragma mark Twitter

- (void)loginWithTwitter
{
    self.socialActionType = kSocialActionTypeLogin;
    [self refreshTwitterAccounts];
}

- (void)refreshTwitterAccountsForNotification:(NSNotification *)notification
{
    if (notification.object == self.twitterAccountStore) [self refreshTwitterAccounts];
}

- (void)refreshTwitterAccounts
{
    NSLog(@"Refreshing Twitter Accounts");
    
    if (![TWAPIManager hasAppKeys])
    {
        NSLog(@"Twitter Consumer Key and Secret are missing!");
    }
    else if (![TWAPIManager isLocalTwitterAccountAvailable])
    {
        UIAlertView *twitterLoginRequest = [[UIAlertView alloc] initWithTitle:@"Twitter Account Missing"
                                                                      message:@"Please add your Twitter account in your device Settings."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Ok"
                                                            otherButtonTitles:nil];
        [twitterLoginRequest show];
    }
    else
    {
        [self obtainAccessToAccountsWithBlock:^(BOOL granted) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (granted)
                {
                    NSLog(@"Twitter Accounts Access Granted");
                    
                    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a Twitter Account"
                                                                             delegate:self
                                                                    cancelButtonTitle:nil
                                                               destructiveButtonTitle:nil
                                                                    otherButtonTitles:nil];
                    
                    for (ACAccount *account in self.twitterAccounts)
                    {
                        [actionSheet addButtonWithTitle:account.username];
                    }
                    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
                    actionSheet.tag = self.socialActionType;
                    
                    if (self.tabBarController) [actionSheet showFromTabBar:self.tabBarController.tabBar];
                    else [actionSheet showInView:self.view];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Accounts Access Denied"
                                                                    message:@"This app needs to access your Twitter accounts in order to sign in with Twitter."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            });
        }];
    }
}

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL))block
{
    ACAccountType *twitterType = [self.twitterAccountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self.twitterAccountStore requestAccessToAccountsWithType:twitterType
                                                      options:NULL
                                                   completion:^(BOOL granted, NSError *error) {
                                                       
                                                       if (granted)
                                                       {
                                                           self.twitterAccounts = [self.twitterAccountStore accountsWithAccountType:twitterType];
                                                       }
                                                       
                                                       block(granted);
                                                   }];
}

- (void)shareOnTwitter
{
    if ([self isKindOfClass:[ItemViewController class]])
    {
        NSDictionary *item = ((ItemViewController *)self).item;
        NSNumber *itemID = item[@"id"];
        NSString *title = item[@"title"];
        NSString *imageURLString = item[@"image_url"];
        
        NSString *itemShareText = [NSString stringWithFormat:@"Hey! Check out %@ on iPi.", title];
        NSString *itemWebURL = [NSString stringWithFormat:kShareItemWebURLformat, itemID];
        
        AppModel *sharedModel = [AppModel sharedModel];
        NSData *imageData = sharedModel.images[imageURLString];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            SLComposeViewControllerCompletionHandler didShareBlock = ^(SLComposeViewControllerResult result) {
                if (result == SLComposeViewControllerResultCancelled)
                {
                    NSLog(@"Cancelled");
                }
                else
                {
                    NSLog(@"Done");
                }
                
                [composeController dismissViewControllerAnimated:YES completion:nil];
            };
            composeController.completionHandler = didShareBlock;
            
            composeController.initialText = itemShareText;
            [composeController addURL:[NSURL URLWithString:itemWebURL]];
            if (imageData) [composeController addImage:[UIImage imageWithData:imageData]];
            
            [self presentViewController:composeController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *twitterLoginRequest = [[UIAlertView alloc] initWithTitle:@"Twitter Account Missing"
                                                                          message:@"Please add your Twitter account in your device Settings."
                                                                         delegate:nil
                                                                cancelButtonTitle:@"Ok"
                                                                otherButtonTitles:nil];
            [twitterLoginRequest show];
        }
    }
    else if ([self isKindOfClass:[ItemsViewController class]])
    {
        NSDictionary *collection = ((ItemsViewController *)self).collection;
        if (collection)
        {
            NSNumber *collectionID = collection[@"id"];
            NSString *title = collection[@"name"];
            NSNumber *collectionOwnerID = collection[@"user_id"];
            
            NSString *collectionShareText;
            
            NSNumber *authUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            if ([authUserID isEqualToNumber:collectionOwnerID])
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out my %@ collection on iPi.", title];
            }
            else
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out this %@ collection on iPi.", title];
            }
            NSString *collectionWebURL = [NSString stringWithFormat:kShareCollectionWebURLformat, collectionID];
            
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                SLComposeViewControllerCompletionHandler didShareBlock = ^(SLComposeViewControllerResult result) {
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        NSLog(@"Cancelled");
                    }
                    else
                    {
                        NSLog(@"Done");
                    }
                    
                    [composeController dismissViewControllerAnimated:YES completion:nil];
                };
                composeController.completionHandler = didShareBlock;
                
                composeController.initialText = collectionShareText;
                [composeController addURL:[NSURL URLWithString:collectionWebURL]];
                
                [self presentViewController:composeController animated:YES completion:nil];
            }
            else
            {
                UIAlertView *twitterLoginAlert = [[UIAlertView alloc] initWithTitle:@"Twitter Account Missing"
                                                                            message:@"Please add your Twitter account in your device Settings."
                                                                            delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                [twitterLoginAlert show];
            }
        }
        else
        {
            NSNumber *userID = ((ItemsViewController *)self).userID;
            if (!userID) userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];

            NSString *wishlistWebURL = [NSString stringWithFormat:kShareWishlistWebURLformat, userID];
            NSString *wishlistShareText = @"Hey! Check out my wishlist on iPi.";
            
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                
                SLComposeViewControllerCompletionHandler didShareBlock = ^(SLComposeViewControllerResult result) {
                    if (result == SLComposeViewControllerResultCancelled)
                    {
                        NSLog(@"Cancelled");
                    }
                    else
                    {
                        NSLog(@"Done");
                    }
                    
                    [composeController dismissViewControllerAnimated:YES completion:nil];
                };
                composeController.completionHandler = didShareBlock;
                
                composeController.initialText = wishlistShareText;
                [composeController addURL:[NSURL URLWithString:wishlistWebURL]];
                
                [self presentViewController:composeController animated:YES completion:nil];
            }
            else
            {
                UIAlertView *twitterLoginAlert = [[UIAlertView alloc] initWithTitle:@"Twitter Account Missing"
                                                                            message:@"Please add your Twitter account in your device Settings."
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil];
                [twitterLoginAlert show];
            }

        }
    }
}

- (void)initiateRequestForTwitterFollowers
{
    NSDictionary *twitterAuthParams = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuthParams"];
    
    int accountIndex = [twitterAuthParams[@"accountIndex"] intValue];
    if (twitterAuthParams && self.twitterAccounts && self.twitterAccounts.count > accountIndex)
    {
        [self requestTwitterFollowers];
    }
    else
    {
        self.socialActionType = kSocialActionTypeFriends;
        [self refreshTwitterAccounts];
    }
}

- (void)requestTwitterFollowers
{
    [self.activityIndicator startAnimating];
    
    // URL for all friends
    // NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/friends/ids.json"];
    
    // URL for followers only
    NSURL *followersURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/followers/ids.json"];
    
    NSDictionary *twitterAuthParams = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuthParams"];
    NSLog(@"Twitter info : %@", twitterAuthParams);
    
    int accountIndex = [twitterAuthParams[@"accountIndex"] intValue];
    NSDictionary *params = @{@"screen_name" : twitterAuthParams[@"screen_name"]};
    
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                   requestMethod:SLRequestMethodGET
                                                             URL:followersURL
                                                      parameters:params];
    
    
    [twitterRequest setAccount:self.twitterAccounts[accountIndex]];
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
     
        NSLog(@"Error : %@", [error description]);
        NSLog(@"Status Code :  %d", [urlResponse statusCode]);

        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Request Twitter Followers"
                                                                message:@"Please enable iPi to use your Twitter account and make sure that you are connected to the Internet."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];

                [self.activityIndicator stopAnimating];
            });
        }
        else
        {
            id response = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:NSJSONReadingAllowFragments
                                                            error:nil];
            
            // NSLog(@"Response : %@", response);

            if ([response isKindOfClass:[NSDictionary class]])
            {
                NSArray *followersIDList = response[@"ids"];
                NSLog(@"Twitter follower IDs : %@", followersIDList);
                
                AppModel *sharedModel = [AppModel sharedModel];
                sharedModel.twitterFriends = [[NSMutableArray alloc] initWithCapacity:followersIDList.count];
                
                for (int i = 0; i < followersIDList.count; i = i + 100)
                {
                    int subsetSize = (i + 100 < followersIDList.count) ? 100 : followersIDList.count - i;
                    NSArray *followersIDSubsetList = [followersIDList objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(i, subsetSize)]];
                    
                    NSString *followersIDListString = [followersIDSubsetList componentsJoinedByString:@","];
                    
                    BOOL updateSocialView = (i + subsetSize >= followersIDList.count) ? YES : NO;
                    
                    [self twitterUsersInfoForIDList:followersIDListString
                                        fromAccount:self.twitterAccounts[accountIndex]
                                  updateSocialView:updateSocialView];
                }
            }
        }
    }];
}

- (void)twitterUsersInfoForIDList:(NSString *)usersIDListString fromAccount:(ACAccount *)account updateSocialView:(BOOL)updateSocialView
{
    NSURL *twitterUsersInfoURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/lookup.json"];
    NSDictionary *params = @{@"user_id" : usersIDListString};
    
    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                   requestMethod:SLRequestMethodPOST // instead of GET, for performance reasons
                                                             URL:twitterUsersInfoURL
                                                      parameters:params];
    
    [twitterRequest setAccount:account];
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSLog(@"Error : %@", [error description]);
        NSLog(@"Status Code :  %d", [urlResponse statusCode]);

        AppModel *sharedModel = [AppModel sharedModel];
        if (!error)
        {
            id response = [NSJSONSerialization JSONObjectWithData:responseData
                                                          options:NSJSONWritingPrettyPrinted|NSJSONReadingMutableContainers
                                                            error:nil];
            
            if ([response isKindOfClass:[NSArray class]])
            {
                for (NSDictionary *twitterFollower in response)
                {
                    NSMutableDictionary *follower = [@{@"provider_uid" : twitterFollower[@"id_str"],
                                                       @"display_name" : twitterFollower[@"name"],
                                                       @"screen_name" : twitterFollower[@"screen_name"],
                                                       @"image_url" : twitterFollower[@"profile_image_url_https"],
                                                       @"isSocialNetworkFriend" : @YES} mutableCopy];
                    
                    [sharedModel.twitterFriends addObject:follower];
                }
            }
        }
        
        if (updateSocialView)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"Twitter followers : %@", sharedModel.twitterFriends);

                [self updateSocialView];
            });
        }
    }];
}

- (void)sendDirectMessageToTwitterFollower:(NSDictionary *)follower
{
    NSDictionary *twitterAuthParams = [[NSUserDefaults standardUserDefaults] objectForKey:@"twitterAuthParams"];
    
    int accountIndex = [twitterAuthParams[@"accountIndex"] intValue];
    if (twitterAuthParams && self.twitterAccounts && self.twitterAccounts.count > accountIndex)
    {
        [self.activityIndicator startAnimating];
        
        NSURL *directMessageURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/direct_messages/new.json"];
        
        NSLog(@"Twitter info : %@", twitterAuthParams);
        NSDictionary *params = @{@"user_id" : follower[@"provider_uid"],
                                 @"screen_name" : follower[@"screen_name"],
                                 @"text" : [NSString stringWithFormat:@"Hey! I'm using iPi and I think you should join in too at %@", kTwitterPageURL]};
        
        SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodPOST
                                                                 URL:directMessageURL
                                                          parameters:params];
        
        
        [twitterRequest setAccount:self.twitterAccounts[accountIndex]];
        [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
            
            NSLog(@"Error : %@", [error description]);
            NSLog(@"Status Code :  %d", [urlResponse statusCode]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Faild to Send Message"
                                                                    message:@"Please make sure you have access to the internet and try again."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Sent"
                                                                    message:[NSString stringWithFormat:@"Your friend %@ was invited to join iPi!", follower[@"display_name"]]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                [self.activityIndicator stopAnimating];
            });
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Send Message"
                                                        message:@"Please enable iPi to use your Twitter account and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark Google Plus

- (void)loginWithGooglePlus
{
    self.socialActionType = kSocialActionTypeLogin;
    [[GPPSignIn sharedInstance] authenticate];
}

- (void)logoutFromGooglePlus
{
    [[GPPSignIn sharedInstance] disconnect];
    [self updateSocialView];
}

- (void)shareOnGooglePlus
{
    if ([[GPPSignIn sharedInstance] authentication])
    {
        [self presentGoogleShareDialog];
    }
    else
    {
        self.socialActionType = kSocialActionTypeShare;
        [[GPPSignIn sharedInstance] authenticate];
    }
}

- (void)presentGoogleShareDialog
{
    if ([self isKindOfClass:[ItemViewController class]])
    {
        NSDictionary *item = ((ItemViewController *)self).item;
        NSNumber *itemID = item[@"id"];
        
        NSString *title = item[@"title"];

        NSString *itemWebURL = [NSString stringWithFormat:kShareItemWebURLformat, itemID];
        NSString *itemShareText = [NSString stringWithFormat:@"Hey! Check out %@ on iPi.", title];
        
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];

        [shareBuilder setURLToShare:[NSURL URLWithString:itemWebURL]];
        [shareBuilder setPrefillText:itemShareText];
        
        [shareBuilder open];
    }
    else if ([self isKindOfClass:[ItemsViewController class]])
    {
        NSDictionary *collection = ((ItemsViewController *)self).collection;
        if (collection)
        {
            NSNumber *collectionID = collection[@"id"];
            NSString *title = collection[@"name"];
            NSNumber *collectionOwnerID = collection[@"user_id"];
            
            NSString *collectionWebURL = [NSString stringWithFormat:kShareCollectionWebURLformat, collectionID];
            NSString *collectionShareText;
            NSNumber *authUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            if ([authUserID isEqualToNumber:collectionOwnerID])
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out my %@ collection on iPi.", title];
            }
            else
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out this %@ collection on iPi.", title];
            }

            id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
            
            [shareBuilder setURLToShare:[NSURL URLWithString:collectionWebURL]];
            [shareBuilder setPrefillText:collectionShareText];
            
            [shareBuilder open];
        }
        else
        {
            NSNumber *userID = ((ItemsViewController *)self).userID;
            if (!userID) userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];

            NSString *wishlistWebURL = [NSString stringWithFormat:kShareWishlistWebURLformat, userID];
            NSString *wishlistShareText = @"Hey! Check out my wishlist on iPi.";
            
            id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
            
            [shareBuilder setURLToShare:[NSURL URLWithString:wishlistWebURL]];
            [shareBuilder setPrefillText:wishlistShareText];
            
            [shareBuilder open];
        }
    }
}

- (void)requestGooglePlusFriends
{
    if ([[GPPSignIn sharedInstance] authentication])
    {
        [self googlePlusFriends];
    }
    else
    {
        self.socialActionType = kSocialActionTypeFriends;
        [[GPPSignIn sharedInstance] authenticate];
    }
}

- (void)googlePlusFriends
{
    [self.activityIndicator startAnimating];
    
    GTLServicePlus *plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[[GPPSignIn sharedInstance] authentication]];

    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleListWithUserId:@"me" collection:kGTLPlusCollectionVisible];
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket, GTLPlusPeopleFeed *peopleFeed, NSError *error) {
                
                if (error)
                {
                    NSLog(@"Error: %@", [error description]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Request Google+ Friends"
                                                                        message:@"Please enable iPi to use your Google+ account and make sure that you are connected to the Internet."
                                                                       delegate:nil
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [alert show];
                        
                        [self.activityIndicator stopAnimating];
                    });
                }
                else
                {
                    NSMutableArray *friends = [[NSMutableArray alloc] initWithCapacity:peopleFeed.items.count];
                    
                    for (GTLPlusPerson *person in peopleFeed.items)
                    {
                        NSMutableDictionary *friend = [@{@"provider_uid" : person.identifier,
                                                         @"display_name" : person.displayName,
                                                         @"image_url" : person.image.url,
                                                         @"isSocialNetworkFriend" : @YES} mutableCopy];
                        
                        [friends addObject:friend];
                    }
                    
                    AppModel *sharedModel = [AppModel sharedModel];
                    sharedModel.googlePlusFriends = friends;
                    
                    NSLog(@"Google+ Friends : %@", sharedModel.googlePlusFriends);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self updateSocialView];
                    });
                }
            }];
}

- (void)shareInvitationwithGooglePlusFriend:(NSDictionary *)friend
{
    if ([[GPPSignIn sharedInstance] authentication])
    {
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        
        // [shareBuilder setURLToShare:[NSURL URLWithString:kWebsiteHomepageURL]];
        [shareBuilder setPrefillText:[NSString stringWithFormat:@"Hey! I'm using iPi and I think you should join in too at %@", kWebsiteHomepageURL]];
        [shareBuilder setPreselectedPeopleIDs:@[friend[@"provider_uid"]]];
        [shareBuilder attachImage:[UIImage imageNamed:@"logo-medium"]];
        
        [shareBuilder open];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Share Invitation"
                                                        message:@"Please enable iPi to use your Google+ account and try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


#pragma mark Address book

- (void)addressBookContacts
{
    CFErrorRef error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {

        if (error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Get Contacts"
                                                                message:@"Please enable iPi to access your Address Book contacts and try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [self.activityIndicator stopAnimating];
            });
        }
        else if (!granted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"Please enable iPi to access your Address Book contacts and try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                
                [self.activityIndicator stopAnimating];
            });
        }
        else
        {
            // Import contacts from address book
            CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
            NSArray *allContacts = (__bridge_transfer NSArray *)allPeople;
            
            NSLog(@"All contacts count : %d", allContacts.count);
            
            // Build a predicate that searches for contacts with at least one e-mail address
            NSPredicate *predicate = [NSPredicate predicateWithBlock: ^(id record, NSDictionary *bindings) {
                
                ABMultiValueRef emails = ABRecordCopyValue((__bridge ABRecordRef)record, kABPersonEmailProperty);
                
                BOOL result = (ABMultiValueGetCount(emails) > 0) ? YES : NO;
                
                for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++)
                {
                    NSString *email = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(emails, i);
                    NSLog(@"Person email : %@", email);
                }
                
                return result;
            }];
            
            NSArray *filteredContacts = [allContacts filteredArrayUsingPredicate:predicate];
            NSLog(@"Filtered contacts count : %d", filteredContacts.count);

            NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:filteredContacts.count];
            
            for (id person in filteredContacts)
            {
                NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName((__bridge ABRecordRef)person);

                ABMultiValueRef emails = ABRecordCopyValue((__bridge ABRecordRef)person, kABPersonEmailProperty);
                NSString *email = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, 0);
                
                NSMutableDictionary *contact = [@{@"email" : email,
                                                  @"display_name" : name,
                                                  @"isAddressBookContact" : @YES} mutableCopy];
                
                if (ABPersonHasImageData((__bridge ABRecordRef)person))
                {
                    NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageData((__bridge ABRecordRef)person);
                    contact[@"imageData"] = imageData;
                }
                
                [contacts addObject:contact];
            }
            
            AppModel *sharedModel = [AppModel sharedModel];
            sharedModel.addressBookContacts = contacts;
            
            CFRelease(addressBook);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateSocialView];
            });
        }
    });
}

#pragma mark Mail

- (void)shareViaMail
{
    NSString *firstName = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstName"];
    NSString *lastName = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastName"];
    if (firstName == nil) firstName = @"";
    if (lastName == nil) lastName = @"";
    
    if ([self isKindOfClass:[ItemViewController class]])
    {
        NSDictionary *item = ((ItemViewController *)self).item;
        NSNumber *itemID = item[@"id"];
        NSString *title = item[@"title"];
        
        NSString *itemWebURL = [NSString stringWithFormat:kShareItemWebURLformat, itemID];
        NSString *itemShareText = [NSString stringWithFormat:@"Hey!<br />Check out %@ on <a href='%@'>iPi</a>.", title, itemWebURL];
        
        if (firstName && lastName) itemShareText = [itemShareText stringByAppendingFormat:@"<br /><br />%@ %@", firstName, lastName];
        
        if ([MFMailComposeViewController canSendMail] == YES)
        {
            MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
            mailPicker.modalPresentationStyle = UIModalPresentationFormSheet;
            mailPicker.mailComposeDelegate = self;
            mailPicker.navigationBar.tintColor = [UIColor colorWith256RBGAArray:kOrangeColor];
            [mailPicker setSubject:title];
            [mailPicker setMessageBody:itemShareText isHTML:YES];
            
            [self presentViewController:mailPicker animated:YES completion:NULL];
        }
        else
        {
            NSString *email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", title, itemShareText];
            email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        }
    }
    else if ([self isKindOfClass:[ItemsViewController class]])
    {
        NSDictionary *collection = ((ItemsViewController *)self).collection;
        if (collection)
        {
            NSNumber *collectionID = collection[@"id"];
            NSString *title = collection[@"name"];
            NSNumber *collectionOwnerID = collection[@"user_id"];
            
            NSString *collectionWebURL = [NSString stringWithFormat:kShareCollectionWebURLformat, collectionID];
            NSString *collectionShareText;
            NSNumber *authUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            if ([authUserID isEqualToNumber:collectionOwnerID])
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out my %@ collection on <a href='%@'>iPi</a>.", title, collectionWebURL];
            }
            else
            {
                collectionShareText = [NSString stringWithFormat:@"Hey! Check out this %@ collection on <a href='%@'>iPi</a>.", title, collectionWebURL];
            }

            if (firstName && lastName) collectionShareText = [collectionShareText stringByAppendingFormat:@"<br /><br />%@ %@", firstName, lastName];
            
            if ([MFMailComposeViewController canSendMail] == YES)
            {
                MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
                mailPicker.modalPresentationStyle = UIModalPresentationFormSheet;
                mailPicker.mailComposeDelegate = self;
                mailPicker.navigationBar.tintColor = [UIColor colorWith256RBGAArray:kOrangeColor];
                [mailPicker setSubject:title];
                [mailPicker setMessageBody:collectionShareText isHTML:YES];
                
                [self presentViewController:mailPicker animated:YES completion:NULL];
            }
            else
            {
                NSString *email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", title, collectionShareText];
                email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
            }
        }
        else
        {
            NSNumber *userID = ((ItemsViewController *)self).userID;
            if (!userID) userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];

            NSString *title = @"My wishlist";
            NSString *wishlistWebURL = [NSString stringWithFormat:kShareWishlistWebURLformat, userID];
            NSString *wishlistShareText = [NSString stringWithFormat:@"Hey! Check out my wishlist on <a href='%@'>iPi</a>.", wishlistWebURL];
            
            if ([MFMailComposeViewController canSendMail] == YES)
            {
                MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
                mailPicker.modalPresentationStyle = UIModalPresentationFormSheet;
                mailPicker.mailComposeDelegate = self;
                mailPicker.navigationBar.tintColor = [UIColor colorWith256RBGAArray:kOrangeColor];
                [mailPicker setSubject:title];
                [mailPicker setMessageBody:wishlistShareText isHTML:YES];
                
                [self presentViewController:mailPicker animated:YES completion:NULL];
            }
            else
            {
                NSString *email = [NSString stringWithFormat:@"mailto:&subject=%@&body=%@", title, wishlistShareText];
                email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
            }
        }
    }
}

- (void)sendMailInvitationToContact:(NSDictionary *)contact
{
    NSString *title = @"Join iPi";
    NSString *text = [NSString stringWithFormat:@"Hey! I'm using <a href='%@'>iPi</a> and I think you should join in too!", kWebsiteHomepageURL];
    NSString *mailAddress = contact[@"email"];
    
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
        mailPicker.modalPresentationStyle = UIModalPresentationFormSheet;
        mailPicker.mailComposeDelegate = self;
        mailPicker.navigationBar.tintColor = [UIColor colorWith256RBGAArray:kOrangeColor];
        [mailPicker setToRecipients:@[mailAddress]];
        [mailPicker setSubject:title];
        [mailPicker setMessageBody:text isHTML:YES];
        
        [self presentViewController:mailPicker animated:YES completion:NULL];
    }
    else
    {
        NSString *email = [NSString stringWithFormat:@"mailto:%@&subject=%@&body=%@", mailAddress, title, text];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
