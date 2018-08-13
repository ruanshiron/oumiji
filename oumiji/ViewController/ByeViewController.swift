//
//  ByeViewController.swift
//  oumiji
//
//  Created by ominext on 8/6/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import UIKit


class ByeViewController: UIViewController {
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var backB: UIButton!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var adviceL: UILabel!
    
    @IBOutlet weak var emoI: UIImageView!
    
    @IBOutlet weak var infoV: UIView!
    
    var face: FaceObject?
    
    var camDelegate: CamViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backB.layer.cornerRadius = backB.layer.frame.height/6
        emoI.alpha = 0
        infoV.alpha = 0

        nameL.text = "Chào \(face?.name ?? "ai đó :)")"
        

        var param = Dictionary<String , AnyObject>()
        param["advice"] = face?.emotion as AnyObject
        param["emotion_detect"] = face?.realemotion() as AnyObject
        param["emotion"] = face?.emotion as AnyObject
        param["face_id"] = face?.face_id as AnyObject
        param["employee_name"] = face?.name as AnyObject
        
        print("REAL: \(face?.realemotion() ?? "hihi")")
        
        API.getAdvice(param: param) { (result) in
            print(result.data ?? "-----")
            guard let dict = (result.data as? [String: Any]) else {return}
            guard let items = (dict["items"] as? String) else {return}
            
            self.adviceL.text = items
            self.adviceL.bounds.size.height += 32
        }
        
        API.postEmo(param: param) { (res) in
            //
        }
        
        API.sadSend(param: param) { (res) in
            //
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AffdexCamera.instance().affdexDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var image = UIImage()
        switch face?.emotion {
        case "happy":
            image = #imageLiteral(resourceName: "ihappy")
            break
        case "sad":
            image = #imageLiteral(resourceName: "isad")
            break
        case "fear":
            image = #imageLiteral(resourceName: "ifear")
            break
        case "surprise":
            image = #imageLiteral(resourceName: "isurprise")
            break
        case "angry":
            image = #imageLiteral(resourceName: "iangry")
            break
        case "neutral":
            image = #imageLiteral(resourceName: "ineutral")
            break
        default:
            break
        }
        self.emoI.image = image
        
        UIView.animate(withDuration: 0.3, animations: {
            self.infoV.alpha = 1
        }) { (DONE) in
            if DONE {
                UIView.animate(withDuration: 0.5) {
                    self.emoI.alpha = 1
                }
            }
        }
        
        emoAnimation(for: (face?.emotion)!)
    }


    @IBAction func backClick(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.camDelegate?.doSomething()
        }
    }
}

extension ByeViewController {
    func emoAnimation(for emotion: String) {
        switch face?.emotion {
        case "happy":
            
            break
        case "sad":
            
            break
        case "fear":
            
            break
        case "surprise":
            
            break
        case "angry":
            self.emoI.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.05, initialSpringVelocity: 20, options: [.repeat], animations: {
                self.emoI.center.y -= 12
                self.emoI.transform = .identity
            }, completion: nil)
            break
        case "neutral":
            UIView.animate(withDuration: 10, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 20, options: [.repeat], animations: {
                self.emoI.center.y -= 12
            }, completion: nil)
            break
        default:
            break
        }
    }
}

extension ByeViewController: AffdexCameraDelegate {

    
    func updateImage(image: UIImage) {
        //
    }
    
    func getKairos(image: UIImage, faces: NSMutableDictionary!) {
        //
    }
    
    func updateFace(faces: NSMutableDictionary!) {
        //
    }
    
    func restartDetect() {
        backClick(backB)
    }
    
    
}

