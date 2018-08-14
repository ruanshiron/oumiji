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
    
    @IBOutlet weak var faceBound: UIView!
    
    var face = FaceObject()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        faceBound.layer.borderWidth = 2
        faceBound.layer.borderColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1).cgColor
        faceBound.backgroundColor = UIColor(white: 1, alpha: 0)
        faceBound.layer.cornerRadius = 4
        faceBound.alpha = 0
        
        
        AffdexCamera.instance().affdexDelegate = self
        AffdexCamera.instance().startDetector()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        helloL.text = "Xin chào"
        helloL.font = helloL.font.withSize(32)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.helloL.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: nil)
        
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
            
            //print((face as! AFDXFace).emotions.dictionaryWithValues(forKeys: ["anger","contempt","fear","joy", "sadness", "surprise"]))
            
            self.faceBound.frame = (face as! AFDXFace).faceBounds
            
            break
        }
    }
    
    func restartDetect() {
        emoI.image = nil
    }
    
    
}



extension AffViewController {
   
    func updateEmoI() {
        let image = emotionImage(face: face)

        emoI.image = image
    
    }
    
    func emotionImage(face: FaceObject) -> UIImage? {
        let emotion = face.emotionGuest()
        
        
        
        if face.female == false {
            switch emotion {
            case "happy":
                return #imageLiteral(resourceName: "mhappy")
            case "sad":
                return #imageLiteral(resourceName: "msad")
            case "angry":
                return #imageLiteral(resourceName: "mangry")
            case "fear":
                return #imageLiteral(resourceName: "mfear")
            case "surprise":
                return #imageLiteral(resourceName: "msurprise")
            case "neutral":
                return #imageLiteral(resourceName: "mneutral")
            case "disgust":
                
                break
            case "valence":
                
                break
            case "contempt":
                return #imageLiteral(resourceName: "mcontempt")
            default:
                break
            }
        }
        
        switch emotion {
        case "happy":
            return #imageLiteral(resourceName: "fhappy")
        case "sad":
            return #imageLiteral(resourceName: "fsad")
        case "angry":
            return #imageLiteral(resourceName: "fangry")
        case "fear":
            return #imageLiteral(resourceName: "ffear")
        case "surprise":
            return #imageLiteral(resourceName: "fsurprise")
        case "neutral":
            return #imageLiteral(resourceName: "fneutral")
        case "disgust":
            
            break
        case "valence":
            
            break
        case "contempt":
            return #imageLiteral(resourceName: "fcontempt")
        default:
            break
        }
        
        return nil
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
        //emo["disgust"] = self.nowdisgust
        emo["contempt"] = self.nowcontempt
        //emo["valence"] = self.nowvalence
        emo["neutral"] = 100 - self.nowjoy - self.nowanger - self.nowfear - self.nowsurprise - self.nowsadness - self.contempt
        //print(emo)
        //print(emo)
        let greatest = emo.max { a, b in a.value < b.value }
        let emoM = greatest?.key
        return emoM!
    }
}
