#import <Contacts/Contacts.h>
#import <UIKit/UIKit.h>

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
@end 

@interface NCNotificationViewControllerView : UIView
@property (nonatomic, readwrite) NCNotificationShortLookView *contentView;
//@property (assign,nonatomic) PLPlatterView * contentView;              //@synthesize contentView=_contentView - In the implementation block
@end

@interface NCNotificationContent : NSObject
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

@interface NCNotificationRequest : NSObject {
  NCNotificationContent* _content;
}
@end

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
@property (nonatomic,readonly) UIView * viewForPreview; 
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
