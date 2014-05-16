//
//  Constants.h
//  Torah
//
//  Created by Radu-Tudor Ionescu on 9/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// General imports

#import "UIColor+RBGA256.h"

// Constant definitions

#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds].size.height == 568.0)

#define kSplashDuration 8.0

#define kGoogleImageSearchURLFormat @"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&imgsz=large&q=%@&start=%d" // &userip=%@"
#define kGoogleImageSearchImagesPerPage 8
#define kGoogleImageSearchPageCount 6
#define kGoogleImageSearchPageCountForNeighborhood 1

#define kImageSearchTypeDefault 0
#define kImageSearchTypeItems 1
#define kImageSearchTypePlaces 2

#define IS_STAGING 1 // comment this line for production
#ifdef IS_STAGING

#define kWebsiteHomepageURL @"http://ipi.sparktechsoft.net"
#define kTwitterPageURL @"http://twitter.com/ipi"

//my constants
#define kCreateGetRequestURLFormat @"http://89.45.249.251/Anonimo/%@"
//my constants

#define kPlaceWebSearchURLFormat @"http://ipi.sparktechsoft.net/api/v1/places/search?q=%@&gl_name=%@&auth_token=%@"
#define kNearbyPlaceWebSearchURLFormat @"http://ipi.sparktechsoft.net/api/v1/places/nearby_search?lat=%f&lng=%f&auth_token=%@"
#define kPlaceURLFormat @"http://ipi.sparktechsoft.net/api/v1/places/details?reference=%@&auth_token=%@&photos=true"

#define kSettingsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/settings?auth_token=%@"
#define kUpdateSettingsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/update_settings?auth_token=%@"

#define kProfileURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@?auth_token=%@"
#define kUpdateProfileURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@?auth_token=%@"

#define kCollectionsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/collections?auth_token=%@"
#define kCreateCollectionURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections?auth_token=%@"
#define kUpdateCollectionURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/%@?auth_token=%@"
#define kDeleteCollectionURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/%@?auth_token=%@"

#define kCollectionItemsURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/%@/items?auth_token=%@"

#define kNeighborhoodsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/neighbourhoods?auth_token=%@"
#define kCreateNeighborhoodURLFormat @"http://ipi.sparktechsoft.net/api/v1/neighbourhoods?auth_token=%@"
#define kUpdateNeighborhoodURLFormat @"http://ipi.sparktechsoft.net/api/v1/neighbourhoods/%@?auth_token=%@"
#define kDeleteNeighborhoodURLFormat @"http://ipi.sparktechsoft.net/api/v1/neighbourhoods/%@?auth_token=%@"

#define kNeighborhoodItemsURLFormat @"http://ipi.sparktechsoft.net/api/v1/neighbourhoods/%@/items?auth_token=%@"

#define kPlaceEventsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/place_types?auth_token=%@"
#define kPlaceEventItemsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/place_types/%@/items?auth_token=%@"

#define kCollectionSubscribeURLFromat @"http://ipi.sparktechsoft.net/api/v1/collections/%@/subscribe?auth_token=%@"
#define kCollectionUnsubscribeURLFromat @"http://ipi.sparktechsoft.net/api/v1/collections/%@/unsubscribe?auth_token=%@"

#define kWishlistItemsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/wishlist?auth_token=%@"
#define kWishlistFollowersURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/wishlist/subscribers?auth_token=%@"

#define kWishlistSubscribeURLFromat @"http://ipi.sparktechsoft.net/api/v1/users/%@/subscribe_wishlist?auth_token=%@"
#define kWishlistUnsubscribeURLFromat @"http://ipi.sparktechsoft.net/api/v1/users/%@/unsubscribe_wishlist?auth_token=%@"

#define kCollectionURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/%@?auth_token=%@"
#define kCollectionFollowersURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/%@/subscribers?auth_token=%@"

#define kItemURLFormat @"http://ipi.sparktechsoft.net/api/v1/items/%@?auth_token=%@"
#define kCreateItemURLFormat @"http://ipi.sparktechsoft.net/api/v1/items?auth_token=%@"
#define kUpdateItemURLFormat @"http://ipi.sparktechsoft.net/api/v1/items/%@?auth_token=%@"
#define kDeleteItemURLFormat @"http://ipi.sparktechsoft.net/api/v1/items/%@?auth_token=%@"

