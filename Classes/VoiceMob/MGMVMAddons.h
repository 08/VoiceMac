//
//  MGMVMAddons.h
//  VoiceMob
//
//  Created by Mr. Gecko on 9/24/10.
//  Copyright (c) 2010 Mr. Gecko's Media (James Coleman). All rights reserved. http://mrgeckosmedia.com/
//

#import <UIKit/UIKit.h>

@interface UIDevice (MGMVMAddons)
- (BOOL)isPad;
- (NSString *)appendDeviceSuffixToString:(NSString *)theString;
@end