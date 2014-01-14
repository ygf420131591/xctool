#import <SenTestingKit/SenTestingKit.h>

#import "JSONCompilationDatabaseReporter.h"
#import "Reporter+Testing.h"

@interface JSONCompilationDatabaseReporterTests : SenTestCase
@end

@implementation JSONCompilationDatabaseReporterTests

- (void)testBuild
{
  NSData *outputData = [JSONCompilationDatabaseReporter
                        outputDataWithEventsFromFile:TEST_DATA @"TestProject-Library-TestProject-LibraryTests-build.txt"];
  NSError *jsonSerializationError;
  // we should compare json objects (not strings from data) because json format does not specify order of keys
  id jsonObject = [NSJSONSerialization JSONObjectWithData:outputData options:0 error:&jsonSerializationError];
  STAssertNotNil(jsonObject, @"cannot deserialize events file %@", jsonSerializationError.localizedDescription);
  STAssertTrue([jsonObject isKindOfClass:[NSArray class]], @"compilation database json object should be an array");
  NSArray *jsonArray = (NSArray *)jsonObject;
  NSArray *expectedJsonArray = @[
                                 @{
                                    @"command" : @"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -arch armv7s -fmessage-length=0 -std=gnu99 -Wno-trigraphs -fpascal-strings -Os -Wno-missing-field-initializers -Wno-missing-prototypes -Wreturn-type -Wno-implicit-atomic-properties -Wno-receiver-is-weak -Wduplicate-method-match -Wformat -Wno-missing-braces -Wparentheses -Wswitch -Wno-unused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wno-constant-conversion -Wno-int-conversion -Wno-enum-conversion -Wno-shorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wno-undeclared-selector -Wno-deprecated-implementations -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -g -Wno-sign-conversion -miphoneos-version-min=6.0 -iquote /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-generated-files.hmap -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-own-target-headers.hmap -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-all-target-headers.hmap -iquote /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-project-headers.hmap -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Products/Release-iphoneos/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources/armv7s -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources -F/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Products/Release-iphoneos -include /Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject-Library-Prefix.pch -MMD -MT dependencies -MF /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7s/TestProject_Library.d --serialize-diagnostics /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7s/TestProject_Library.dia -c /Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m -o /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7s/TestProject_Library.o",
                                    @"directory" : @"/Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library",
                                    @"file" : @"/Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m"
                                  },
                                 @{
                                     @"command" : @"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -arch armv7 -fmessage-length=0 -std=gnu99 -Wno-trigraphs -fpascal-strings -Os -Wno-missing-field-initializers -Wno-missing-prototypes -Wreturn-type -Wno-implicit-atomic-properties -Wno-receiver-is-weak -Wduplicate-method-match -Wformat -Wno-missing-braces -Wparentheses -Wswitch -Wno-unused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wno-constant-conversion -Wno-int-conversion -Wno-enum-conversion -Wno-shorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wno-undeclared-selector -Wno-deprecated-implementations -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.1.sdk -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -g -Wno-sign-conversion -miphoneos-version-min=6.0 -iquote /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-generated-files.hmap -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-own-target-headers.hmap -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-all-target-headers.hmap -iquote /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-project-headers.hmap -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Products/Release-iphoneos/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources/armv7 -I/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources -F/Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Products/Release-iphoneos -include /Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject-Library-Prefix.pch -MMD -MT dependencies -MF /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7/TestProject_Library.d --serialize-diagnostics /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7/TestProject_Library.dia -c /Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m -o /Users/fpotter/Library/Developer/Xcode/DerivedData/TestProject-Library-fsljtldcjttttseqpqryyyihhqjz/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7/TestProject_Library.o",
                                     @"directory" : @"/Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library",
                                     @"file" : @"/Users/fpotter/fb/git/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m"
                                   },
                                ];
  STAssertEqualObjects(expectedJsonArray, jsonArray, @"compile_commands.json should match");
}

