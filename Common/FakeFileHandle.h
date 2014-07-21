
#import <Foundation/Foundation.h>

@interface FakeFileHandle : NSObject

@property (nonatomic, strong, readonly) NSMutableData *dataWritten;
- (NSString *)stringWritten;
- (int)fileDescriptor;
- (void)synchronizeFile;

@end
