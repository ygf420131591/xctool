//
//  ios_iphoneTests.m
//  ios-iphoneTests
//
//  Created by Fred Potter on 12/12/13.
//  Copyright (c) 2013 Facebook, Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface ios_iphoneTests : SenTestCase

@end

@implementation ios_iphoneTests

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

- (void)testExample
{
  NSLog(@"model: %@", [[UIDevice currentDevice] model]);
  NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
}

@end
