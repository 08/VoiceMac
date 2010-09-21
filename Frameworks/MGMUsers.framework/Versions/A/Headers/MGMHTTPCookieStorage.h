//
//  MGMHTTPCookieStorage.h
//  MGMUsers
//
//  Created by Mr. Gecko on 12/28/08.
//  Copyright (c) 2010 Mr. Gecko's Media (James Coleman). All rights reserved. http://mrgeckosmedia.com/
//

#import <Cocoa/Cocoa.h>

@interface MGMHTTPCookieStorage : NSObject {
@private
	NSString *cookiesPath;
	NSHTTPCookieAcceptPolicy policy;
	NSMutableArray *cookieJar;
}
+ (void)override;
+ (void)setCookieJarPath:(NSString *)thePath;
+ (MGMHTTPCookieStorage *)sharedHTTPCookieStorage;
+ (MGMHTTPCookieStorage *)sharedCookieStorageWithPath:(NSString *)thePath;
+ (void)releaseShared;
+ (MGMHTTPCookieStorage *)cookieStorageWithPath:(NSString *)thePath;
- (id)initWithPath:(NSString *)thePath;
- (NSArray *)cookies;
- (void)removeAllCookies;
- (void)setNewPath:(NSString *)thePath;
- (void)setCookie:(NSHTTPCookie *)theCookie;
- (void)setCookies:(NSArray *)theCookies;
- (void)deleteCookie:(NSHTTPCookie *)theCookie;
- (NSArray *)cookiesForURL:(NSURL *)theURL;
- (void)setCookies:(NSArray *)theCookies forURL:(NSURL *)theURL mainDocumentURL:(NSURL *)theMainDocumentURL;
- (NSHTTPCookieAcceptPolicy)cookieAcceptPolicy;
- (void)setCookieAcceptPolicy:(NSHTTPCookieAcceptPolicy)cookieAcceptPolicy;
@end