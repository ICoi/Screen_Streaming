//
//  ViewController.swift
//  Screen_Streaming
//
//  Created by 정다운 on 2018. 8. 28..
//  Copyright © 2018년 정다운. All rights reserved.
//

import UIKit
import ReplayKit
import VideoToolbox

class ViewController: UIViewController, RPScreenRecorderDelegate {

    let rpScreenRecorder : RPScreenRecorder = RPScreenRecorder.shared()
    private var broadcaster: RTMPBroadcaster = RTMPBroadcaster()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        sharedRecorder = RPScreenRecorder.shared()
        broadcaster.streamName = "qqrz-8ay2-f6sx-e8v2"
        broadcaster.connect("rtmp://a.rtmp.youtube.com/live2/", arguments: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Streaming
    @IBAction func startScreenStreaming(_ sender: Any) {
        rpScreenRecorder.startCapture(handler: { (cmSampleBuffer, rpSampleBufferType, error) in
            if (error != nil) {
                print("Error is occured \(error.debugDescription)")
            } else {
                
                if (rpSampleBufferType == RPSampleBufferType.audioApp) {
                    print("Audio")
                    self.broadcaster.appendSampleBuffer(cmSampleBuffer, withType: .audio)
                    
                } else if (rpSampleBufferType == RPSampleBufferType.video) {
                    print("Video")
                    
                    
                    if let description: CMVideoFormatDescription = CMSampleBufferGetFormatDescription(cmSampleBuffer) {
                        let dimensions: CMVideoDimensions = CMVideoFormatDescriptionGetDimensions(description)
                        self.broadcaster.stream.videoSettings = [
                            "width": dimensions.width,
                            "height": dimensions.height ,
                            "profileLevel": kVTProfileLevel_H264_Baseline_AutoLevel
                        ]
                    }
                    self.broadcaster.appendSampleBuffer(cmSampleBuffer, withType: .video)
                }
                
                
            }
        }) { (error) in
            if ( error != nil) {
                print ( "Error occured \(error.debugDescription)")
            } else {
                print ("Success")
            }
        }
    }
    
    @IBAction func endScreenStreaming(_ sender: Any) {
        rpScreenRecorder.stopCapture { (error) in
            if (error != nil) {
                print("Error is occured \(error.debugDescription)")
            }
            self.broadcaster.close()
        }
    }
    // MARK: Camera
    var sharedRecorder :RPScreenRecorder? = nil
    
    @IBAction func askCameraPermission(_ sender: Any) {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {
                
            }
        }
    }
    
    @IBAction func turnOnCamera(_ sender: Any) {
        sharedRecorder?.isCameraEnabled = true
    }
    @IBAction func showCamera(_ sender: Any) {
        let cameraView = sharedRecorder?.cameraPreviewView
        
        if(cameraView != nil) {
            cameraView?.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            self.view.addSubview(cameraView!)
        }
    }
    
    // MARK: Microphone
    
    @IBAction func askMicrophonePermission(_ sender: Any) {
    }
    
    @IBAction func turnOnMic(_ sender: Any) {
    }
    
    // MARK: RPScreenRecorderDelegate
    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        print("did Stop Recording")
    }
    
    
    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("screenRecorderDidChangeAvailability")
        
    }
}

