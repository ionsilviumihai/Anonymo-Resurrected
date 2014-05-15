//
//  NSArray+NoRangeCheck.m
//  Torah
//
//  Created by Radu iOne on 12/20/12.
//
//

#import "NSArray+NoBoundsCheck.h"

@implementation NSArray (NoRangeCheck)

- (id)objectAtIndex:(NSUInteger)index returnNilForIndexOutOfBounds:(BOOL)returnNilForIndexOutOfBounds
{
    if (index < self.count) return self[index];
    return nil;
}

@end
