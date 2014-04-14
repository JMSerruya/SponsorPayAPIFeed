//
//  JMSAPIWrapper.m
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSAPIWrapper.h"
#import "AFNetworking.h"

@implementation JMSAPIWrapper


static JMSAPIWrapper *apiInstance = nil;

+(id)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (apiInstance == nil) {
            apiInstance = [[self alloc] init];
        }
    });
    return apiInstance;
}

#pragma mark -

- (void)requestOffersFromAPI:(NSDictionary *)params callback:(CompletionBlock)callback{

    NSString *request = [NSString stringWithFormat:@"http://api.sponsorpay.com/feed/v1/offers.json"];
    [self performRequest:request parameters:params callback:^(BOOL success, NSData *response, NSError *error) {
        callback(success, response, error);
    }];

}

#pragma mark -

-(void)performRequest:(NSString *)path parameters:(NSDictionary *)params callback:(CompletionBlock)callback
{
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (callback != nil) callback(TRUE,responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        @try {
            if (operation.response.statusCode == 404) {
                NSLog(@"Page doesn't exist");
            }
        } @catch (NSException *ex) {

        }

        if (callback != nil) callback(FALSE,nil,error);
    }];
    [operation start];
}
@end
