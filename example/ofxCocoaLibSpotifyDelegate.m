//
//  ofxCocoaLibSpotifyDelegate.m
//
//  Created by Kenta Watashima on 2/25/16.
//
//

#include "ofxCocoaLibSpotifyDelegate.h"

@interface ofxCocoaLibSpotifyDelegate ()

@end

@implementation ofxCocoaLibSpotifyDelegate

- (void)setupWithUsername:(NSString *)username password:(NSString *)password {
    NSError *error = nil;
    [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
                                               userAgent:@"com.example"
                                           loadingPolicy:SPAsyncLoadingManual
                                                   error:&error];
    if (error != nil) {
        NSLog(@"CocoaLibSpotify init failed: %@", error);
        abort();
    }
    
    [[SPSession sharedSession] setDelegate:self];
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    self.playbackManager.delegate = self;
    [[SPSession sharedSession] setPlaybackDelegate:self];
    
    [[SPSession sharedSession] attemptLoginWithUserName:username password:password];
}

#pragma mark -
#pragma mark SPSessionDelegate Methods

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession; {
    NSLog(@"spotify login successfully");
}

-(void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error; {
    NSLog(@"spotify login failed");
}

-(void)sessionDidLogOut:(SPSession *)aSession; {}
-(void)session:(SPSession *)aSession didEncounterNetworkError:(NSError *)error; {}
-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage; {}
-(void)sessionDidChangeMetadata:(SPSession *)aSession; {}

-(void)session:(SPSession *)aSession recievedMessageForUser:(NSString *)aMessage; {
    [[NSAlert alertWithMessageText:aMessage
                     defaultButton:@"OK"
                   alternateButton:@""
                       otherButton:@""
         informativeTextWithFormat:@"This message was sent to you from the Spotify service."] runModal];
}

#pragma mark -
#pragma mark SPSessionPlaybackDelegate Methods

- (void)sessionDidLosePlayToken:(id<SPSessionPlaybackProvider>)aSession {
    NSLog(@"sessionDidLosePlayToken");
}

- (void)sessionDidEndPlayback:(id<SPSessionPlaybackProvider>)aSession {
    NSLog(@"sessionDidEndPlayback");
}

#pragma mark -
#pragma mark SPPlaybackManagerDelegate Methods

- (void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager {
    NSLog(@"playbackManagerWillStartPlayingAudio");
}

@end