- (void)testBuildObjectCpp
{
  NSData *outputData = [JSONCompilationDatabaseReporter
                      outputDataWithEventsFromFile:TEST_DATA @"TestProject-Library-TestProject-LibraryTests-build-objc++.txt"];
    
  NSError *jsonSerializationError;
  // we should compare json objects (not strings from data) because json format does not specify order of keys
  id jsonObject = [NSJSONSerialization JSONObjectWithData:outputData options:0 error:&jsonSerializationError];
  STAssertNotNil(jsonObject, @"cannot deserialize events file %@", jsonSerializationError.localizedDescription);
  STAssertTrue([jsonObject isKindOfClass:[NSArray class]], @"compilation database json object should be an array");
  NSArray *jsonArray = (NSArray *)jsonObject;
  NSArray *expectedJsonArray = @[
                                  @{
                                      @"command" : @"/Volumes/DATA/llvm33/bin/clang -x objective-c -arch x86_64 -fmessage-length=0 -std=gnu99 -fobjc-arc -Wno-trigraphs -fpascal-strings -O0 -Wno-missing-field-initializers -Wno-missing-prototypes -Wno-implicit-atomic-properties -Wno-receiver-is-weak -Wduplicate-method-match -Wformat -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wenum-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wno-deprecated-implementations -DDEBUG=1 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk -fasm-blocks -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -mmacosx-version-min=10.8 -g -Wno-sign-conversion -iquote /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-generated-files.hmap -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-own-target-headers.hmap -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-all-target-headers.hmap -iquote /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-project-headers.hmap -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Products/Debug/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/DerivedSources/x86_64 -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/DerivedSources -F/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Products/Debug -fsanitize=address -include /Users/yujo/Documents/MyNewTest/MyNewTest/MyNewTest-Prefix.pch -MMD -MT dependencies -MF /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/Objects-normal/x86_64/MyNewTest.d -c /Users/yujo/Documents/MyNewTest/MyNewTest/MyNewTest.m -o /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/Objects-normal/x86_64/MyNewTest.o",
                                      @"directory" : @"/Users/yujo/Documents/MyNewTest",
                                      @"file" : @"/Users/yujo/Documents/MyNewTest/MyNewTest/MyNewTest.m"
                                   },
                                  @{
                                      @"command" : @"/Volumes/DATA/llvm33/bin/clang -x objective-c++ -arch x86_64 -fmessage-length=0 -std=gnu++11 -stdlib=libc++ -fobjc-arc -Wno-trigraphs -fpascal-strings -O0 -Wno-missing-field-initializers -Wno-missing-prototypes -Wno-implicit-atomic-properties -Wno-receiver-is-weak -Wno-non-virtual-dtor -Wno-overloaded-virtual -Wno-exit-time-destructors -Wduplicate-method-match -Wformat -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wenum-conversion -Wshorten-64-to-32 -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wno-deprecated-implementations -Wno-c++11-extensions -DDEBUG=1 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk -fasm-blocks -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -Winvalid-offsetof -mmacosx-version-min=10.8 -g -fvisibility-inlines-hidden -Wno-sign-conversion -iquote /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-generated-files.hmap -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-own-target-headers.hmap -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-all-target-headers.hmap -iquote /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/MyNewTest-project-headers.hmap -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Products/Debug/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/DerivedSources/x86_64 -I/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/DerivedSources -F/Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Products/Debug -fsanitize=address -include /Users/yujo/Documents/MyNewTest/MyNewTest/MyNewTest-Prefix.pch -MMD -MT dependencies -MF /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/Objects-normal/x86_64/MyClass.d -c /Users/yujo/Documents/MyNewTest/MyNewTest/MyClass.mm -o /Users/yujo/Library/Developer/Xcode/DerivedData/MyNewTest-digrmkqplgblileeyuvkhdbayboa/Build/Intermediates/MyNewTest.build/Debug/MyNewTest.build/Objects-normal/x86_64/MyClass.o",
                                      @"directory" : @"/Users/yujo/Documents/MyNewTest",
                                      @"file" : @"/Users/yujo/Documents/MyNewTest/MyNewTest/MyClass.mm"
                                   },
                                ];
  STAssertEqualObjects(expectedJsonArray, jsonArray, @"compile_commands.json should match");
}

