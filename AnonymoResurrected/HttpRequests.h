//
//  HttpRequests.h
//  AnonymoResurrected
//
//  Created by Ion Silviu-Mihai on 15/05/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequests : NSObject

+(void)getAllUserssuccess:(void (^)(id data))successHandler;

@end
