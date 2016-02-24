//
//  ofxCocoaLibSpotify.h
//
//  Created by Kenta Watashima on 2/25/16.
//
//

#pragma once

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
    void setPosition(double position);
    bool isPlaying();
    
private:
    void *delegate;
};
