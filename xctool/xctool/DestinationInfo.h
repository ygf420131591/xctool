//
// Copyright 2013 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

@interface DestinationInfo : NSObject {
}

/**
 Either i386 or x86_64. (OS X only)
 */
@property (nonatomic, retain) NSString *arch;

/**
 Device identifier to test on. (iOS Device only)
 */
@property (nonatomic, retain) NSString *identifier;

/**
 Name of the device to use, or name of the simulator device to use. (iOS Simulator or Device)
 */
@property (nonatomic, retain) NSString *name;

/**
 One of 'OS X', 'iOS', 'iOS Simulator'. (All platforms)
 */
@property (nonatomic, retain) NSString *platform;

/**
 Version of iOS to simulate.  Can be a version like '6.0', or 'latest' to use the
 most recent iOS supported. (iOS Simulator only)
 */
@property (nonatomic, retain) NSString *os;

/**
 Returns a parsed DestinationInfo instance.
 */
+ (instancetype)parseFromString:(NSString *)str error:(NSString **)error;

/**
 Returns the comma-separated form, suitable for passing straight to xcodebuild.
 */
- (NSString *)commaSeparatedList;

@end
