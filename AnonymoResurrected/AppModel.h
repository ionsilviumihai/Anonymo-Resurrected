//
//  AppModel.h
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *userProfile;
@property (strong, nonatomic) NSMutableArray *usersFromServer;
@property (strong, nonatomic) NSMutableDictionary *userLoggedIn;

+ (AppModel *)sharedModel;

//Notification Interface
+(NSString *)didCreateNewAccountNotificationName;

//Server Requests Interface
- (void)createNewUserOnServerWithDictionary:(NSDictionary *)newUserDictionary;
- (void)requestUsersDataFromServer; //GET ALL USERS FROM SERVER

//METODA PENTRU GET
- (void)sendGetRequestWithRelativeURL:(NSString *)relativeURL
                                 data:(NSDictionary *)data
                               succes:(void (^)(NSHTTPURLResponse *, id)) succesHandler
                                error:(void (^)(NSHTTPURLResponse*)) errorHandler;
//METODA PENTRU POST
- (void)sendPostRequestWithRelativeURL: (NSString *) relativeURL
                                  data: (NSDictionary *) data
                                succes: (void (^)(NSHTTPURLResponse *, id)) succesHandler
                                 error: (void (^)(NSHTTPURLResponse *)) errorHandler;




@end
