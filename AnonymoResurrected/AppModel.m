//
//  AppModel.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "AppModel.h"
#import "Constants.h"
@implementation AppModel

+(AppModel *)sharedModel
{
    static AppModel *sharedModel;
    if (sharedModel == nil) {
        sharedModel = [[AppModel alloc] init];
    }
    return sharedModel;
}

#pragma mark Notifications
+(NSString *)didCreateNewAccountNotificationName
{
    return @"didCreateNewAccountNotificationName";
}
#pragma mark General Methods
#pragma mark Server Requests
NSString *serverUrl = @"http://89.45.249.251/Anonimo/%@"; //base url
//Create New User


- (void)sendPostRequestWithRelativeURL: (NSString *) relativeURL
                                  data: (NSDictionary *) data
                                succes: (void (^)(NSHTTPURLResponse *, id)) succesHandler
                                 error: (void (^)(NSHTTPURLResponse *)) errorHandler
{
    static BOOL isPreviousRequestWorking;
    if (isPreviousRequestWorking == NO)
    {
        isPreviousRequestWorking = YES;
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        
        if (![token isEqualToString:@"0"])
        {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kCreateGetRequestURLFormat]]
                                                                   cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                               timeoutInterval:90.0];
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:NULL];
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            //NSString *postString = [NSString stringWithFormat:@"{\"comment\":%@}", jsonString];
            NSLog(@"Post string ce va fi trimis la server: %@", jsonString);
            
            NSData *postData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            [request setHTTPMethod:@"POST"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:postData];
            
            NSOperationQueue *requestQueue = [[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:requestQueue
                                   completionHandler:^(NSURLResponse *postResponse, NSData *data, NSError *error) {
                                       
                                       BOOL createFailed = YES;
                                       
                                       NSLog(@"Error : %@",[error localizedDescription]);
                                       NSLog(@"Status Code :  %ld",(long)[(NSHTTPURLResponse *)postResponse statusCode]);
                                       
                                       if (!error)
                                       {
                                           if (data)
                                           {
                                               id response = [NSJSONSerialization JSONObjectWithData:data
                                                                                             options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers
                                                                                               error:nil];
                                               
                                               NSLog(@"Server response: %@",response);
                                               
                                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)postResponse;
                                               if ([httpResponse statusCode] == kHTTPStatusCodeCreateSuccess)
                                               {
                                                   createFailed = NO;
                                                   
                                                   
                                                   // Call the function to remove Null objects because the guys working on the server side don't give a shit on building a good API
                                                   //response = [Utility removeNullObjectsFromObject:response];
                                                   
//                                                   if ([response isKindOfClass:[NSDictionary class]])
//                                                   {
//                                                       //self.createdComment = response[@"comments"][0];
//                                                       NSLog(@"Created user : %@", response);
//                                                   }
                                                   
                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                       
                                                       succesHandler(httpResponse, response);
                                                       
                                                       UIAlertView *successAlertView = [[UIAlertView alloc] initWithTitle:@"New User Added"
                                                                                                                  message:@"Your new account was successfully added!"
                                                                                                                 delegate:nil
                                                                                                        cancelButtonTitle:@"Ok"
                                                                                                        otherButtonTitles:nil];
                                                       successAlertView.tag = kAlertCodeSuccess;
                                                       [successAlertView show];
                                                   });
                                               }
                                           }
                                       }
                                       if (createFailed)
                                       {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               
                                               errorHandler((NSHTTPURLResponse *)postResponse);
                                               
                                               UIAlertView *failedAlertView = [[UIAlertView alloc] initWithTitle:@"Add New User Failed"
                                                                                                         message:@"Please make sure that you are connected to the Internet and try again."
                                                                                                        delegate:nil
                                                                                               cancelButtonTitle:@"Ok"
                                                                                               otherButtonTitles:nil];
                                               failedAlertView.tag = kAlertCodeRequestError;
                                               [failedAlertView show];
                                           });
                                       }
                                       
                                       isPreviousRequestWorking = NO;
                                       dispatch_async(dispatch_get_main_queue(), ^{
//                                           [[NSNotificationCenter defaultCenter] postNotificationName:[AppModel didCreateCommentDataNotificationName]
//                                                                                        object:self];
                                       });
                                   }];
        }
        else isPreviousRequestWorking = NO;
    }
}

