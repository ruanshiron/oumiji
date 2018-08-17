////
////  demo.swift
////  oumiji
////
////  Created by ominext on 8/7/18.
////  Copyright © 2018 ominext. All rights reserved.
////
//
import Foundation
import UIKit
import Affdex
import AVKit

typealias CompletionHandle = ((Bool)->Void)?

protocol AffdexCameraDelegate {
    func updateImage(image: UIImage)
    func getKairos(image: UIImage, faces: NSMutableDictionary!)
    func updateFace(faces: NSMutableDictionary!)
    func restartDetect()
}


class AffdexCamera {
    private static var shared: AffdexCamera?
    
    class func instance() -> AffdexCamera {
        if shared == nil {
            shared = AffdexCamera.init()
        }
        return shared!
    }

    var affdexDelegate: AffdexCameraDelegate?
    
    var hadKairos:Bool = false
    
    var detector: AFDXDetector?
    
    var timeisWorking = false
    var timeToRe: Timer!
    
    var cameraReady = false
    
    var errorTime = 0
}

extension AffdexCamera: AFDXDetectorDelegate {
    func detector(_ detector: AFDXDetector!, hasResults faces: NSMutableDictionary!, for image: UIImage!, atTime time: TimeInterval) {
        self.unprocessedImageReady(detector, image: image, atTime: time)
        
        if (faces != nil) {
            self.processedImageReady(detector, image: image, faces: faces, atTime: time)
        }
    }
}

extension AffdexCamera {
    
    func createDetector(callback: CompletionHandle) {
        let cameraCapture = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: AVCaptureDevice.Position.front)!
        
        self.detector = AFDXDetector(delegate: self, using: cameraCapture, maximumFaces: 1, face: FaceDetectorMode.init(0))
        
        
        self.detector?.setDetectAllEmotions(true)
        self.detector?.maxProcessRate = 2
        self.detector?.glasses = true
        self.detector?.gender = true
        // START after
        
        callback?(true)
    }
    
    func startDetector() {
        if ((detector) != nil) {
            let error = self.detector?.start()
            print(error?.localizedDescription ?? "\(self): START")
        }
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(readyCamera), userInfo: nil, repeats: false)
    }
    
    func resetDetector() {
        if self.timeisWorking {
            self.timeToRe.invalidate()
        }
        
        cameraReady = false
        
        hadKairos = false
        
        timeisWorking = false
        
        errorTime = 0
        
        let error = self.detector?.stop()
        
        print(error?.localizedDescription ?? "\(self): STOP")
    }
    
    func reuseDetector() {
        if self.timeisWorking {
            self.timeToRe.invalidate()
        }
        
        cameraReady = false
        
        hadKairos = false
        
        timeisWorking = false
        
        errorTime = 0
        
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(readyCamera), userInfo: nil, repeats: false)
    }
    
    @objc func readyCamera() {
        cameraReady = true
    }
}

extension AffdexCamera {
    func unprocessedImageReady(_ detector: AFDXDetector?, image: UIImage?, atTime time: TimeInterval) {
        DispatchQueue.main.async {
            var flippedImage: UIImage? = nil
            if let anImage = image?.cgImage {
                flippedImage = UIImage(cgImage: anImage, scale: (image?.scale)!, orientation: .upMirrored)
                self.affdexDelegate?.updateImage(image: flippedImage!)
            }
        }
    }
    
    func processedImageReady(_ detector: AFDXDetector?, image: UIImage?, faces: NSMutableDictionary!, atTime time: TimeInterval) {
        if !cameraReady {
            return
        }
        
        if faces.allValues.count > 0 {
            if self.timeisWorking {
                self.timeToRe.invalidate()
                self.timeisWorking = false
            }
            
            if hadKairos == true {
                self.affdexDelegate?.updateFace(faces: faces)
            } else {
                
                self.affdexDelegate?.getKairos(image: image!, faces: faces)
                
                self.hadKairos = true
            }
        } else {
            
            if timeisWorking == false {
                self.timeToRe = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(restart), userInfo: nil, repeats: false)
                self.timeisWorking = true
            }
        }      
    }
}

extension AffdexCamera {
    @objc func restart() {
        self.affdexDelegate?.restartDetect()
        
    }
    
    
}

