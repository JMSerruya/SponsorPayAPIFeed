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
    self.apiKey = [params objectForKey:@"apikey"];
    self.hash = [params objectForKey:@"hashkey"];
    [params removeObjectForKey:@"apikey"];
    request = [self createURLWithBaseURL:request andParams:params];
    [self performRequest:request parameters:params callback:^(BOOL success, NSDictionary *response, NSError *error) {
        NSLog(@"%@", response);
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
        NSDictionary *responseHeaders =  [[operation response] allHeaderFields];
        NSString *responseSignature = [responseHeaders objectForKey:@"X-Sponsorpay-Response-Signature"];
        if ([self validateResponseWithSignature:responseSignature andBody:[operation responseString]]) {
            if (callback != nil) callback(TRUE,responseObject,nil);
        } else {
            NSLog(@"INVALID RESPONSE, return nil anyway, should probably create an instance of NSerror :D");
            if (callback != nil) callback(FALSE,nil,nil);
        }

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

-(BOOL)validateResponseWithSignature:(NSString*)responseSignature andBody:(NSString*)body {
    NSString *concatString = [NSString stringWithFormat:@"%@%@", body, self.apiKey];
    NSString *hashedString = [concatString sha1];
    if([responseSignature isEqualToString:hashedString]){
        return YES;
    }
    return NO;
}

-(NSMutableDictionary*) generateRequestParamsWithDictionary:(NSMutableDictionary*)params {
     if (params == nil) {
     //if nil add default values.
         params = [[NSMutableDictionary alloc] init];
         [params setObject:@"2070" forKey:@"appid"];
         [params setObject:@"spiderman" forKey:@"uid"];
         [params setObject:@"1c915e3b5d42d05136185030892fbb846c278927" forKey:@"appid"];
     }
    //JMS hardcoding stuff
    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"DE" forKey:@"locale"];
    [params setObject:@"109.235.143.113" forKey:@"ip"];
    [params setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"device_id"];
    NSTimeInterval  now = [[NSDate date] timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%f", now];
    [params setObject:intervalString forKey:@"timestamp"];
    [params setObject:@"112" forKey:@"offer_types"];

    [params setObject:[self generateHashkeyWithDictionary:params] forKey:@"hashkey"];
    return params;
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

    return [hash sha1];
    
}


@end
