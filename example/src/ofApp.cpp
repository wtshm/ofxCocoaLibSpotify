#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    spotify = ofxCocoaLibSpotify();
    spotify.setup("USERNAME", "PASSWORD");
}

//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    if (spotify.isPlaying()) {
        ofDrawBitmapString(spotify.getCurrentArtistName(), 20, 25);
        ofDrawBitmapString(spotify.getCurrentTrackName(), 20, 50);
        ofDrawBitmapString(spotify.getCurrentAlbumName(), 20, 75);
        ofDrawBitmapString(ofToString(spotify.getPosition()) + " / " + ofToString(spotify.getDuration()), 20, 100);
    }
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if (key == ' ') {
        !spotify.isPlaying() ? spotify.play("spotify:track:5pQYjzkALsgYOcFTC8DMmU") : spotify.stop();
    }
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){
    
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
    
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){
    
}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){
    
}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){
    
}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){
    
}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){
    
}
