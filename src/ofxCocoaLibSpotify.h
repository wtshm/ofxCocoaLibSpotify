//
//  ofxCocoaLibSpotify.h
//
//  Created by Kenta Watashima on 2/25/16.
//
//

#pragma once

#include "ofMain.h"
#include <string>
using namespace std;

class ofxCocoaLibSpotify {

public:
    ofxCocoaLibSpotify();
    ~ofxCocoaLibSpotify();
    
    void setup(string username, string password);
    void play(string trackURL);
    void stop();
    void setVolume(double volume);
    double getVolume();
    void setPosition(double position);
    double getPosition();
    double getDuration();
    bool isPlaying();
    string getCurrentArtistName();
    string getCurrentTrackName();
    string getCurrentAlbumName();
    bool getCurrentAlbumCover(ofImage &result);
    void onError(int errorCode);
    
    ofEvent<int> errorEvent;
    
private:
    void *delegate;
};