#define kItemNewsArticles @"http://ipi.sparktechsoft.net/api/v1/items/%@/news_articles?auth_token=%@"
#define kMembersThatAddedItemURLFormat @"http://ipi.sparktechsoft.net/api/v1/items/%@/ipi_users?auth_token=%@"
#define kFriendsThatAddedItemURLFormat @"http://ipi.sparktechsoft.net/api/v1/items/%@/ipi_users/friends?auth_token=%@"

#define kCreateCommentURLFormat @"http://ipi.sparktechsoft.net/api/v1/comments?auth_token=%@"
#define kUpdateCommentURLFormat @"http://ipi.sparktechsoft.net/api/v1/comments/%@?auth_token=%@"
#define kDeleteCommentURLFormat @"http://ipi.sparktechsoft.net/api/v1/comments/%@?auth_token=%@"

#define kCollectionSuggestionsURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/index_with_suggestions?q=%@&auth_token=%@&include_places=%d"
#define kPlaceEventsSuggestionsURLFormat @"http://ipi.sparktechsoft.net/api/v1/neighbourhoods/place_types?auth_token=%@"

#define kSubscribedCollectionsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/subscriptions?type=collection&auth_token=%@"
#define kSubscribedNeighborhoodsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/subscriptions?type=neighbourhood&auth_token=%@"
#define kSubscribedWishlistsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/wishlist_subscriptions?auth_token=%@"

#define kFriendsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/follows?auth_token=%@"
#define kCreateFriendURLFormat @"http://ipi.sparktechsoft.net/api/v1/followers?auth_token=%@"
#define kDeleteFriendURLFormat @"http://ipi.sparktechsoft.net/api/v1/followers/%@?auth_token=%@"

#define kCommonFriendsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/common_friends?auth_token=%@"
#define kSearchFriendsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/search?q=%@&auth_token=%@"

#define kSearchFriendsFromSocialNetworkURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/search/social?auth_token=%@&account_type=%@&ids=%@"
#define kSearchFriendsByEmailURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/search/social?auth_token=%@&emails=%@"

#define kSearchItemsURLFormat @"http://ipi.sparktechsoft.net/api/v1/items/search?q=%@&auth_token=%@&type=%@&extra=%@"
#define kSearchBarocodeURLFormat @"http://ipi.sparktechsoft.net/api/v1/barcodes/name_search?barcode=%@&auth_token=%@"

#define kUserEventsURLFormat @"http://ipi.sparktechsoft.net/api/v1/my_recent_additions?auth_token=%@&page=%d"
#define kUserNetworkEventsURLFormat @"http://ipi.sparktechsoft.net/api/v1/my_activity?auth_token=%@&page=%d"
#define kNetworkEventsURLFormat @"http://ipi.sparktechsoft.net/api/v1/ipi_activity?auth_token=%@&page=%d"
#define kMemberEventsURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/recent_additions?auth_token=%@&page=%d"

#define kPostLoginURL @"http://ipi.sparktechsoft.net/api/v1/users/sign_in"
#define kPostSocialLoginURL @"http://ipi.sparktechsoft.net/api/v1/users/sign_in_social"
#define kPostRegisterURL @"http://ipi.sparktechsoft.net/api/v1/users/sign_up"

#define kPostDeactivateAccountURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/deactivate?auth_token=%@"

#define kPostPushNotificationsRegisterURLFormat @"http://ipi.sparktechsoft.net/api/v1/push_notification?auth_token=%@"

#define kPostFeedbackURLFormat @"http://ipi.sparktechsoft.net/api/v1/feedback?auth_token=%@"
#define kPostAbuseReportURLFormat @"http://ipi.sparktechsoft.net/api/v1/report?auth_token=%@"
#define kPostItemSuggestionURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/suggest_item?auth_token=%@"

#define kPostCollectionsMergeURLFormat @"http://ipi.sparktechsoft.net/api/v1/collections/%@/merge_into/%@?auth_token=%@"

#define kUpdatePasswordURLFormat @"http://ipi.sparktechsoft.net/api/v1/users/%@/update_password?auth_token=%@"
#define kPasswordRecoveryURL @"http://ipi.sparktechsoft.net/users/password/new"

#define kShareWishlistWebURLformat @"http://ipi.sparktechsoft.net/users/%@/wishlist"
#define kShareCollectionWebURLformat @"http://ipi.sparktechsoft.net/collections/%@"
#define kShareItemWebURLformat @"http://ipi.sparktechsoft.net/items/%@"

#else