- (void)testXcode5DPBuild
{
  NSData *outputData = [JSONCompilationDatabaseReporter
                        outputDataWithEventsFromFile:TEST_DATA @"TestProject-Library-TestProject-Xcode-5A11314m.txt"];
  NSError *jsonSerializationError;
  // we should compare json objects (not strings from data) because json format does not specify order of keys
  id jsonObject = [NSJSONSerialization JSONObjectWithData:outputData options:0 error:&jsonSerializationError];
  STAssertNotNil(jsonObject, @"cannot deserialize events file %@", jsonSerializationError.localizedDescription);
  STAssertTrue([jsonObject isKindOfClass:[NSArray class]], @"compilation database json object should be an array");
  NSArray *jsonArray = (NSArray *)jsonObject;
  NSArray *expectedJsonArray = @[
                                  @{
                                      @"command" : @"/Applications/Xcode5-DP.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -arch armv7 -fmessage-length=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit=0 -std=gnu99 -Wno-trigraphs -fpascal-strings -Os -Wno-missing-field-initializers -Wno-missing-prototypes -Wno-implicit-atomic-properties -Wno-receiver-is-weak -Wno-arc-repeated-use-of-weak -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wno-unused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wno-constant-conversion -Wno-int-conversion -Wno-bool-conversion -Wno-enum-conversion -Wno-shorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wno-undeclared-selector -Wno-deprecated-implementations -isysroot /Applications/Xcode5-DP.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -g -Wno-sign-conversion -miphoneos-version-min=6.0 -iquote /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-generated-files.hmap -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-own-target-headers.hmap -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-all-target-headers.hmap -iquote /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-project-headers.hmap -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Products/Release-iphoneos/include -I/Applications/Xcode5-DP.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources/armv7 -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources -F/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Products/Release-iphoneos -include /Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject-Library-Prefix.pch -MMD -MT dependencies -MF /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7/TestProject_Library.d --serialize-diagnostics /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7/TestProject_Library.dia -c /Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m -o /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7/TestProject_Library.o",
                                       @"directory" : @"/Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library",
                                       @"file" : @"/Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m"
                                    },
                                   @{
                                       @"command" : @"/Applications/Xcode5-DP.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x objective-c -arch armv7s -fmessage-length=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit=0 -std=gnu99 -Wno-trigraphs -fpascal-strings -Os -Wno-missing-field-initializers -Wno-missing-prototypes -Wno-implicit-atomic-properties -Wno-receiver-is-weak -Wno-arc-repeated-use-of-weak -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wno-unused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wuninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wno-constant-conversion -Wno-int-conversion -Wno-bool-conversion -Wno-enum-conversion -Wno-shorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wno-undeclared-selector -Wno-deprecated-implementations -isysroot /Applications/Xcode5-DP.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -g -Wno-sign-conversion -miphoneos-version-min=6.0 -iquote /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-generated-files.hmap -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-own-target-headers.hmap -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-all-target-headers.hmap -iquote /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/TestProject-Library-project-headers.hmap -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Products/Release-iphoneos/include -I/Applications/Xcode5-DP.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources/armv7s -I/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/DerivedSources -F/Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Products/Release-iphoneos -include /Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject-Library-Prefix.pch -MMD -MT dependencies -MF /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7s/TestProject_Library.d --serialize-diagnostics /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7s/TestProject_Library.dia -c /Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m -o /Users/lqi/Library/Developer/Xcode/DerivedData/TestProject-Library-enpfpqlmjvdhtzcbbuotnxqvhdzq/Build/Intermediates/TestProject-Library.build/Release-iphoneos/TestProject-Library.build/Objects-normal/armv7s/TestProject_Library.o",
                                       @"directory" : @"/Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library",
                                       @"file" : @"/Users/lqi/Projects/LQRDG/xctool/xctool/xctool-tests/TestData/TestProject-Library/TestProject-Library/TestProject_Library.m"
                                    },
                                ];
  STAssertEqualObjects(expectedJsonArray, jsonArray, @"compile_commands.json should match");
}

- (void)testTestResults
{
  NSData *outputData = [JSONCompilationDatabaseReporter
                        outputDataWithEventsFromFile:TEST_DATA @"TestProject-Library-TestProject-LibraryTests-test-results.txt"];
  NSString *jsonStr = [[[NSString alloc] initWithData:outputData
                                            encoding:NSUTF8StringEncoding] autorelease];
  STAssertEqualObjects(@"\
[\n\
\n\
]\n", jsonStr, @"compile_commands.json should match");
}
@end
