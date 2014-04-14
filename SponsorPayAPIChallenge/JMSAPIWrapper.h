//
//  JMSAPIWrapper.h
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"

@interface JMSAPIWrapper : NSObject

typedef void(^CompletionBlock)(BOOL success, NSData * response, NSError * error );
+(id)instance;
@property (nonatomic,strong) AFHTTPRequestSerializer * requestSerializer;
- (void)requestOffersFromAPI:(NSDictionary*)params callback:(CompletionBlock)callback;

@end
