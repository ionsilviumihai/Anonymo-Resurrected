//
//  UILabel+CustomUIDatePickerLabels.m
//  iPi
//
//  Created by Radu iOne on 3/22/14.
//  Copyright (c) 2014 Sparktech. All rights reserved.
//

#import "UILabel+CustomUIDatePickerLabels.h"
#import <objc/runtime.h>

@implementation UILabel (CustomUIDatePickerLabels)

+ (void)load
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceSelector:@selector(setTextColor:)
                      withNewSelector:@selector(swizzledSetTextColor:)];
        
        [self swizzleInstanceSelector:@selector(willMoveToSuperview:)
                      withNewSelector:@selector(swizzledWillMoveToSuperview:)];
    });
}

// Forces the text colour of the lable to be white only for UIDatePicker and its components
- (void)swizzledSetTextColor:(UIColor *)textColor
{
    if([self view:self hasSuperviewOfClass:[UIDatePicker class]] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerWeekMonthDayView")] ||
       [self view:self hasSuperviewOfClass:NSClassFromString(@"UIDatePickerContentView")])
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) [self swizzledSetTextColor:textColor];
        else [self swizzledSetTextColor:[UIColor whiteColor]];
    }
    else
    {
        // Carry on with the default
        [self swizzledSetTextColor:textColor];
    }
}

// Some of the UILabels haven't been added to a superview yet so listen for when they do.
- (void)swizzledWillMoveToSuperview:(UIView *)newSuperview
{
    [self swizzledSetTextColor:self.textColor];
    [self swizzledWillMoveToSuperview:newSuperview];
}

// Helpers
- (BOOL)view:(UIView *)view hasSuperviewOfClass:(Class)class
{
    if(view.superview)
    {
        if ([view.superview isKindOfClass:class])
        {
            return YES;
        }
        return [self view:view.superview hasSuperviewOfClass:class];
    }
    return NO;
}

+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method newMethod = class_getInstanceMethod(self, newSelector);
    
    BOOL methodAdded = class_addMethod([self class],
                                       originalSelector,
                                       method_getImplementation(newMethod),
                                       method_getTypeEncoding(newMethod));
    
    if (methodAdded)
    {
        class_replaceMethod([self class],
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    }
    else
    {
        method_exchangeImplementations(originalMethod, newMethod);
    }
}

@end
