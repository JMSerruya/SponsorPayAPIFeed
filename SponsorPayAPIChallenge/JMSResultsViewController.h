//
//  JMSResultsViewController.h
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSResultsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thumb;
@property (strong, nonatomic) IBOutlet UILabel *teaserLabel;
@property (strong, nonatomic) IBOutlet UILabel *payoutLabel;

@end
