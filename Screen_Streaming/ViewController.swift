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
        
        
        broadcaster.streamName = "streamName"
        broadcaster.connect("rtmp://a.rtmp.youtube.com/live2/qqrz-8ay2-f6sx-e8v2", arguments: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startScreenStreaming(_ sender: Any) {
        rpScreenRecorder.startCapture(handler: { (cmSampleBuffer, rpSampleBufferType, error) in
            if (error != nil) {
                print("Error is occured \(error.debugDescription)")
            } else {
                
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
        }
    }
    
    /********** RPScreenRecorderDelegate *********/
    
    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        print("did Stop Recording")
    }
    
    
    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("screenRecorderDidChangeAvailability")
        
    }
}

