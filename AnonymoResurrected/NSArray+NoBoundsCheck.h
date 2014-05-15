//
//  NSArray+NoRangeCheck.h
//  Torah
//
//  Created by Radu iOne on 12/20/12.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (NoBoundsCheck)

- (id)objectAtIndex:(NSUInteger)index returnNilForIndexOutOfBounds:(BOOL)returnNilForIndexOutOfBounds;

@end
