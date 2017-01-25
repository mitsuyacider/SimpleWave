
#include "ofApp.h"

//  IMPORTANT!!! if your sound doesn't work in the simulator
//	read this post => http://www.cocos2d-iphone.org/forum/topic/4159
//  which requires you set the input stream to 24bit!!

//--------------------------------------------------------------
void ofApp::setup(){
    ofSetFrameRate(60);
    ofBackground(255);
	ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right

	//for some reason on the iphone simulator 256 doesn't work - it comes in as 512!
	//so we do 512 - otherwise we crash
	initialBufferSize = 512;
	sampleRate = 44100;
	drawCounter = 0;
	bufferCounter = 0;
	
	buffer = new float[initialBufferSize];
	memset(buffer, 0, initialBufferSize * sizeof(float));

	// 0 output channels,
	// 1 input channels
	// 44100 samples per second
	// 512 samples per buffer
	// 1 buffer
	ofSoundStreamSetup(0, 1, this, sampleRate, initialBufferSize, 1);
    
    sound.load("sounds/beat.caf");
    sound.setLoop(true);
    sound.play();
    sound.setVolume(0);
    
    soundStream.setup(this, 0, 1, sampleRate, initialBufferSize, 1);
    ofSetColor(54, 181, 228);
    ofSetLineWidth(4);
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
    drawCounter++;
    
    ofPushStyle();
    
    float y1 = ofGetHeight() * 0.5;
    
    float oldx = 0;
    float oldy = 0;
	for(int i = 0; i<initialBufferSize; i++) {
        float p = i / (float)(initialBufferSize-1);
        float x = p * ofGetWidth();
        float y2 = y1 + buffer[i] * 200;
        
        if (i > 0) {
            ofDrawLine(oldx, oldy, x, y2);
        }
        
        oldx = x;
        oldy = y2;
	}
    ofPopStyle();
}

//--------------------------------------------------------------
void ofApp::exit(){
    //
}

//--------------------------------------------------------------
void ofApp::audioIn(float * input, int bufferSize, int nChannels){
	if(initialBufferSize < bufferSize){
		ofLog(OF_LOG_ERROR, "your buffer size was set to %i - but the stream needs a buffer size of %i", initialBufferSize, bufferSize);
	}	

	int minBufferSize = MIN(initialBufferSize, bufferSize);
	for(int i=0; i<minBufferSize; i++) {
		buffer[i] = input[i];
	}
	bufferCounter++;
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
//    sound.setVolume(1.0);
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
	
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    sound.setVolume(0.0);
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::lostFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotFocus(){
    
}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){
    ofSetOrientation(OF_ORIENTATION_90_RIGHT);//Set iOS to Orientation Landscape Right
    
    UIApplication * app = [UIApplication sharedApplication];
    // status bar orientations are reversed from device orientations
    // so that we can use OF coordinates to layout UIKit widgets.
    if ( newOrientation == UIDeviceOrientationLandscapeLeft ) {
        [app setStatusBarOrientation: UIInterfaceOrientationLandscapeRight
                            animated:YES];
    } else if ( newOrientation == UIDeviceOrientationLandscapeRight ) {
        [app setStatusBarOrientation: UIInterfaceOrientationLandscapeLeft
                            animated:YES];
    }
}

