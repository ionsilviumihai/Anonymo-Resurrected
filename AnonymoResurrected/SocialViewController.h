//
//  SocialViewController.h
//  Torah
//
//  Created by Radu-Tudor Ionescu on 9/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <AddressBook/AddressBook.h>


@interface SocialViewController : UIViewController <UIActionSheetDelegate>

@property (strong, nonatomic) UIActionSheet *shareActionSheet;

- (void)updateSocialView;

- (void)sendAccessToken:(NSString *)accessToken toServerAndLoginForSocialNetworkName:(NSString *)socialNetworkName;
- (void)sendAccessToken:(NSString *)accessToken accessSecretKey:(NSString *)accessSecretKey toServerAndLoginForSocialNetworkName:(NSString *)socialNetworkName;

- (void)loginWithFacebook;
- (void)logoutFromFacebook;
- (void)shareOnFacebook;
- (void)presentFacebookFeedDialog;
- (void)autoShareOnFacebook;

- (void)initiateRequestForFacebookFriends;
- (void)requestFacebookFriends;
- (void)sendInvitationToFacebookFriend:(NSDictionary *)friend;
- (void)inviteFacebookFriend:(NSDictionary *)friend;

- (void)loginWithTwitter;
- (void)shareOnTwitter;
- (void)initiateRequestForTwitterFollowers;
- (void)requestTwitterFollowers;
- (void)twitterUsersInfoForIDList:(NSString *)usersIDListString fromAccount:(ACAccount *)account updateSocialView:(BOOL)updateSocialView;
- (void)sendDirectMessageToTwitterFollower:(NSDictionary *)follower;

- (void)loginWithGooglePlus;
- (void)logoutFromGooglePlus;
- (void)shareOnGooglePlus;
- (void)presentGoogleShareDialog;
- (void)requestGooglePlusFriends;
- (void)shareInvitationwithGooglePlusFriend:(NSDictionary *)friend;

- (void)addressBookContacts;

- (void)shareViaMail;
- (void)sendMailInvitationToContact:(NSDictionary *)contact;

@end
