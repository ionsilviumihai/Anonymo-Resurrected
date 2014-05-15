//
//  UIColor+RBGA256.h
//  iPi
//
//  Created by Radu Ionescu on 8/28/13.
//  Copyright (c) 2013 Sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RBGA256)

+ (UIColor *)colorWith256RBGAArray:(NSArray *)rgbaArray;
+ (UIColor *)colorWith256Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
