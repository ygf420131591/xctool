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

#import "SchemeGenerator.h"

#import "XCToolUtil.h"

@implementation SchemeGenerator {
  NSMutableArray *_buildables;
  NSMutableSet *_projectPaths;
}

+ (SchemeGenerator *)schemeGenerator
{
  return [[[SchemeGenerator alloc] init] autorelease];
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _buildables = [[NSMutableArray array] retain];
    _projectPaths = [[NSMutableSet set] retain];
  }
  return self;
}

- (void)dealloc
{
  [_buildables release];
  [_projectPaths release];
  [super dealloc];
}

- (void)addBuildableWithID:(NSString *)identifier
                 inProject:(NSString *)projectPath
{
  [self addBuildableWithID:identifier target:nil executable:nil type:nil inProject:projectPath];
}

- (void)addBuildableWithID:(NSString *)identifier
                    target:(NSString *)target
                executable:(NSString *)executable
                      type:(NSString *)type
                 inProject:(NSString *)projectPath
{
  NSString *absPath = [[[NSURL fileURLWithPath:projectPath] URLByStandardizingPath] path];
  NSMutableDictionary *buildable = [NSMutableDictionary dictionary];
  if (identifier != nil) [buildable setObject:identifier forKey:@"id"];
  if (absPath != nil)    [buildable setObject:absPath forKey:@"project"];
  if (target != nil)     [buildable setObject:target forKey:@"target"];
  if (executable != nil) [buildable setObject:executable forKey:@"executable"];
  if (type != nil)       [buildable setObject:type forKey:@"type"];
  [_buildables addObject:buildable];
}

- (void)addProjectPathToWorkspace:(NSString *)projectPath
{
  NSString *absPath = [[[NSURL fileURLWithPath:projectPath] URLByStandardizingPath] path];
  [_projectPaths addObject:absPath];
}

- (NSString *)writeWorkspaceNamed:(NSString *)name
{
  NSString *tempDir = TemporaryDirectoryForAction();
  if ([self writeWorkspaceNamed:name to:tempDir]) {
    return [tempDir stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"xcworkspace"]];
  }

  return nil;
}

- (BOOL)writeWorkspaceNamed:(NSString *)name
                         to:(NSString *)destination
{
  NSError *err = nil;

  NSString *workspacePath = [destination stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"xcworkspace"]];

  NSFileManager *fileManager = [NSFileManager defaultManager];
  [fileManager createDirectoryAtPath:workspacePath
         withIntermediateDirectories:NO
                          attributes:@{}
                               error:&err];
  if (err) {
    goto err;
  }

  [[[self _workspaceDocument] XMLStringWithOptions:NSXMLNodePrettyPrint]
   writeToFile:[workspacePath stringByAppendingPathComponent:@"contents.xcworkspacedata"]
   atomically:NO
   encoding:NSUTF8StringEncoding
   error:&err];
  if (err) {
    goto err;
  }

  NSString *schemeDirectoryName = [name stringByAppendingPathExtension:@"xcscheme"];
  NSString * schemeDirPath = [workspacePath stringByAppendingPathComponent:[NSString stringWithFormat:@"xcshareddata/xcschemes/%@", schemeDirectoryName]];

  [self writeSchemeTo:schemeDirPath error:&err];

  if (err != nil) {
    goto err;
  }

  return YES;

err:
  NSLog(@"Error creating temporary workspace: %@", err.localizedFailureReason);
  return NO;
}

- (BOOL)writeSchemeTo:(NSString *)destination {
  NSError *error = nil;

  [self writeSchemeTo:destination error:&error];

  return (error == nil);
}

- (void)writeSchemeTo:(NSString *)destination error:(NSError **)outError {
  NSString * schemeDirPath = [destination stringByDeletingLastPathComponent];
  NSError *error = nil;

  [[NSFileManager defaultManager] createDirectoryAtPath:schemeDirPath
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:&error];

  if (error == nil) {
    NSString *schemeContent = [[self _schemeDocument] XMLStringWithOptions:NSXMLNodePrettyPrint];

    [schemeContent writeToFile:destination
                    atomically:NO
                      encoding:NSUTF8StringEncoding
                         error:&error];
  }

  if (error != nil) {
    NSLog(@"Error creating the scheme file: %@", error.localizedFailureReason);
    outError = &error;
  }
}

- (NSXMLDocument *)_workspaceDocument
{
  NSXMLElement *root =
  [NSXMLNode
   elementWithName:@"Workspace"
   children:@[]
   attributes:@[[NSXMLNode attributeWithName:@"version" stringValue:@"1.0"]]];

  for (NSString *path in _projectPaths) {
    NSXMLElement *fileRef =
    [NSXMLNode
     elementWithName:@"FileRef" children:@[]
     attributes:@[[NSXMLNode attributeWithName:@"location"
                                   stringValue:[@"absolute:" stringByAppendingString:path]]]];
    [root addChild:fileRef];
  }

  return [NSXMLDocument documentWithRootElement:root];
}

NSArray *attributeListFromDict(NSDictionary *dict) {
  NSMutableArray *array = [NSMutableArray array];
  [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    [array addObject:[NSXMLNode attributeWithName:key stringValue:obj]];
  }];
  return array;
}

