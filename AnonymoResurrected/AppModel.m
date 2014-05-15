//
//  AppModel.m
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "AppModel.h"

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
#pragma mark General Methods
#pragma mark Server Requests

#pragma mark Setters and Getters
- (NSMutableArray *)users
{
    if (_users == nil) {
        _users = [[NSMutableArray alloc] init];
    }
    return _users;
}

-(NSMutableDictionary *)userLoggedIn
{
    if (_userLoggedIn == nil) {
        _userLoggedIn = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    return _userLoggedIn;
}
#pragma mark Permanent Store methods

@end
