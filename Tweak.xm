#include <dlfcn.h>
#import "Tweak.h"

NSString *contactImagePath;
UIImage *contactImage;

static dispatch_queue_t getBBServerQueue() {
	static dispatch_queue_t queue;
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
		void *handle = dlopen(NULL, RTLD_GLOBAL);
		if (handle) {
			dispatch_queue_t pointer = (__bridge dispatch_queue_t) dlsym(handle, "__BBServerQueue");
			if (pointer) {
				queue = pointer;
			}
			dlclose(handle);        
		}
	});
	return queue;
}

%hook CSNotificationDispatcher
- (void)postNotificationRequest:(NCNotificationRequest *)request {
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
				contactImagePath = [NSString stringWithFormat:@"%@/%@", picturesPath, profilePicture];
				contactImage = [UIImage imageWithContentsOfFile:contactImagePath];

				//here it is
				dispatch_queue_t queue = getBBServerQueue();
				dispatch_async(queue,^{
					contactImage = [self imageWithImage:contactImage convertToSize:CGSizeMake(25, 25)];
					NSArray *newIconsArray = [NSArray arrayWithObject:contactImage];
					MSHookIvar<UIImage *>(request, "_icon") = contactImage;
					MSHookIvar<NSArray *>(request.content, "_icons") = newIconsArray;
				});
			}
		}
	}
	%orig;
}

%new
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
	
	UIImage *imageRender = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
		UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.height, size.width)];
		[bPath addClip];
		[image drawInRect:CGRectMake(0, 0, size.height, size.width)];
  	}];

	renderer = nil;
    return imageRender;
}
%end
