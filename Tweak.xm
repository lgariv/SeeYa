#import "Tweak.h"

dispatch_queue_t highProtityQueue() {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
	return queue;
}

%group Tweak
%hook SBDashBoardNotificationDispatcher
- (void)postNotificationRequest:(NCNotificationRequest *)request forCoalescedNotification:(id)arg2 {
	if ([[request.content.header lowercaseString] containsString:@"whatsapp"]) {
		NSString *__block contactImagePath;
		UIImage *__block contactImage;
		dispatch_async(dispatch_get_main_queue(),^{
			dispatch_sync(highProtityQueue(),^{
				NSString *threadId = [request threadIdentifier];
				NSString *chatId = [threadId componentsSeparatedByString:@"@"][0];
				NSFileManager *fileManager = [[NSFileManager alloc] init];
				NSArray *identifiers = @[@"group.net.whatsapp.WhatsApp.shared", @"group.net.whatsapp.WhatsAppSMB.shared"];

				for (NSString *identifier in identifiers) {
					NSString *file;
					NSString *profilePicture;
					NSString *containerPath = [FolderFinder findSharedFolder:identifier];
					NSString *picturesPath = [NSString stringWithFormat:@"%@/Media/Profile", containerPath];
					NSEnumerator *files = [[fileManager contentsOfDirectoryAtPath:picturesPath error:nil] reverseObjectEnumerator];

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

							// here it is
							contactImage = [self imageWithImage:contactImage convertToSize:CGSizeMake(25, 25)];
							NSArray *newIconsArray = [NSArray arrayWithObject:contactImage];
							MSHookIvar<NSArray *>(request.content, "_icons") = newIconsArray;
							break;
						}
					}
				}
			});
			%orig;
		});
	} else {
		%orig;
	}
}

%new
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
	
	UIImage *imageRender = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
		// creating a cicrle path
		UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.height, size.width)];
		[bPath addClip];
		// loading the image in the given size within the circle path
		[image drawInRect:CGRectMake(0, 0, size.height, size.width)];
  	}];

	renderer = nil;
    return imageRender;
}
%end

%hook CSNotificationDispatcher
- (void)postNotificationRequest:(NCNotificationRequest *)request {
	if ([[request.content.header lowercaseString] containsString:@"whatsapp"]) {
		NSString *__block contactImagePath;
		UIImage *__block contactImage;
		dispatch_async(dispatch_get_main_queue(),^{
			dispatch_sync(highProtityQueue(),^{
				NSString *threadId = [request threadIdentifier];
				NSString *chatId = [threadId componentsSeparatedByString:@"@"][0];
				NSFileManager *fileManager = [[NSFileManager alloc] init];
				NSArray *identifiers = @[@"group.net.whatsapp.WhatsApp.shared", @"group.net.whatsapp.WhatsAppSMB.shared"];

				for (NSString *identifier in identifiers) {
					NSString *file;
					NSString *profilePicture;
					NSString *containerPath = [FolderFinder findSharedFolder:identifier];
					NSString *picturesPath = [NSString stringWithFormat:@"%@/Media/Profile", containerPath];
					NSEnumerator *files = [[fileManager contentsOfDirectoryAtPath:picturesPath error:nil] reverseObjectEnumerator];

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

							// here it is
							contactImage = [self imageWithImage:contactImage convertToSize:CGSizeMake(25, 25)];
							//NSLog(@"[SeeYa] contactImage: %@",contactImage);
							NSArray *newIconsArray = [NSArray arrayWithObject:contactImage];
							//NSLog(@"[SeeYa] newIconsArray: %@",newIconsArray[0]);
							//NSLog(@"[SeeYa] oldIcons: %@",MSHookIvar<NSArray *>(request.content, "_icons")[0]);
							MSHookIvar<NSArray *>(request.content, "_icons") = newIconsArray;
							//NSLog(@"[SeeYa] newIcons: %@",MSHookIvar<NSArray *>(request.content, "_icons")[0]);
							break;
						}
					}
				}
			});
			%orig;
			//NSLog(@"[SeeYa] origIcons: %@",MSHookIvar<NSArray *>(request.content, "_icons")[0]);
		});
	} else {
		%orig;
	}
}

%new
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
	
	UIImage *imageRender = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
		// creating a cicrle path
		UIBezierPath *bPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, size.height, size.width)];
		[bPath addClip];
		// loading the image in the given size within the circle path
		[image drawInRect:CGRectMake(0, 0, size.height, size.width)];
  	}];

	renderer = nil;
    return imageRender;
}
%end
%end

static void loadPrefs() {
    NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.miwix.seeyaprefs.plist"];
    if ( [prefs objectForKey:@"TweakisEnabled"] ? [[prefs objectForKey:@"TweakisEnabled"] boolValue] : YES ) {
		%init(Tweak);
	}
}

%ctor {
    loadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.miwix.seeyaprefs/settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}