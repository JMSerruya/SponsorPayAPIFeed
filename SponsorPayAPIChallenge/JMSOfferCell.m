//
//  JMSOfferCell.m
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSOfferCell.h"
#import "UIImageView+AFNetworking.h"

@implementation JMSOfferCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(NSDictionary*)data
{
    self.title.text = [data objectForKey:@"title"];
    [self.thumb setImageWithURL:[NSURL URLWithString:[[data objectForKey:@"thumbnail"] objectForKey:@"hires"]]
                      placeholderImage:nil];
    self.payout.text = [NSString stringWithFormat:@"Payout: %@", [data objectForKey:@"payout"]];
    self.teaser.text = [data objectForKey:@"teaser"];
}

@end