#define kWebsiteHomepageURL @"http://ipi.mobi"
#define kTwitterPageURL @"http://twitter.com/ipi"

#define kPlaceWebSearchURLFormat @"http://ipi.mobi/api/v1/places/search?q=%@&gl_name=%@&auth_token=%@"
#define kNearbyPlaceWebSearchURLFormat @"http://ipi.mobi/api/v1/places/nearby_search?lat=%f&lng=%f&auth_token=%@"
#define kPlaceURLFormat @"http://ipi.mobi/api/v1/places/details?reference=%@&auth_token=%@&photos=true"

#define kSettingsURLFormat @"http://ipi.mobi/api/v1/users/settings?auth_token=%@"
#define kUpdateSettingsURLFormat @"http://ipi.mobi/api/v1/users/%@/update_settings?auth_token=%@"

#define kProfileURLFormat @"http://ipi.mobi/api/v1/users/%@?auth_token=%@"
#define kUpdateProfileURLFormat @"http://ipi.mobi/api/v1/users/%@?auth_token=%@"

#define kCollectionsURLFormat @"http://ipi.mobi/api/v1/users/%@/collections?auth_token=%@"
#define kCreateCollectionURLFormat @"http://ipi.mobi/api/v1/collections?auth_token=%@"
#define kUpdateCollectionURLFormat @"http://ipi.mobi/api/v1/collections/%@?auth_token=%@"
#define kDeleteCollectionURLFormat @"http://ipi.mobi/api/v1/collections/%@?auth_token=%@"

#define kCollectionItemsURLFormat @"http://ipi.mobi/api/v1/collections/%@/items?auth_token=%@"

#define kNeighborhoodsURLFormat @"http://ipi.mobi/api/v1/users/%@/neighbourhoods?auth_token=%@"
#define kCreateNeighborhoodURLFormat @"http://ipi.mobi/api/v1/neighbourhoods?auth_token=%@"
#define kUpdateNeighborhoodURLFormat @"http://ipi.mobi/api/v1/neighbourhoods/%@?auth_token=%@"
#define kDeleteNeighborhoodURLFormat @"http://ipi.mobi/api/v1/neighbourhoods/%@?auth_token=%@"

#define kNeighborhoodItemsURLFormat @"http://ipi.mobi/api/v1/neighbourhoods/%@/items?auth_token=%@"

#define kPlaceEventsURLFormat @"http://ipi.mobi/api/v1/users/%@/place_types?auth_token=%@"
#define kPlaceEventItemsURLFormat @"http://ipi.mobi/api/v1/users/%@/place_types/%@/items?auth_token=%@"

#define kCollectionSubscribeURLFromat @"http://ipi.mobi/api/v1/collections/%@/subscribe?auth_token=%@"
#define kCollectionUnsubscribeURLFromat @"http://ipi.mobi/api/v1/collections/%@/unsubscribe?auth_token=%@"

#define kWishlistItemsURLFormat @"http://ipi.mobi/api/v1/users/%@/wishlist?auth_token=%@"
#define kWishlistFollowersURLFormat @"http://ipi.mobi/api/v1/users/%@/wishlist/subscribers?auth_token=%@"

#define kWishlistSubscribeURLFromat @"http://ipi.mobi/api/v1/users/%@/subscribe_wishlist?auth_token=%@"
#define kWishlistUnsubscribeURLFromat @"http://ipi.mobi/api/v1/users/%@/unsubscribe_wishlist?auth_token=%@"

#define kCollectionURLFormat @"http://ipi.mobi/api/v1/collections/%@?auth_token=%@"
#define kCollectionFollowersURLFormat @"http://ipi.mobi/api/v1/collections/%@/subscribers?auth_token=%@"

#define kItemURLFormat @"http://ipi.mobi/api/v1/items/%@?auth_token=%@"
#define kCreateItemURLFormat @"http://ipi.mobi/api/v1/items?auth_token=%@"
#define kUpdateItemURLFormat @"http://ipi.mobi/api/v1/items/%@?auth_token=%@"
#define kDeleteItemURLFormat @"http://ipi.mobi/api/v1/items/%@?auth_token=%@"

#define kItemNewsArticles @"http://ipi.mobi/api/v1/items/%@/news_articles?auth_token=%@"
#define kMembersThatAddedItemURLFormat @"http://ipi.mobi/api/v1/items/%@/ipi_users?auth_token=%@"
#define kFriendsThatAddedItemURLFormat @"http://ipi.mobi/api/v1/items/%@/ipi_users/friends?auth_token=%@"