- (NSXMLDocument *)_schemeDocument
{
  NSXMLElement *buildActionEntries = [NSXMLNode elementWithName:@"BuildActionEntries"];
  NSXMLElement *testableEntries = [NSXMLNode elementWithName:@"Testables"];
  NSXMLElement *testableReferenceEntries = [NSXMLNode elementWithName:@"TestableReference"];
  NSXMLElement *macroExpansionEntries = [NSXMLNode elementWithName:@"MacroExpansion"];
  NSXMLElement *productRunnableEntries = [NSXMLNode elementWithName:@"BuildableProductRunnable"];
  BOOL targetIsNonRunnable = ([_buildables count] == 1 && [@[@"test", @"library"] containsObject:_buildables[0][@"type"]]);
  BOOL targetIsTest = (targetIsNonRunnable && [_buildables[0][@"type"] isEqualToString:@"test"]);

  for (NSDictionary *buildable in _buildables) {
    NSString *project = [buildable[@"project"] lastPathComponent];
    NSString *container = [NSString stringWithFormat:@"container:%@", project];
    NSXMLElement *buildableReference =
    [NSXMLNode
     elementWithName:@"BuildableReference" children:@[]
     attributes:attributeListFromDict(@{
                                      @"BuildableIdentifier": @"primary",
                                      @"BlueprintIdentifier": buildable[@"id"],
                                      @"ReferencedContainer": container,
                                      @"BlueprintName": buildable[@"target"] ? buildable[@"target"] : @"",
                                      @"BuildableName": buildable[@"executable"] ? buildable[@"executable"] : @"",
                                      })];

    NSXMLElement *buildActionEntry =
    [NSXMLNode
     elementWithName:@"BuildActionEntry"
     children:@[buildableReference]
     attributes:attributeListFromDict(@{
                                      @"buildForRunning": @"YES",
                                      @"buildForTesting": @"YES",
                                      @"buildForProfiling": @"YES",
                                      @"buildForArchiving": @"YES",
                                      @"buildForAnalyzing": @"YES",
                                      })];

    if (!targetIsTest) [buildActionEntries addChild:buildActionEntry];
    [testableReferenceEntries addChild:[[buildableReference copy] autorelease]];
    [macroExpansionEntries addChild:[[buildableReference copy] autorelease]];
    [productRunnableEntries addChild:[[buildableReference copy] autorelease]];
  }

  if (targetIsTest) [testableEntries addChild:testableReferenceEntries];

  NSXMLElement *buildAction =
  [NSXMLNode
   elementWithName:@"BuildAction"
   children:targetIsTest ? nil : @[buildActionEntries]
   attributes:@[[NSXMLNode attributeWithName:@"parallelizeBuildables"
                                 stringValue:_parallelizeBuildables ? @"YES" : @"NO"],
                [NSXMLNode attributeWithName:@"buildImplicitDependencies"
                                 stringValue:_buildImplicitDependencies ? @"YES" : @"NO"]]];

  NSXMLElement *testAction =
  [NSXMLNode
   elementWithName:@"TestAction"
   children:targetIsNonRunnable ? @[testableEntries] : @[testableEntries, macroExpansionEntries]
   attributes:attributeListFromDict(@{
                                    @"selectedDebuggerIdentifier": @"Xcode.DebuggerFoundation.Debugger.LLDB",
                                    @"selectedLauncherIdentifier": @"Xcode.DebuggerFoundation.Launcher.LLDB",
                                    @"shouldUseLaunchSchemeArgsEnv": @"YES",
                                    @"buildConfiguration": @"Debug",
                                    })];

  NSXMLElement *launchAction =
  [NSXMLNode
   elementWithName:@"LaunchAction"
   children:targetIsNonRunnable ? @[[NSXMLNode elementWithName:@"AdditionalOptions"]] : @[[NSXMLNode elementWithName:@"AdditionalOptions"], [[productRunnableEntries copy] autorelease]]
   attributes:attributeListFromDict(@{
                                    @"selectedDebuggerIdentifier": @"Xcode.DebuggerFoundation.Debugger.LLDB",
                                    @"selectedLauncherIdentifier": @"Xcode.DebuggerFoundation.Launcher.LLDB",
                                    @"launchStyle": @"0",
                                    @"useCustomWorkingDirectory": @"NO",
                                    @"buildConfiguration": @"Debug",
                                    @"ignoresPersistentStateOnLaunch": @"NO",
                                    @"debugDocumentVersioning": @"YES",
                                    @"allowLocationSimulation": @"YES",
                                    })];

  NSXMLElement *profileAction =
  [NSXMLNode
   elementWithName:@"ProfileAction"
   children:targetIsNonRunnable ? nil : @[productRunnableEntries]
   attributes:attributeListFromDict(@{
                                    @"shouldUseLaunchSchemeArgsEnv": @"YES",
                                    @"savedToolIdentifier": @"",
                                    @"useCustomWorkingDirectory": @"NO",
                                    @"buildConfiguration": @"Release",
                                    @"debugDocumentVersioning": @"YES",
                                    })];

  NSXMLElement *analyzeAction =
  [NSXMLNode
   elementWithName:@"AnalyzeAction"
   children:nil
   attributes:attributeListFromDict(@{
                                    @"buildConfiguration": @"Debug",
                                    })];

  NSXMLElement *archiveAction =
  [NSXMLNode
   elementWithName:@"ArchiveAction"
   children:nil
   attributes:attributeListFromDict(@{
                                    @"buildConfiguration": @"Release",
                                    @"revealArchiveInOrganizer": @"YES",
                                    })];

  NSXMLElement *root =
  [NSXMLNode
   elementWithName:@"Scheme"
   children:@[buildAction, testAction, launchAction, profileAction, analyzeAction, archiveAction]
   attributes:attributeListFromDict(@{@"LastUpgradeVersion": @"0460", @"version": @"1.3"})];

  NSXMLDocument *document = [NSXMLDocument documentWithRootElement:root];
  [document setVersion: @"1.0"];
  [document setCharacterEncoding: @"UTF-8"];
  [document setStandalone:YES];

  return document;
}

@end
