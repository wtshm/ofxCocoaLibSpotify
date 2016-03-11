#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    spotify = ofxCocoaLibSpotify();
    spotify.setup("USERNAME", "PASSWORD");
    
    // error handling
    ofAddListener(spotify.errorEvent, this, &ofApp::onError);
}

//--------------------------------------------------------------
void ofApp::update(){
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    if (spotify.isPlaying()) {
        ofDrawBitmapString(spotify.getCurrentArtistName(), 15, 20);
        ofDrawBitmapString(spotify.getCurrentTrackName(), 15, 40);
        ofDrawBitmapString(spotify.getCurrentAlbumName(), 15, 60);
        ofDrawBitmapString(ofToString(spotify.getPosition()) + " / " + ofToString(spotify.getDuration()), 15, 80);
        
        if (spotify.getCurrentAlbumCover(albumCover)) {
            albumCover.draw(ofPoint(15, 100), albumCover.getWidth(), albumCover.getHeight());
        }
    }
}

//--------------------------------------------------------------
void ofApp::onError(int &errorCode){
    if (errorCode == 3) {
        cout << "The track cannot be played" << endl;
    }
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if (key == '1') {
        !spotify.isPlaying() ? spotify.play("spotify:track:4T26YGUHTE5LLbb8xnTHPL") : spotify.stop();
    }
    if (key == '2') {
        !spotify.isPlaying() ? spotify.play("spotify:track:5pmSezbf3VZeXvYBkggLhw") : spotify.stop(); // This track is not available in US.
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
