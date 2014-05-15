//
//  HttpRequests.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "HttpRequests.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "Base64.h"

@implementation HttpRequests

NSString *serverUrl = @"http://89.45.249.251/Anonimo"; //base url
//NSString *serverUrl = @"http://10.11.194.230:8080/Anonimo"; //base url
+(void)sendPostRequest:(NSString *)relativeUrl
                  data:(NSDictionary *)dict
               success:(void (^)(id))successHandler
                 error:(void (^)(AFHTTPRequestOperation*, NSError*)) errorHandler
{
    NSURL *url = [NSURL URLWithString:serverUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:relativeUrl
                                                      parameters:dict];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    void (^internalSuccessHandler)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation* operation, id responseObject) {
        
        NSError *error;
        NSLog(@"%@: %@", relativeUrl, [operation responseString]);
        NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
        if(data)
        {
            id responseObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            successHandler(responseObj);
        }
        else
        {
            NSLog(@"///////%d", [(NSHTTPURLResponse*)responseObject statusCode]);
            successHandler(nil);
        }
    };
    
    [operation setCompletionBlockWithSuccess:internalSuccessHandler failure:errorHandler];
    
    [operation start];
}
+(void)sendGetRequest:(NSString*)relativeUrl
                 data:(NSDictionary *)data
              success:(void (^)(id))successHandler
                error:(void (^)(AFHTTPRequestOperation*, NSError*))errorHandler
{
    
    NSURL *url = [NSURL URLWithString:serverUrl];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:relativeUrl parameters:data];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    void (^internalSuccessHandler)(AFHTTPRequestOperation*, id) = ^(AFHTTPRequestOperation* operation, id responseObject) {
        NSError *error;
        //NSLog(@"%@", [operation responseString]);
        NSData *data = [[operation responseString] dataUsingEncoding:NSUTF8StringEncoding];
        id responseObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        successHandler(responseObj);
    };
    
    [operation setCompletionBlockWithSuccess:internalSuccessHandler failure:errorHandler];
    
    [operation start];
    
}

+(void)sendGetRequestToServer:(NSString *)relativeURL
                         data:(NSDictionary *)data
                       succes:(void (^)(id))succesHandler
{
    static BOOL isPreviousRequestWorking;
    if (isPreviousRequestWorking == NO)
    {
        isPreviousRequestWorking = YES;
        
        dispatch_queue_t requestQueue = dispatch_queue_create("Get Request Queue", NULL);
        
        dispatch_async(requestQueue, ^{
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://89.45.249.251/Anonimo/%@", relativeURL]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:90.0];
            [request setHTTPMethod:@"GET"];
            
            NSLog(@"Will send Get Request with URL: %@", [NSString stringWithFormat:@"http://89.45.249.251/Anonimo/%@", relativeURL]);
            NSHTTPURLResponse *httpResponse;
            NSData *itemData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
            for (int retryCount = 1; (itemData == nil || [httpResponse statusCode] != 200) && retryCount < 4; retryCount++)
            {
                itemData = [NSURLConnection sendSynchronousRequest:request returningResponse:&httpResponse error:nil];
            }
            
            if (itemData)
            {
                id response = [NSJSONSerialization JSONObjectWithData:itemData options:NSJSONReadingAllowFragments error:nil];
                
                if ([httpResponse statusCode] == 200 )
                {
                    succesHandler(response);
                }
            }
        });
        dispatch_async(requestQueue, ^{
            isPreviousRequestWorking = NO;
        });
    }
}

+(void)getAllUserssuccess:(void (^)(id data))successHandler
{
    [self sendGetRequestToServer:@"users" data:nil succes:^(id data) {
        successHandler(data);
    }];
}


+(void)createUserWithUsername:(NSString *)Username
                     password:(NSString *)password
                        email:(NSString *)emailAddress
                      success:(void (^)(id))successHandler
                        error:(void (^)(AFHTTPRequestOperation *, NSError *))errorHandler
{
    NSMutableDictionary *dataDict=[[NSMutableDictionary alloc]init];
    
    [dataDict setValue:Username forKey:@"name"];
    [dataDict setValue:password forKey:@"password"];
    [dataDict setValue:emailAddress forKey:@"email"];
    
    
    [self sendPostRequest:@"users" //concatenare la base url / se cheama URI
                     data:dataDict
                  success:^(NSDictionary *data) //data primeste de pe server
     {
         successHandler(data);
     }
     
                    error:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                    }];
}




@end
