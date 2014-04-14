//
//  JMSViewController.h
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *apikeyTextField;
@property (strong, nonatomic) IBOutlet UITextField *appidTextField;
@property (strong, nonatomic) IBOutlet UITextField *pub0TextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *uidTextField;

@end
