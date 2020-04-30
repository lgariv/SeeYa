#import <UIKit/UIKit.h>
#import <UIKit/UIBezierPath.h>

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
