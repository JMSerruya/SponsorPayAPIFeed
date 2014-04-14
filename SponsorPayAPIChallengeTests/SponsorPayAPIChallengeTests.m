//
//  SponsorPayAPIChallengeTests.m
//  SponsorPayAPIChallengeTests
//
//  Created by Juan Manuel Serruya on 4/14/14.
//  Copyright (c) 2014 Juan Manuel Serruya. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JMSAPIWrapper.h"

@interface SponsorPayAPIChallengeTests : XCTestCase

@end

@implementation SponsorPayAPIChallengeTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAPIWrapperWithNilParameters
{
    [[JMSAPIWrapper instance] requestOffersFromAPI:nil callback:nil];
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
