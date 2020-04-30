#import "FolderFinder.h"
#import "WhatsAppContactPhotoProvider.h"

@class NCNotificationContent;

@interface NCNotificationContent : NSObject {
	NSArray* _icons;
}
@end

@interface NCNotificationRequest : NSObject {
	NCNotificationContent* _content;
}
-(NSString *)threadIdentifier;
@end

@implementation WhatsAppContactPhotoProvider
  - (DDNotificationContactPhotoPromiseOffer *)contactPhotoPromiseOfferForNotification:(DDUserNotification *)notification {
    NCNotificationRequest *request = [notification request];
    NSString *threadId = [request threadIdentifier];
    NSString *chatId = [threadId componentsSeparatedByString:@"@"][0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *identifiers = @[@"group.net.whatsapp.WhatsApp.shared", @"group.net.whatsapp.WhatsAppSMB.shared"];

    for (NSString *identifier in identifiers) {
      NSString *file;
      NSString *profilePicture;
      NSString *containerPath = [FolderFinder findSharedFolder:identifier];
      NSString *picturesPath = [NSString stringWithFormat:@"%@/Media/Profile", containerPath];
      NSDirectoryEnumerator *files = [fileManager enumeratorAtPath:picturesPath];

      while (file = [files nextObject]) {
        NSArray *parts = [file componentsSeparatedByString:@"-"];

        // DMs
        if ([parts count] == 2) {
          if ([chatId isEqualToString:parts[0]]){
            profilePicture = file;
          }
        }

        // Groups
        if ([parts count] == 3) {
          if ([chatId isEqualToString:[NSString stringWithFormat:@"%@-%@", parts[0], parts[1]]]){
            profilePicture = file;
          }
        }

        if (profilePicture) {
          NSString *imagePath = [NSString stringWithFormat:@"%@/%@", picturesPath, profilePicture];
          UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

          return [NSClassFromString(@"DDNotificationContactPhotoPromiseOffer") offerInstantlyResolvingPromiseWithPhotoIdentifier:imagePath image:image];
        }
      }
    }

    return nil;
  }
@end

//start from here

#import <Contacts/Contacts.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIBezierPath.h>

@interface NCNotificationStructuredListViewController : UIViewController
@end

@interface PLPlatterView : UIView
@end

@interface PLPlatterHeaderContentView : UIView
@property (nonatomic,copy) NSArray * icons;
@property (nonatomic,copy) NSString * title;
//@property (nonatomic,copy) NSString * primaryText;
@end

@interface PLTitledPlatterView : PLPlatterView {
  PLPlatterHeaderContentView* _headerContentView;
}
-(id)_headerContentView;
@end

@interface NCNotificationShortLookView : PLTitledPlatterView
@property (nonatomic,copy) NSArray * icons;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * primaryText;
// %new
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size ;
@end 

@interface NCNotificationViewControllerView : UIView
@property (nonatomic, readwrite) NCNotificationShortLookView *contentView;
//@property (assign,nonatomic) PLPlatterView * contentView;              //@synthesize contentView=_contentView - In the implementation block
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end

/*@interface NCNotificationContent () {
  NSString* _header;
	NSString* _title;
	NSArray* _icons;
}
@property (nonatomic,copy,readonly) NSString * header;                                     //@synthesize header=_header - In the implementation block
@property (nonatomic,copy,readonly) NSString * title;                                      //@synthesize title=_title - In the implementation block
@property (nonatomic,readonly) UIImage * icon; 
@end*/

/*@interface NCNotificationRequest : NSObject {
  NCNotificationContent* _content;
}
@end*/

/*@interface NCNotificationRequest (Private) 
@property (nonatomic,readonly) NCNotificationContent * content;                                          //@synthesize content=_content - In the implementation block
// %new
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end*/

@interface CSNotificationDispatcher : NSObject
// %new
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end

@interface NCNotificationViewController : UIViewController
@property (getter=_notificationViewControllerView,nonatomic,readonly) NCNotificationViewControllerView * notificationViewControllerView; 
@property (nonatomic,retain) NCNotificationRequest * notificationRequest;                                                                                                                                                    //@synthesize notificationRequest=_notificationRequest - In the implementation block
-(void)setNotificationRequest:(NCNotificationRequest *)arg1 ;
-(BOOL)_setNotificationRequest:(id)arg1 ;
-(id)initWithNotificationRequest:(id)arg1 revealingAdditionalContentOnPresentation:(BOOL)arg2 ;
-(NCNotificationRequest *)notificationRequest;
-(id)initWithNotificationRequest:(id)arg1 ;
// %new
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end

@interface NCNotificationListCell : UIView
@property (nonatomic,retain) NCNotificationViewController * contentViewController;                          //@synthesize contentViewController=_contentViewController - In the implementation block
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end

@interface NCNotificationShortLookViewController : NCNotificationViewController
@property (nonatomic,retain) NCNotificationShortLookView * viewForPreview;
@property (nonatomic,retain) NCNotificationShortLookView *view;
-(id)_notificationShortLookViewIfLoaded;
@end

@interface PLPlatterHeaderContentViewLayoutManager : NSObject {
	PLPlatterHeaderContentView* _headerContentView;
}
@property (nonatomic,readonly) PLPlatterHeaderContentView * headerContentView;                               //@synthesize headerContentView=_headerContentView - In the implementation block
@property (getter=_titleLabel,nonatomic,readonly) UILabel * titleLabel; 
@property (getter=_iconButtons,nonatomic,readonly) NSArray * iconButtons; 

// %new
-(UIImage *)getImageFrom:(NSString *)contactName;
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
@end
