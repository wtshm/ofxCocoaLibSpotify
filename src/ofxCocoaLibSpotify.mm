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
                        onError(error.code);
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
        return track.duration;
    }
    return 0;
}

bool ofxCocoaLibSpotify::isPlaying() {
    return ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.isPlaying;
}

string ofxCocoaLibSpotify::getCurrentArtistName() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return [track.album.artist.name UTF8String];
    }
    return "";
}

string ofxCocoaLibSpotify::getCurrentTrackName() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return [track.name UTF8String];
    }
    return "";
}

string ofxCocoaLibSpotify::getCurrentAlbumName() {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    if (track != nil) {
        return [track.album.name UTF8String];
    }
    return "";
}

bool ofxCocoaLibSpotify::getCurrentAlbumCover(ofImage &result) {
    SPTrack *track = ((ofxCocoaLibSpotifyDelegate *)delegate).playbackManager.currentTrack;
    
    if (track != nil) {
        NSImage *image = track.album.largestAvailableCover.image;
        
        if (image == nil) {
            return false;
        }
        
        int width = image.size.width;
        int height = image.size.height;
        
        NSRect imageRect = NSMakeRect(0, 0, width, height);
        CGImageRef cgImage = [image CGImageForProposedRect:&imageRect context:NULL hints:nil];
        
        int bytesPerPixel = CGImageGetBitsPerPixel(cgImage) / 8;
        if (bytesPerPixel == 3) bytesPerPixel = 4;
        
        width *= bytesPerPixel;
        height *= bytesPerPixel;
        
        // Allocated memory needed for the bitmap context
        GLubyte *pixels = (GLubyte *)malloc(width * height * bytesPerPixel);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        // Uses the bitmatp creation function provided by the Core Graphics framework.
        CGContextRef spriteContext = CGBitmapContextCreate(pixels,
                                                           width,
                                                           height,
                                                           CGImageGetBitsPerComponent(cgImage),
                                                           width * bytesPerPixel,
                                                           colorSpace,
                                                           bytesPerPixel == 4 ? kCGImageAlphaPremultipliedLast : kCGImageAlphaNone);
        CGColorSpaceRelease(colorSpace);
        
        if (spriteContext == NULL) {
            free(pixels);
            return false;
        }
        
        CGContextSetBlendMode(spriteContext, kCGBlendModeCopy);
        CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, width, height), cgImage);
        CGContextRelease(spriteContext);
        
        ofImageType ofImageMode;
        
        switch (bytesPerPixel) {
            case 1:
                ofImageMode = OF_IMAGE_GRAYSCALE;
                break;
            case 3:
                ofImageMode = OF_IMAGE_COLOR;
                break;
            case 4: 
            default:
                ofImageMode = OF_IMAGE_COLOR_ALPHA;
                break;
        }
        
        result.setFromPixels(pixels, width, height, ofImageMode, true);
        
        free(pixels);
        return true;
    }
}

void ofxCocoaLibSpotify::onError(int errorCode) {
    ofNotifyEvent(errorEvent, errorCode, this);
}
