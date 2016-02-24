//
//  ofxCocoaLibSpotify.m
//
//  Created by Kenta Watashima on 2/25/16.
//
//

#include "ofxCocoaLibSpotify.h"
#import "ofxCocoaLibSpotifyDelegate.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

ofxCocoaLibSpotify::ofxCocoaLibSpotify() {
    delegate = (__bridge void*)[[ofxCocoaLibSpotifyDelegate alloc] init];
}

ofxCocoaLibSpotify::~ofxCocoaLibSpotify() {
}

void ofxCocoaLibSpotify::setup(std::string username, std::string password) {
    [(ofxCocoaLibSpotifyDelegate *)delegate setupWithUsername:[NSString stringWithUTF8String:username.c_str()]
                       password:[NSString stringWithUTF8String:password.c_str()]];
}

void ofxCocoaLibSpotify::play(std::string trackURL) {
    [[SPSession sharedSession] trackForURL:[NSURL URLWithString:[NSString stringWithUTF8String:trackURL.c_str()]] callback:^(SPTrack *track) {
        if (track != nil) {
            [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
                [((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager playTrack:track callback:^(NSError *error) {
                    if (error) {
                        NSLog(@"%@", error);
                    }
                }];
            }];
        }
    }];
}

void ofxCocoaLibSpotify::stop() {
    [((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.playbackSession unloadPlayback];
}

void ofxCocoaLibSpotify::setVolume(double volume) {
    ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.volume = volume;
}

double ofxCocoaLibSpotify::getVolume() {
    return ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.volume;
}

void ofxCocoaLibSpotify::setPosition(double position) {
    if (((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack != nil
        && ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.isPlaying) {
        [((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager seekToTrackPosition:position];
    }
}

double ofxCocoaLibSpotify::getPosition() {
    return ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.trackPosition;
}

double ofxCocoaLibSpotify::getDuration() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack.duration;
    }
    return 0;
}

bool ofxCocoaLibSpotify::isPlaying() {
    return ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.isPlaying;
}

string ofxCocoaLibSpotify::getCurrentArtistName() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return [((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack.album.artist.name UTF8String];
    }
    return "";
}

string ofxCocoaLibSpotify::getCurrentTrackName() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return [((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack.name UTF8String];
    }
    return "";
}

string ofxCocoaLibSpotify::getCurrentAlbumName() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return [((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack.album.name UTF8String];
    }
    return "";
}
