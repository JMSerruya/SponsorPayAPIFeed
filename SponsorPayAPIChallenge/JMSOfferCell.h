//
//  JMSOfferCell.h
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSOfferCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *teaser;
@property (strong, nonatomic) IBOutlet UILabel *payout;
@property (strong, nonatomic) IBOutlet UIImageView *thumb;
- (void)setData:(NSDictionary*)data;
@end
