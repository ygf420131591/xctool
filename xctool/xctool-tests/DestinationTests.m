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

#import <SenTestingKit/SenTestingKit.h>

#import "DTiPhoneSimulatorRemoteClient.h"
#import "FakeTaskManager.h"
#import "LaunchHandlers.h"
#import "SimulatorLauncher.h"
#import "Swizzler.h"
#import "XCTool.h"
#import "TestUtil.h"

#import <objc/runtime.h>
#import <objc/message.h>

static Method MethodForClassAndSEL(Class cls, SEL name)
{
  Method match = NULL;
  unsigned int count = 0;
  Method *methods = class_copyMethodList(cls, &count);

  for (unsigned int i = 0; i < count; i++) {
    Method method = methods[i];

    if (sel_isEqual(method_getName(method), name)) {
      match = method;
      break;
    }
  }

  free(methods);
  return match;
}

@interface FakeSimulatorLauncher : NSObject

@property (nonatomic, retain) NSError *launchError;
@property (nonatomic, retain) DTiPhoneSimulatorSessionConfig *sessionConfig;

- (id)initWithSessionConfig:(DTiPhoneSimulatorSessionConfig *)sessionConfig;
- (BOOL)launchAndWaitForExit;

@end

@implementation FakeSimulatorLauncher

- (id)initWithSessionConfig:(DTiPhoneSimulatorSessionConfig *)sessionConfig
{
  if (self = [super init]) {
    self.sessionConfig = sessionConfig;
  }
  return self;
}

- (BOOL)launchAndWaitForExit
{
  return YES;
}

@end

@interface DestinationTests : SenTestCase
@end

@implementation DestinationTests

- (NSArray *)fakeLaunchersWhenRunWithArguments:(NSArray *)arguments
{
  NSMutableArray *fakes = [NSMutableArray array];

  Method NSObjectAllocMethod = class_getClassMethod([NSObject class], @selector(allocWithZone:));
  IMP NSObjectAllocMethodIMP = method_getImplementation(NSObjectAllocMethod);

  IMP allocIMP = imp_implementationWithBlock(^(Class cls, NSZone *zone){
    FakeSimulatorLauncher *fake = [FakeSimulatorLauncher allocWithZone:zone];
    [fakes addObject:fake];
    return (id)fake;
  });

  Class simulatorLauncherMetaClass = objc_getMetaClass(class_getName([SimulatorLauncher class]));
  Method simulatorLauncherAllocMethod = MethodForClassAndSEL(simulatorLauncherMetaClass, @selector(allocWithZone:));

  if (simulatorLauncherAllocMethod == NULL) {
    class_addMethod(simulatorLauncherMetaClass, @selector(allocWithZone:), allocIMP, "@@:");
    simulatorLauncherAllocMethod = MethodForClassAndSEL(simulatorLauncherMetaClass, @selector(allocWithZone:));
  } else {
    method_setImplementation(simulatorLauncherAllocMethod, allocIMP);
  }

  XCTool *tool = [[[XCTool alloc] init] autorelease];
  tool.arguments = arguments;
  [TestUtil runWithFakeStreams:tool];

  // Restore the original alloc implementation.
  method_setImplementation(simulatorLauncherAllocMethod, NSObjectAllocMethodIMP);
  imp_removeBlock(allocIMP);

  return fakes;
}

- (NSArray *)fakeLaunchersWhenRunWithArguments:(NSArray *)arguments
                                     onProject:(NSString *)project
{
  NSString *projectPath = [[NSString stringWithFormat:@"%@/DestinationTests/%@/%@.xcodeproj",
                            TEST_DATA,
                            project,
                            project] stringByStandardizingPath];
  NSString *projectBuildSettingsPath = [[NSString stringWithFormat:@"%@/DestinationTests/%@-showBuildSettings.txt",
                                         TEST_DATA,
                                         project] stringByStandardizingPath];
  NSString *testTargetBuildSettingsPath = [[NSString stringWithFormat:@"%@/DestinationTests/%@-%@Tests-showBuildSettings.txt",
                                            TEST_DATA,
                                            project,
                                            project] stringByStandardizingPath];

  __block NSArray *fakes;

  [[FakeTaskManager sharedManager] runBlockWithFakeTasks:^{
    [[FakeTaskManager sharedManager] addLaunchHandlerBlocks:@[
                                                              // Make sure -showBuildSettings returns some data
                                                              [LaunchHandlers handlerForShowBuildSettingsWithProject:projectPath
                                                                                                              scheme:project
                                                                                                        settingsPath:projectBuildSettingsPath],
                                                              // We're going to call -showBuildSettings on the test target.
                                                              [LaunchHandlers handlerForShowBuildSettingsWithProject:projectPath
                                                                                                              target:[project stringByAppendingString:@"Tests"]
                                                                                                        settingsPath:testTargetBuildSettingsPath
                                                                                                                hide:NO],
                                                              [LaunchHandlers handlerForOtestQueryReturningTestList:@[@"SomeClass/testMethod"]],
                                                              ]];

    fakes = [self fakeLaunchersWhenRunWithArguments:
                      [@[@"-project", projectPath,
                        @"-scheme", project,
                        @"-sdk", @"iphonesimulator",
                        @"-IDEBuildLocationStyle=Custom",
                        @"-IDECustomBuildLocationType=RelativeToWorkspace",
                        @"-IDECustomBuildIntermediatesPath=Build/Intermediates",
                        @"-IDECustomBuildProductsPath=Build/Products",
                        @"run-tests",
                        ] arrayByAddingObjectsFromArray:arguments]];
    [fakes retain];
  }];

  return [fakes autorelease];
}

- (void)testDestinationNameFlowsToSimulatorLauncherDeviceName
{
  NSArray *fakes = [self fakeLaunchersWhenRunWithArguments:@[@"-destination", @"name=iPhone Retina (4-inch)"]
                                                 onProject:@"ios-iphone"];
  // One for the mobile-installation-helper, one for the actual test.
  assertThatInteger([fakes count], equalToInteger(2));

  assertThat([[fakes[0] sessionConfig] simulatedDeviceInfoName], equalTo(@"iPhone Retina (4-inch)"));
  assertThat([[fakes[1] sessionConfig] simulatedDeviceInfoName], equalTo(@"iPhone Retina (4-inch)"));
}

@end