//GET all users from the server
//- (void)requestUsersDataFromServer
//{
//    static BOOL isPreviousRequestWorking;
//    if (isPreviousRequestWorking == NO)
//    {
//        isPreviousRequestWorking = YES;
//        
//        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//        NSNumber *authUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
//        
//        dispatch_queue_t requestQueue = dispatch_queue_create("Users Request Queue", NULL);
//        
//        if (![token isEqualToString:@"0"])
//        {
//            // Request collections data
//            dispatch_async(requestQueue, ^{
//                
//                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kCreateGetRequestURLFormat, @"users"]]
//                                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
//                                                                   timeoutInterval:90.0];
//                [request setHTTPMethod:@"GET"];
//                
//                
//                NSHTTPURLResponse *httpResponse;
//                NSData *collectionsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
//                for (int retryCount = 1; (collectionsData == nil || [httpResponse statusCode] != kHTTPStatusCodeSuccess) && retryCount < kMaxRequestRetries; retryCount++)
//                    collectionsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
//                
//                if (collectionsData)
//                {
//                    id response = [NSJSONSerialization JSONObjectWithData:collectionsData
//                                                                  options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers
//                                                                    error:nil];
//                    
//                    // Call the function to remove Null objects because the guys working on the server side don't give a shit on building a good API
//                    //response = [Utility removeNullObjectsFromObject:response];
//                    
//                    if ([httpResponse statusCode] == kHTTPStatusCodeSuccess)
//                    {
//                        NSString *currentToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//                        //if ([token isEqualToString:currentToken])
//                        //{
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                
//                                //if ([userID isEqualToNumber:authUserID])
//                                //{
//                                    //self.userCollections = response[@"collections"];
//                                    NSLog(@"S-a primit de la server : %@", response[[response count] - 1]);
//                                //}
//                               // else
//                                //{
//                                    //self.collections = response[@"collections"];
//                                   // self.collectionsUserID = userID;
//                                    //NSLog(@"Collections : %@", self.collections);
//                                //}
//                            });
//                        //}
//                    }
//                }
//            });
//        }
//        
//        dispatch_async(requestQueue, ^{
//            
//            isPreviousRequestWorking = NO;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                //[[NSNotificationCenter defaultCenter] postNotificationName:[AppModel didReceiveCollectionsDataNotificationName]
//                                                                   // object:self];
//            });
//        });
//    }
//}


- (void)sendGetRequestWithRelativeURL:(NSString *)relativeURL
                                 data:(NSDictionary *)data
                               succes:(void (^)(NSHTTPURLResponse *, id)) succesHandler
                                error:(void (^)(NSHTTPURLResponse*)) errorHandler
{
    static BOOL isPreviousRequestWorking;
    if (isPreviousRequestWorking == NO)
    {
        isPreviousRequestWorking = YES;
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSNumber *authUserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
        
        dispatch_queue_t requestQueue = dispatch_queue_create("Users Request Queue", NULL);
        
        if (![token isEqualToString:@"0"])
        {
            // Request collections data
            dispatch_async(requestQueue, ^{
                
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kCreateGetRequestURLFormat, @"users"]]
                                                                       cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                                   timeoutInterval:90.0];
                [request setHTTPMethod:@"GET"];
                
                
                NSHTTPURLResponse *httpResponse;
                NSData *collectionsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
                for (int retryCount = 1; (collectionsData == nil || [httpResponse statusCode] != kHTTPStatusCodeSuccess) && retryCount < kMaxRequestRetries; retryCount++)
                    collectionsData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
                
                if (collectionsData)
                {
                    id response = [NSJSONSerialization JSONObjectWithData:collectionsData
                                                                  options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers
                                                                    error:nil];
                    
                    // Call the function to remove Null objects because the guys working on the server side don't give a shit on building a good API
                    //response = [Utility removeNullObjectsFromObject:response];
                    
                    if ([httpResponse statusCode] == kHTTPStatusCodeSuccess)
                    {
                        NSString *currentToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
                        //if ([token isEqualToString:currentToken])
                        //{

                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"S-a trimis handlerul de succes cu continutul %@", response);
                            succesHandler(httpResponse,response);
                        });
                        //}
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"S-a trimis handlerul de fail");
                            errorHandler(httpResponse);
                        });
                    }
                }
            });
        }
        
        dispatch_async(requestQueue, ^{
            
            isPreviousRequestWorking = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[[NSNotificationCenter defaultCenter] postNotificationName:[AppModel didReceiveCollectionsDataNotificationName]
                // object:self];
            });
        });
    }
}


#pragma mark Setters and Getters
- (NSMutableArray *)usersFromServer
{
    if (_usersFromServer == nil) {
        _usersFromServer = [[NSMutableArray alloc] init];
    }
    return _usersFromServer;
}

-(NSMutableDictionary *)userLoggedIn
{
    if (_userLoggedIn == nil) {
        _userLoggedIn = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _userLoggedIn;
}
#pragma mark Permanent Store method
#pragma mark Alert View delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kAlertCodeSuccess) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[AppModel didCreateNewAccountNotificationName] object:self userInfo:self];
    }
}

@end
