//
//  Utility.h
//  iPi
//
//  Created by Radu Ionescu on 9/3/13.
//  Copyright (c) 2013 Sparktech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Utility : NSObject

+ (NSString *)uniqueIdentifier;
+ (UIImage *)cropImage:(UIImage *)image withRect:(CGRect)cropRect;
+ (UIImage *)cropImage:(UIImage *)image toFitInSize:(CGSize)cropSize;

+ (NSString *)serverDateTimeString:(NSString *)dateString;
+ (NSString *)formatDateTimeString:(NSString *)dateString;
+ (NSString *)formatDateString:(NSString *)dateString;
+ (NSString *)formatDateWithoutYearString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)extractDateFromDateTimeString:(NSString *)dateTimeString;
+ (NSString *)timeIntervalSinceDateTimeString:(NSString *)dateString;

+ (NSString *)base64StringFromData:(NSData *)data;

+ (NSString *)deviceIP;

+ (void)playAddActionSound;

+ (id)removeNullObjectsFromObject:(id)rootObject;

@end
