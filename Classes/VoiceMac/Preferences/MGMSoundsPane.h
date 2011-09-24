//
//  MGMSoundsPane.h
//  VoiceMac
//
//  Created by Mr. Gecko on 9/7/10.
//  Copyright (c) 2011 Mr. Gecko's Media (James Coleman). http://mrgeckosmedia.com/
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose
//  with or without fee is hereby granted, provided that the above copyright notice
//  and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
//  REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT,
//  OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
//  DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
//  ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

#import <Cocoa/Cocoa.h>
#import <MGMUsers/MGMUsers.h>

@class MGMSound, MGMThemeManager, WebView;

@interface MGMSoundsPane : MGMPreferencesPane {
	MGMThemeManager *themeManager;
	IBOutlet NSView *mainView;
	IBOutlet NSPopUpButton *SMSMessagePopUp;
	IBOutlet NSButton *SMSMessageAuthorButton;
	IBOutlet NSPopUpButton *voicemailPopUp;
	IBOutlet NSButton *voicemailAuthorButton;
	IBOutlet NSPopUpButton *SIPRingtonePopUp;
	IBOutlet NSButton *SIPRingtoneAuthorButton;
	IBOutlet NSPopUpButton *SIPHoldMusicPopUp;
	IBOutlet NSButton *SIPHoldMusicAuthorButton;
	IBOutlet NSPopUpButton *SIPConnectedPopUp;
	IBOutlet NSButton *SIPConnectedAuthorButton;
	IBOutlet NSPopUpButton *SIPDisconnectedPopUp;
	IBOutlet NSButton *SIPDisconnectedAuthorButton;
	IBOutlet NSPopUpButton *SIPSound1PopUp;
	IBOutlet NSButton *SIPSound1AuthorButton;
	IBOutlet NSPopUpButton *SIPSound2PopUp;
	IBOutlet NSButton *SIPSound2AuthorButton;
	IBOutlet NSPopUpButton *SIPSound3PopUp;
	IBOutlet NSButton *SIPSound3AuthorButton;
	IBOutlet NSPopUpButton *SIPSound4PopUp;
	IBOutlet NSButton *SIPSound4AuthorButton;
	IBOutlet NSPopUpButton *SIPSound5PopUp;
	IBOutlet NSButton *SIPSound5AuthorButton;
	NSMutableDictionary *sounds;
	MGMSound *soundPlayer;
	
	IBOutlet NSWindow *browserWindow;
	IBOutlet WebView *browser;
}
- (id)initWithPreferences:(MGMPreferences *)thePreferences;
+ (void)setUpToolbarItem:(NSToolbarItem *)theItem;
+ (NSString *)title;
- (NSView *)preferencesView;

- (void)reload:(NSString *)theSound;
- (IBAction)selectSound:(id)sender;
- (IBAction)stopSound:(id)sender;

- (IBAction)authorSite:(id)sender;
- (IBAction)showBrowser:(id)sender;
@end