//
//  UIColor+RBGA256.m
//  iPi
//
//  Created by Radu Ionescu on 8/28/13.
//  Copyright (c) 2013 Sparktech. All rights reserved.
//

#import "UIColor+RBGA256.h"

@implementation UIColor (RBGA256)

+ (UIColor *)colorWith256RBGAArray:(NSArray *)rgbaArray
{
    return [UIColor colorWithRed:[rgbaArray[0] floatValue] / 255.0
                           green:[rgbaArray[1] floatValue] / 255.0
                            blue:[rgbaArray[2] floatValue] / 255.0
                           alpha:[rgbaArray[3] floatValue] / 255.0];
}

+ (UIColor *)colorWith256Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red / 255.0
                           green:green / 255.0
                            blue:blue / 255.0
                           alpha:alpha / 255.0];
}

@end
