#import <UIKit/UIKit.h>
#import <UIKit/UIBezierPath.h>
#import "FolderFinder.h"

@class NCNotificationContent;

@interface NCNotificationContent : NSObject {
	NSArray* _icons;
}
@end

@interface NCNotificationRequest : NSObject {
	NCNotificationContent* _content;
}
@property (nonatomic,readonly) NCNotificationContent * content;                                          //@synthesize content=_content - In the implementation block
-(NSString *)threadIdentifier;
@end

@interface CSNotificationDispatcher : NSObject
// %new
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end
