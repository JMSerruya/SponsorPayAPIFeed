//
//  JMSResultsViewController.m
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSResultsViewController.h"
#import "JMSAPIWrapper.h"
#import <AdSupport/ASIdentifierManager.h>

@interface JMSResultsViewController ()

@end

@implementation JMSResultsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    NSMutableDictionary* params = [self generateRequestParams];
    [[JMSAPIWrapper instance] requestOffersFromAPI:params callback:^(BOOL success, NSData *response, NSError *error) {
        if(success) {
            NSLog(@"%@", response);
        } else {
            NSLog(@"%@", error.description);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(NSMutableDictionary*) generateRequestParams {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setObject:@"json" forKey:@"format"];
    [params setObject:@"2070" forKey:@"appid"];
    [params setObject:@"DE" forKey:@"locale"];
    [params setObject:@"spiderman" forKey:@"uid"];
    [params setObject:@"109.235.143.113" forKey:@"ip"];
    [params setObject:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] forKey:@"device_id"];
    [params setObject:@"1c915e3b5d42d05136185030892fbb846c278927" forKey:@"apikey"];
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
    NSLog(@"%@", hash);

    //finally add the APIkey

    hash = [NSString stringWithFormat:@"%@%@", hash, [params objectForKey:@"apikey"]];

    NSLog(@"%@", hash);

    //NSLog(@"%@", objects);

    return hash;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
@end
