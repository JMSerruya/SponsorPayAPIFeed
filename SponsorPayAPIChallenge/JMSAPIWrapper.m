//
//  JMSAPIWrapper.m
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSAPIWrapper.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Hashes.h"
#import <AdSupport/ASIdentifierManager.h>

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

- (void)requestOffersFromAPI:(NSMutableDictionary *)params callback:(CompletionBlock)callback{

    NSString *request = [NSString stringWithFormat:@"http://api.sponsorpay.com/feed/v1/offers.json?"];
    [params removeObjectForKey:@"apikey"];
    request = [self createURLWithBaseURL:request andParams:params];
    [self performRequest:request parameters:params callback:^(BOOL success, NSDictionary *response, NSError *error) {
        callback(success, response, error);
    }];

}

-(NSString*)createURLWithBaseURL:(NSString*)url andParams:(NSMutableDictionary*)params{

    NSArray * keys = [params allKeys];
    NSArray * objects = [params objectsForKeys:keys notFoundMarker: [NSNull null]];
    //get keys for those objects and start creating the string
    for(id object in objects) {
        NSArray *temp = [params allKeysForObject:object];
        NSString *key = [temp objectAtIndex:0];
        url = [NSString stringWithFormat:@"%@%@=%@&", url, key, object];
    }

    return url;
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

-(NSMutableDictionary*) generateRequestParamsWithDictionary:(NSMutableDictionary*)params {
    NSMutableDictionary *resultParams = [[NSMutableDictionary alloc] init];

    [resultParams setObject:@"json" forKey:@"format"];
    [resultParams setObject:@"2070" forKey:@"appid"];
    [resultParams setObject:@"DE" forKey:@"locale"];
    [resultParams setObject:@"spiderman" forKey:@"uid"];
    [resultParams setObject:@"109.235.143.113" forKey:@"ip"];
    [resultParams setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"device_id"];
    [resultParams setObject:@"1c915e3b5d42d05136185030892fbb846c278927" forKey:@"apikey"];
    NSTimeInterval  now = [[NSDate date] timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%f", now];
    [resultParams setObject:intervalString forKey:@"timestamp"];
    [resultParams setObject:@"112" forKey:@"offer_types"];

    [resultParams setObject:[self generateHashkeyWithDictionary:resultParams] forKey:@"hashkey"];
    return resultParams;
}

-(NSString*) generateHashkeyWithDictionary:(NSMutableDictionary*)params {
    //sort Dictionary by Keys
    NSArray * sortedKeys = [[params allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];

    NSArray * objects = [params objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    //get keys for those objects and start creating the string
    NSString* hash = [[NSString alloc] init];
    for(id object in objects) {
        NSArray *temp = [params allKeysForObject:object];
        NSString *key = [temp objectAtIndex:0];
        //ignore the apikeyObject
        if(![key isEqualToString:@"apikey"]) {
            hash = [NSString stringWithFormat:@"%@%@=%@&", hash, key, object];
        }
    }

    //finally add the APIkey

    hash = [NSString stringWithFormat:@"%@%@", hash, [params objectForKey:@"apikey"]];

    NSLog(@"%@", hash);

    //NSLog(@"%@", objects);
    return [hash sha1];
    
}


@end
