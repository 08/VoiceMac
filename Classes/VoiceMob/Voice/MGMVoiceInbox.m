//
//  MGMVoiceInbox.m
//  VoiceMob
//
//  Created by Mr. Gecko on 9/30/10.
//  Copyright (c) 2010 Mr. Gecko's Media (James Coleman). All rights reserved. http://mrgeckosmedia.com/
//

#import "MGMVoiceInbox.h"
#import "MGMVoiceUser.h"
#import "MGMAccountController.h"
#import "MGMInboxMessageView.h"
#import "MGMProgressView.h"
#import "MGMVMAddons.h"
#import <VoiceBase/VoiceBase.h>

static NSMutableArray *MGMInboxItems;

NSString * const MGMSName = @"name";
NSString * const MGMSID = @"id";

NSString * const MGMInboxesCellIdentifier = @"MGMInboxesCellIdentifier";
NSString * const MGMInboxMessageCellIdentifier = @"MGMInboxMessageCellIdentifier";
NSString * const MGMInboxMessageLoadCellIdentifier = @"MGMInboxMessageLoadCellIdentifier";

@implementation MGMVoiceInbox
+ (id)tabWithVoiceUser:(MGMVoiceUser *)theVoiceUser {
	return [[[self alloc] initWithVoiceUser:theVoiceUser] autorelease];
}
- (id)initWithVoiceUser:(MGMVoiceUser *)theVoiceUser {
	if (self = [super init]) {
		if (MGMInboxItems==nil) {
			MGMInboxItems = [NSMutableArray new];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Inbox", MGMSName, [NSNumber numberWithInt:0], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Starred", MGMSName, [NSNumber numberWithInt:1], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Spam", MGMSName, [NSNumber numberWithInt:2], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Trash", MGMSName, [NSNumber numberWithInt:3], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Voicemail", MGMSName, [NSNumber numberWithInt:4], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"SMS Messages", MGMSName, [NSNumber numberWithInt:5], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Recorded", MGMSName, [NSNumber numberWithInt:6], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Placed", MGMSName, [NSNumber numberWithInt:7], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Received", MGMSName, [NSNumber numberWithInt:8], MGMSID, nil]];
			[MGMInboxItems addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Missed", MGMSName, [NSNumber numberWithInt:9], MGMSID, nil]];
		}
		voiceUser = theVoiceUser;
		currentView = -1;
		currentInbox = 0;
		maxResults = 10;
		start = 0;
		resultsCount = 0;
		inboxItems = [[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease], [[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:[voiceUser accountController] action:@selector(showSettings:)] autorelease], nil] retain];
		messagesItems = [[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithTitle:@"Inboxes" style:UIBarButtonItemStyleBordered target:self action:@selector(showInboxes:)] autorelease], [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL] autorelease], [[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:[voiceUser accountController] action:@selector(showSettings:)] autorelease], nil] retain];
		currentData = [NSMutableArray new];
	}
	return self;
}
- (void)dealloc {
	[self releaseView];
	[super dealloc];
}

- (MGMVoiceUser *)voiceUser {
	return voiceUser;
}

