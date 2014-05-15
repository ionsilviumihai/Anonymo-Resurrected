//
//  AppModel.h
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject

@property (strong, nonatomic) NSMutableDictionary *userProfile;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableDictionary *userLoggedIn;

+ (AppModel *)sharedModel;
@end
