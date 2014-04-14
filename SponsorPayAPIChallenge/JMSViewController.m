//
//  JMSViewController.m
//  SponsorPayAPIChallenge
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import "JMSViewController.h"

@interface JMSViewController ()

@end

@implementation JMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.uidTextField.delegate = self;
    self.apikeyTextField.delegate = self;
    self.appidTextField.delegate = self;
    self.pub0TextField.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// called when textField start editting.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //activeField = textField;
    [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-200) animated:YES];
}



// called when click on the retun button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];

    if (nextResponder) {
        [self.scrollView setContentOffset:CGPointMake(0,textField.center.y-200) animated:YES];
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
        [textField resignFirstResponder];
        return YES;
    }

    return NO;
}

@end
