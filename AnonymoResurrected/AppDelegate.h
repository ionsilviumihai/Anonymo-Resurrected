//
//  AppDelegate.h
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;
@protocol FBLoginDelegate <NSObject>

-(void)LoginWasSuccesfull:(BOOL) success;

@end


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) id<FBLoginDelegate> delegate;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

- (void)logOutSession;

@end
