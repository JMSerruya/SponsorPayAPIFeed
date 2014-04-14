//
//  JMSResultsViewController.m
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSResultsViewController.h"
#import "JMSAPIWrapper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "JMSOfferCell.h"

@interface JMSResultsViewController ()

@end

@implementation JMSResultsViewController

NSMutableArray *_results;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _results = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [SVProgressHUD showWithStatus:@"Requesting"];
    UINib * feedCellNib = [UINib nibWithNibName:@"OfferFeedItem" bundle:nil];
    [self.tableView registerNib:feedCellNib forCellReuseIdentifier:@"JMSOfferCell"];
    NSMutableDictionary* params = [[JMSAPIWrapper instance] generateRequestParamsWithDictionary:nil];
    [[JMSAPIWrapper instance] requestOffersFromAPI:params callback:^(BOOL success, NSDictionary *response, NSError *error) {
        if(success) {
            _results = [response objectForKey:@"offers"];
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            NSLog(@"%@", error.description);
            [SVProgressHUD dismiss];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _results.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JMSOfferCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"JMSOfferCell" forIndexPath:indexPath];
    [cell setData:[_results objectAtIndex:indexPath.row]];
    return cell;

    
    // Configure the cell...
    
    return cell;
}
@end
