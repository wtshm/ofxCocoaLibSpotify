//
//  ofxCocoaLibSpotifyDelegate.h
//
//  Created by Kenta Watashima on 2/25/16.
//
//

#pragma once

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#include "appkey.c"

@interface ofxCocoaLibSpotifyDelegate : NSObject <SPSessionDelegate, SPSessionPlaybackDelegate, SPPlaybackManagerDelegate>

- (void)setupWithUsername:(NSString *)username password:(NSString *)password;

@property (nonatomic, readwrite, strong) SPPlaybackManager *playbackManager;

@end
