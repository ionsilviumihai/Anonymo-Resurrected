//
//  NSString+PercentEscapes.h
//  Torah
//
//  Created by Radu Ionescu on 5/24/13.
//
//

#import <Foundation/Foundation.h>

@interface NSString (PercentEscapes)

- (NSString *)stringByAddingPercentEscapes;
- (NSString *)stringByRemovingPercentEscapes;

@end
