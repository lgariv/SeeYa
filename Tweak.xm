#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Tweak.h"

UIView *newView;
UIButton *newButton;
	
BOOL hasEmoji;
NSString *phoneNumFromContact;
NSString *finalPath;

%hook NCNotificationViewControllerView
-(void)didmovetosuperview {
	%orig;
}
%end

%hook NCNotificationListCell
-(void)layoutSubviews {
	%orig;
	
	NSMutableCharacterSet *emojiCharacterSet = [[NSMutableCharacterSet alloc] init];
	[emojiCharacterSet addCharactersInRange:NSMakeRange(0x1F300, 0x1F700 - 0x1F300)]; // Add most of the Emoji characters
	
	NSString *contactName;
	NSArray *iconsNew;

	PLPlatterHeaderContentView *headerContentView = [self.contentViewController.notificationViewControllerView.contentView _headerContentView];
	if ([headerContentView.title containsString:@"WHATSAPP"]) {
		if ([self.contentViewController.notificationViewControllerView.contentView primaryText]) {
			contactName = [self.contentViewController.notificationViewControllerView.contentView primaryText];
			
			if ([contactName containsString:@"@"]) {
				NSArray *results = [contactName componentsSeparatedByString: @" @"]; 
				contactName = (NSString*)[results objectAtIndex:0]; // final phone number of contact
			} 
			
			NSString *contactNameFix = [[contactName 
							componentsSeparatedByCharactersInSet:emojiCharacterSet] 
							componentsJoinedByString:@""];

			if ([contactNameFix isEqual:contactName]) {
				hasEmoji = NO;
			} else {
				hasEmoji = YES;
			}

			contactName = contactNameFix;

			iconsNew = [NSArray arrayWithObject:[self getImageFrom:contactName]];

			self.contentViewController.notificationViewControllerView.contentView.icons = iconsNew;
		}
	}
}

%new
-(UIImage *)getImageFrom:(NSString *)contactName {

	__block UIImage *chosenImage = nil;

	CNContactStore *store = [[CNContactStore alloc] init];
	[store containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[store.defaultContainerIdentifier]] error:nil];
	NSArray *keysToFetch =@[CNContactGivenNameKey, CNContactPhoneNumbersKey];
	CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
	[store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
		NSLog(@"Contact Found: %@", contact.givenName);

		if ([contact.givenName containsString:contactName]) {
			if ((hasEmoji == YES && ![contact.givenName isEqual:contactName]) || (hasEmoji == NO && [contact.givenName containsString:contactName])) {
				NSArray <CNLabeledValue<CNPhoneNumber *> *> *phoneNumbers = contact.phoneNumbers;
				CNLabeledValue<CNPhoneNumber *> *firstPhone = [phoneNumbers firstObject];
				CNPhoneNumber *number = firstPhone.value;
				NSString *digits = number.stringValue; // 1234567890
				if ([digits containsString:@"+"] || [digits containsString:@"-"]) {
					phoneNumFromContact = [[digits 
											componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] 
											componentsJoinedByString:@""];
				} else {
					phoneNumFromContact = digits;
				}

				if (![phoneNumFromContact containsString:@"972"]) {
					phoneNumFromContact = [NSString stringWithFormat:@"972%lld", [phoneNumFromContact longLongValue]];
				}

				// debugging views (cause I hate using NSLog, and for some reason most things won't even showup when I use oslog)

				/*if (!newView) {
					newView = [[UIView alloc] init];
					[newView setBackgroundColor:[UIColor whiteColor]];
				}

				if (newButton) {
					[newButton removeFromSuperview];
				}
				
				[newView setFrame:CGRectMake(0, 50, 375, 700)];

				newButton = [UIButton buttonWithType:UIButtonTypeSystem];
				[newButton setTitle:phoneNumFromContact forState:UIControlStateNormal];
				[newButton setFrame:newView.frame];

				[newView addSubview:newButton];

				[[[UIApplication sharedApplication] windows][0] addSubview:newView];*/
			}
		}
	}];
	
	NSString *lookFor = [NSString stringWithFormat:@"%@@", phoneNumFromContact];

	NSString *startPath = @"/private/var/mobile/Containers/Data/Application";
	NSArray *dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:startPath
																		error:NULL];

	[dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *filename = (NSString *)obj;
		NSString *middlePath = [startPath stringByAppendingPathComponent:filename];
		NSArray *dirsInDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:middlePath
																			error:NULL];
		[dirsInDirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSString *filename = (NSString *)obj;
			NSString *extension = [[filename pathExtension] lowercaseString];
			if ([extension isEqualToString:@"plist"]) {
				NSMutableDictionary *potentialPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:[middlePath stringByAppendingPathComponent:filename]];
				if ([[potentialPlist objectForKey:@"MCMMetadataIdentifier"] isEqual:@"net.whatsapp.WhatsApp"]) {
					finalPath = [middlePath stringByAppendingString:@"/Library/Caches/spotlight-profile-v2"];
					NSArray *finalDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:finalPath
																							  error:NULL];
					[finalDirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
						NSString *filename = (NSString *)obj;
						if ([filename containsString:lookFor]) {
							chosenImage = [UIImage imageWithContentsOfFile:[finalPath stringByAppendingPathComponent:filename]];
							chosenImage = [self imageWithImage:chosenImage convertToSize:CGSizeMake(25, 25)];	
						}
					}];
				}
			}
		}];
	}];
	if (chosenImage == nil) {
		NSArray *finalDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:finalPath
																				 error:NULL];
		[finalDirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSString *filename = (NSString *)obj;
			if ([filename containsString:[NSString stringWithFormat:@"%@@", phoneNumFromContact]]) {
				chosenImage = [UIImage imageWithContentsOfFile:[finalPath stringByAppendingPathComponent:filename]];
				chosenImage = [self imageWithImage:chosenImage convertToSize:CGSizeMake(25, 25)];
			}
		}];
	}
	if (chosenImage == nil) {
		NSArray *finalDirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:finalPath
																				 error:NULL];
		[finalDirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSString *filename = (NSString *)obj;
			if ([filename containsString:@"PersonalChatRound"]) {
				chosenImage = [UIImage imageWithContentsOfFile:[finalPath stringByAppendingPathComponent:filename]];
				chosenImage = [self imageWithImage:chosenImage convertToSize:CGSizeMake(25, 25)];
			}
		}];
	}
	return chosenImage;
}

%new
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
	UIImage *imageRender = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
		[image drawInRect:CGRectMake(0, 0, size.height, size.width)];
  	}];
	renderer = nil;
    return imageRender;
}
%end