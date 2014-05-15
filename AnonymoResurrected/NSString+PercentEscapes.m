//
//  NSString+PercentEscapes.m
//  Torah
//
//  Created by Radu Ionescu on 5/24/13.
//
//

#import "NSString+PercentEscapes.h"

@implementation NSString (PercentEscapes)

- (NSString *)stringByAddingPercentEscapes
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) self, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

- (NSString *)stringByRemovingPercentEscapes
{
    return (NSString *) CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef) self, CFSTR(""), kCFStringEncodingUTF8));
}

@end