- (UIView *)view {
	if (currentView==-1) {
		currentView = 1;
		[self loadInbox];
	}
	if (inboxesTable==nil) {
		if (![[NSBundle mainBundle] loadNibNamed:[[UIDevice currentDevice] appendDeviceSuffixToString:@"VoiceInbox"] owner:self options:nil]) {
			NSLog(@"Unable to load Voice Inbox");
			[self release];
			self = nil;
		} else {
			CGSize contentSize = [[voiceUser tabView] frame].size;
			progressView = [[MGMProgressView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
			[progressView setProgressTitle:@"Loading..."];
			[progressView setHidden:(progressStartCount<=0)];
			if (currentView==1)
				[[[voiceUser accountController] toolbar] setItems:messagesItems animated:YES];
			else
				[[[voiceUser accountController] toolbar] setItems:inboxItems animated:YES];
		}
	}
	if (currentView==1)
		return messagesTable;
	return inboxesTable;
}
- (void)releaseView {
	if (inboxesTable!=nil) {
		[inboxesTable release];
		inboxesTable = nil;
	}
	if (messagesTable!=nil) {
		[messagesTable release];
		messagesTable = nil;
	}
	if (progressView!=nil) {
		[progressView release];
		progressView = nil;
	}
}

- (void)startProgress {
	if (progressView!=nil) {
		if ([progressView superview]==nil)
			[[voiceUser tabView] addSubview:progressView];
		[progressView startProgess];
		[progressView becomeFirstResponder];
	}
	progressStartCount++;
}
- (void)stopProgress {
	if (progressView!=nil) {
		if (progressStartCount==1) {
			[progressView stopProgess];
			[progressView removeFromSuperview];
		}
	}
	progressStartCount--;
}

- (IBAction)showInboxes:(id)sender {
	CGRect inViewFrame = [inboxesTable frame];
	inViewFrame.origin.x -= inViewFrame.size.width;
	[inboxesTable setFrame:inViewFrame];
	[[voiceUser tabView] addSubview:inboxesTable];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(inboxesAnimationDidStop:finished:context:)];
	[inboxesTable setFrame:[messagesTable frame]];
	CGRect outViewFrame = [messagesTable frame];
	outViewFrame.origin.x += outViewFrame.size.width;
	[messagesTable setFrame:outViewFrame];
	[UIView commitAnimations];
	[[[voiceUser accountController] toolbar] setItems:inboxItems animated:YES];
	currentView = 0;
}
- (void)inboxesAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[messagesTable removeFromSuperview];
	currentInbox = -1;
	start = 0;
	resultsCount = 0;
	[currentData removeAllObjects];
	[messagesTable reloadData];
	[[messagesItems objectAtIndex:1] setEnabled:YES];
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
	if (theTableView==inboxesTable)
		return [MGMInboxItems count];
	else if (theTableView==messagesTable)
		return (resultsCount==maxResults ? [currentData count]+1 : [currentData count]);
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (theTableView==inboxesTable) {
		UITableViewCell *cell = [inboxesTable dequeueReusableCellWithIdentifier:MGMInboxesCellIdentifier];
		if (cell==nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGMInboxesCellIdentifier] autorelease];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		}
		[cell setText:[[MGMInboxItems objectAtIndex:[indexPath indexAtPosition:1]] objectForKey:MGMSName]];
		return cell;
	} else if (theTableView==messagesTable) {
		if ([currentData count]<=[indexPath indexAtPosition:1]) {
			UITableViewCell *cell = [inboxesTable dequeueReusableCellWithIdentifier:MGMInboxMessageLoadCellIdentifier];
			if (cell==nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGMInboxMessageLoadCellIdentifier] autorelease];
				[cell setText:@"Load More..."];
				if ([cell respondsToSelector:@selector(textLabel)]) {
					[[cell textLabel] setTextColor:[UIColor blueColor]];
					[[cell textLabel] setTextAlignment:UITextAlignmentCenter];
				} else {
					[cell setTextColor:[UIColor blueColor]];
					[cell setTextAlignment:UITextAlignmentCenter];
				}
			}
			return cell;
		} else {
			MGMInboxMessageView *cell = (MGMInboxMessageView *)[messagesTable dequeueReusableCellWithIdentifier:MGMInboxMessageCellIdentifier];
			if (cell==nil) {
				cell = [[[MGMInboxMessageView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MGMInboxMessageCellIdentifier] autorelease];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
				[cell setInstance:[voiceUser instance]];
			}
			[cell setMessageData:[currentData objectAtIndex:[indexPath indexAtPosition:1]]];
			return cell;
		}
	}
	return nil;
}
- (BOOL)tableView:(UITableView *)theTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (theTableView==inboxesTable)
		return NO;
	return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)theTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)theTableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"Delete";
}
- (void)tableView:(UITableView *)theTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (theTableView==inboxesTable) {
		currentInbox = [[[MGMInboxItems objectAtIndex:[indexPath indexAtPosition:1]] objectForKey:MGMSID] intValue];
		[[messagesItems objectAtIndex:1] setEnabled:NO];
		[[[voiceUser accountController] toolbar] setItems:messagesItems animated:YES];
		
		CGRect inViewFrame = [messagesTable frame];
		inViewFrame.origin.x += inViewFrame.size.width;
		[messagesTable setFrame:inViewFrame];
		[[voiceUser tabView] addSubview:messagesTable];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(messagesAnimationDidStop:finished:context:)];
		[messagesTable setFrame:[inboxesTable frame]];
		CGRect outViewFrame = [inboxesTable frame];
		outViewFrame.origin.x -= outViewFrame.size.width;
		[inboxesTable setFrame:outViewFrame];
		[UIView commitAnimations];
		currentView = 1;
		[self loadInbox];
	} else if (theTableView==messagesTable) {
		if ([indexPath indexAtPosition:1]>=[currentData count]) {
			start += maxResults;
			[self loadInbox];
		} else {
			
		}
	}
}
- (void)messagesAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[inboxesTable removeFromSuperview];
	[inboxesTable deselectRowAtIndexPath:[inboxesTable indexPathForSelectedRow] animated:NO];
	[[messagesItems objectAtIndex:1] setEnabled:YES];
}

- (void)loadInbox {
	int page = (start/maxResults)+1;
	[self startProgress];
	switch (currentInbox) {
		case 0:
			[[[voiceUser instance] inbox] getInboxForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 1:
			[[[voiceUser instance] inbox] getStarredForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 2:
			[[[voiceUser instance] inbox] getSpamForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 3:
			[[[voiceUser instance] inbox] getTrashForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 4:
			[[[voiceUser instance] inbox] getVoicemailForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 5:
			[[[voiceUser instance] inbox] getSMSForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 6:
			[[[voiceUser instance] inbox] getRecordedCallsForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 7:
			[[[voiceUser instance] inbox] getPlacedCallsForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 8:
			[[[voiceUser instance] inbox] getReceivedCallsForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
		case 9:
			[[[voiceUser instance] inbox] getMissedCallsForPage:page delegate:self didFailWithError:@selector(inbox:didFailWithError:instance:) didReceiveInfo:@selector(inboxGotInfo:instance:)];
			break;
	}
}
- (void)inbox:(NSDictionary *)theInfo didFailWithError:(NSError *)theError instance:(MGMInstance *)theInstance {
	NSLog(@"Inbox Error: %@ for instance: %@", theError, theInstance);
	UIAlertView *theAlert = [[UIAlertView new] autorelease];
	[theAlert setTitle:@"Error loading inbox"];
	[theAlert setMessage:[theError localizedDescription]];
	[theAlert addButtonWithTitle:MGMOkButtonTitle];
	[theAlert show];
	[self stopProgress];
}
- (void)inboxGotInfo:(NSArray *)theInfo instance:(MGMInstance *)theInstance {
	if (theInfo!=nil) {
		[self addData:theInfo];
	} else {
		NSLog(@"Error 234554: Hold on, this should never happen.");
	}
	[self stopProgress];
}
- (void)addData:(NSArray *)theData {
	resultsCount = [theData count];
	[currentData addObjectsFromArray:theData];
	[messagesTable reloadData];
}
- (int)currentInbox {
	return currentInbox;
}
@end