#define kCreateCommentURLFormat @"http://ipi.mobi/api/v1/comments?auth_token=%@"
#define kUpdateCommentURLFormat @"http://ipi.mobi/api/v1/comments/%@?auth_token=%@"
#define kDeleteCommentURLFormat @"http://ipi.mobi/api/v1/comments/%@?auth_token=%@"

#define kCollectionSuggestionsURLFormat @"http://ipi.mobi/api/v1/collections/index_with_suggestions?q=%@&auth_token=%@&include_places=%d"
#define kPlaceEventsSuggestionsURLFormat @"http://ipi.mobi/api/v1/neighbourhoods/place_types?auth_token=%@"

#define kSubscribedCollectionsURLFormat @"http://ipi.mobi/api/v1/users/%@/subscriptions?type=collection&auth_token=%@"
#define kSubscribedNeighborhoodsURLFormat @"http://ipi.mobi/api/v1/users/%@/subscriptions?type=neighbourhood&auth_token=%@"
#define kSubscribedWishlistsURLFormat @"http://ipi.mobi/api/v1/users/%@/wishlist_subscriptions?auth_token=%@"

#define kFriendsURLFormat @"http://ipi.mobi/api/v1/users/%@/follows?auth_token=%@"
#define kCreateFriendURLFormat @"http://ipi.mobi/api/v1/followers?auth_token=%@"
#define kDeleteFriendURLFormat @"http://ipi.mobi/api/v1/followers/%@?auth_token=%@"

#define kCommonFriendsURLFormat @"http://ipi.mobi/api/v1/users/%@/common_friends?auth_token=%@"
#define kSearchFriendsURLFormat @"http://ipi.mobi/api/v1/users/search?q=%@&auth_token=%@"

#define kSearchFriendsFromSocialNetworkURLFormat @"http://ipi.mobi/api/v1/users/search/social?auth_token=%@&account_type=%@&ids=%@"
#define kSearchFriendsByEmailURLFormat @"http://ipi.mobi/api/v1/users/search/social?auth_token=%@&emails=%@"

#define kSearchItemsURLFormat @"http://ipi.mobi/api/v1/items/search?q=%@&auth_token=%@&type=%@&extra=%@"
#define kSearchBarocodeURLFormat @"http://ipi.mobi/api/v1/barcodes/name_search?barcode=%@&auth_token=%@"

#define kUserEventsURLFormat @"http://ipi.mobi/api/v1/my_recent_additions?auth_token=%@&page=%d"
#define kUserNetworkEventsURLFormat @"http://ipi.mobi/api/v1/my_activity?auth_token=%@&page=%d"
#define kNetworkEventsURLFormat @"http://ipi.mobi/api/v1/ipi_activity?auth_token=%@&page=%d"
#define kMemberEventsURLFormat @"http://ipi.mobi/api/v1/users/%@/recent_additions?auth_token=%@&page=%d"

#define kPostLoginURL @"http://ipi.mobi/api/v1/users/sign_in"
#define kPostSocialLoginURL @"http://ipi.mobi/api/v1/users/sign_in_social"
#define kPostRegisterURL @"http://ipi.mobi/api/v1/users/sign_up"

#define kPostDeactivateAccountURLFormat @"http://ipi.mobi/api/v1/users/deactivate?auth_token=%@"

#define kPostPushNotificationsRegisterURLFormat @"http://ipi.mobi/api/v1/push_notification?auth_token=%@"

#define kPostFeedbackURLFormat @"http://ipi.mobi/api/v1/feedback?auth_token=%@"
#define kPostAbuseReportURLFormat @"http://ipi.mobi/api/v1/report?auth_token=%@"
#define kPostItemSuggestionURLFormat @"http://ipi.mobi/api/v1/users/%@/suggest_item?auth_token=%@"

#define kPostCollectionsMergeURLFormat @"http://ipi.mobi/api/v1/collections/%@/merge_into/%@?auth_token=%@"

#define kUpdatePasswordURLFormat @"http://ipi.mobi/api/v1/users/%@/update_password?auth_token=%@"
#define kPasswordRecoveryURL @"http://ipi.mobi/users/password/new"

#define kShareWishlistWebURLformat @"http://ipi.mobi/users/%@/wishlist"
#define kShareCollectionWebURLformat @"http://ipi.mobi/collections/%@"
#define kShareItemWebURLformat @"http://ipi.mobi/items/%@"

#endif

