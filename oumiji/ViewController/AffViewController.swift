//
//  AffViewController.swift
//  oumiji
//
//  Created by ominext on 8/13/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import UIKit
import Affdex

class AffViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var CameraView: UIImageView!
    
    @IBOutlet weak var emoI: UIImageView!
    
    @IBOutlet weak var helloL: UILabel!
    
    @IBOutlet weak var infoL: UILabel!
    
    var face = FaceObject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AffdexCamera.instance().affdexDelegate = self
        AffdexCamera.instance().startDetector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        helloL.text = "Xin chào"
        helloL.font = helloL.font.withSize(32)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
            self.helloL.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (Done) in
            if Done {
                UIView.animate(withDuration: 0.5, animations: {
                    self.helloL.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                    self.helloL.frame.origin.y = 12
                })
            }
        }  
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AffdexCamera.instance().resetDetector()
        
    }
    @IBAction func backClick(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}

extension AffViewController: AffdexCameraDelegate {
    func updateImage(image: UIImage) {
        CameraView.image = image
    }
    
    func getKairos(image: UIImage, faces: NSMutableDictionary!) {
        AffdexCamera.instance().hadKairos = true
    }
    
    func updateFace(faces: NSMutableDictionary!) {
        for face in faces.allValues {
            self.face.update(face: face as! AFDXFace)
            updateEmoI()
            break
        }
    }
    
    func restartDetect() {
        //
    }
    
    
}



extension AffViewController {
    func updateEmoI() {
        var image = UIImage()
        
        switch face.emotionGuest() {
        case "happy":
            image = #imageLiteral(resourceName: "ihappy")
            break
        case "sad":
            image = #imageLiteral(resourceName: "isad")
            break
        case "angry":
            image = #imageLiteral(resourceName: "iangry")
            break
        case "fear":
            image = #imageLiteral(resourceName: "ifear")
            break
        case "surprise":
            image = #imageLiteral(resourceName: "isurprise")
            break
        case "neutral":
            image = #imageLiteral(resourceName: "ineutral")
            break
        case "disgust":
            
            break
        case "valence":

            break
        case "contempt":

            break
        default:
            break
        }
        
        emoI.image = image
    }
}

fileprivate extension FaceObject {
    func emotionGuest() -> String {
        var emo = Dictionary<String,Float>()
        emo["happy"] = self.nowjoy
        emo["angry"] = self.nowanger
        emo["fear"] = self.nowfear
        emo["sad"] = self.nowsadness
        emo["surprise"] = self.nowsurprise
        emo["disgust"] = self.nowdisgust
        emo["contempt"] = self.nowcontempt
        emo["valence"] = self.nowvalence
        emo["neutral"] = 100 - self.nowjoy - self.nowanger - self.nowfear - self.nowsurprise - self.nowsadness - self.contempt - self.disgust - self.valence
        print(emo)
        //print(emo)
        let greatest = emo.max { a, b in a.value < b.value }
        let emoM = greatest?.key
        return emoM!
    }
}