#define kMaxRequestRetries 3
#define kDataExpirationTimeInterval -86400 // 24 hours
#define kActivityFeedExpirationTimeInterval -3600 // 1 hour

// HTTP Status Codes

#define kHTTPStatusCodeSuccess 200
#define kHTTPStatusCodeCreateSuccess 201
#define kHTTPStatusCodeAuthorizationError 401
#define kHTTPStatusCodeForbidden 403
#define kHTTPStatusCodeNotFound 404
#define kHTTPStatusCodeServerError 500

// Colors

#define kOrangeColor @[@196.0,@101.0,@21.0,@255.0]
#define kWhiteColor @[@255.0,@255.0,@255.0,@255.0] // form inputs values
#define kGrayColor @[@85.0,@85.0,@85.0,@255.0] // form inputs placeholder color
#define kDarkGrayColor @[@51.0,@51.0,@51.0,@255.0] // connect with text color and top border
#define kVeryDarkGrayColor @[@38.0,@38.0,@38.0,@255.0] // connect with text color and top border
#define kDarkestGrayColor @[@27.0,@27.0,@27.0,@255.0] // connect with text color and top border
#define kFacebookTextColor @[@90.0,@118.0,@177.0,@255.0] // facebook text color
#define	kGoogleTextColor @[@221.0,@75.0,@57.0,@255.0] // google text color
#define	kTwitterTextColor @[@0.0,@153.0,@236.0,@255.0] // twitter text color

// Action Types

#define kActionTypeCreate 71
#define kActionTypeRead 72
#define kActionTypeUpdate 73
#define kActionTypeDelete 74

#define kActionTypeAddFriends 75
#define kActionTypeInviteFriends 76

// Neighborhods

#define kViewModeLocations 0
#define kViewModeEvents 1

// Search

#define kSearchSegmentIndexWeb 0
#define kSearchSegmentIndexiPi 1

// User deatils segments

#define kSegmentIndexProfile 0
#define kSegmentIndexUserActivity 1
#define kSegmentIndexCollections 3
#define kSegmentIndexNeighborhoods 2
#define kSegmentIndexWishlist 4

// Subscription Types

#define kSubscriptionSegmentIndexCollections 0
#define kSubscriptionSegmentIndexNeighborhoods 1
#define kSubscriptionSegmentIndexWishlists 2

// Social

#define kShareOptionFacebook 0
#define kShareOptionTwitter 1
#define kShareOptionGooglePlus 2
#define kShareOptionMail 3

#define kSocialActionTypeLogin 580
#define kSocialActionTypeShare 581
#define kSocialActionTypeFriends 582

#define kSocialNetworkTypeFacebook 170
#define kSocialNetworkTypeTwitter 171
#define kSocialNetworkTypeGooglePlus 172
#define kAddressBookType 173

// Profile

#define kProfileEmailIndex 0
#define kProfileNicknameIndex 1
#define kProfileFirstNameIndex 2
#define kProfileLastNameIndex 3
#define kProfileBirthdateIndex 4
#define kProfileGenderIndex 5
#define kProfileRelationshipStatusIndex 6
#define kProfileLocationIndex 7
#define kProfileZIPCodeIndex 8

// Item

#define kItemRankDefault 0
#define kItemRankOwned 1
#define kItemRankWanted 2
#define kItemRankYearned 3

// Friends

#define kFriendsTypeFollowingMembers 0
#define kFriendsTypeFollowers 1

#define kFriendsTypeItemFriends 2
#define kFriendsTypeItemMembers 3
#define kFriendsTypeSubscribers 4

// Activity

#define kActivityTypeUserNetworkEvents 0
#define kActivityTypeNetworkEvents 1
#define kActivityTypeUserEvents 2

// Settings

#define kNotificationFrequencyInstant 0
#define kNotificationFrequencyDaily 1
#define kNotificationFrequencyWeekly 2

// Login

#define kAuthenticateButtonTypeLogin 0
#define kAuthenticateButtonTypeLogout 1
#define kMinPasswordLength 6

// Alert Codes

#define kAlertCodeSuccess 700
#define kAlertCodeIncompleteTextField 701
#define kAlertCodeRequestError 702
#define kAlertCodeDeleteConfirmation 703
#define kAlertCodeIncompleteEmailTextField 704
#define KAlertCodeImageSearch 705
#define kAlertCodeInavlidOperation 706
#define kAlertCodePushNotification 707
#define kAlertCodeAddBarcode 708