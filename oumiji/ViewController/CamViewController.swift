//
//  ViewController.swift
//  oumiji
//
//  Created by ominext on 8/6/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import UIKit
import Affdex

protocol CamViewControllerDelegate {
    func doSomething()
}

class CamViewController: UIViewController {
    
    //MARK: Style UI
    override var prefersStatusBarHidden: Bool { return true }

    @IBOutlet weak var helloV: UIView!
    
    @IBOutlet weak var helloL: UILabel!
    @IBOutlet weak var helloLcentreYcontraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var nameLbottomContraint: NSLayoutConstraint!
    
    @IBOutlet weak var CameraView: UIImageView!
    
    @IBOutlet weak var emoB: UIStackView!
    
    @IBOutlet weak var faceI: UIImageView!
    
    @IBOutlet weak var notiV: UIView!
    @IBOutlet weak var notiVcontraint: NSLayoutConstraint!
    
    @IBOutlet weak var happyB: UIButton!
    @IBOutlet weak var sadB: UIButton!
    @IBOutlet weak var fearB: UIButton!
    @IBOutlet weak var surpriseB: UIButton!
    @IBOutlet weak var angryB: UIButton!
    @IBOutlet weak var neutralB: UIButton!
    
    //MARK: Variable
    var face: FaceObject = FaceObject()
    
    var timeEmotion: Timer!
    
    var fastMode: Bool!
    
    // MARK: override
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(toHelloViewController(_:)))
        
        helloV.addGestureRecognizer(tap)
        
        AffdexCamera.instance().affdexDelegate = self
        
        AffdexCamera.instance().startDetector()
        
        NotificationCenter.default.addObserver(self, selector: #selector(defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        
        defaultsChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configFirstLook()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        timeEmotion = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateEmotion), userInfo: nil, repeats: true)
        
        REconfigFirstLook()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //
        
        timeEmotion.invalidate()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Action
    @objc func toHelloViewController(_ sender: UIView) {
        AffdexCamera.instance().resetDetector()
        
        self.dismiss(animated: false, completion: nil)
    }

    
    @IBAction func emotionClick(_ sender: UIButton) {
        
        
        var emotion = String()
        
        switch sender.currentImage {
        case #imageLiteral(resourceName: "ihappy"):
            emotion = "happy"
            break
        case #imageLiteral(resourceName: "isad"):
            emotion = "sad"
            break
        case #imageLiteral(resourceName: "ifear"):
            emotion = "fear"
            break
        case #imageLiteral(resourceName: "isurprise"):
            emotion = "surprise"
            break
        case #imageLiteral(resourceName: "iangry"):
            emotion = "angry"
            break
        case #imageLiteral(resourceName: "ineutral"):
            emotion = "neutral"
            break
        
        default:
            break
        }
        
        face.emotion = emotion
        
        toByeViewController()
        
        print(emotion)
    }
    
    func toByeViewController() {
        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let NextVC = Storyboard.instantiateViewController(withIdentifier: "ByeViewController") as! ByeViewController
        NextVC.face = self.face
        NextVC.camDelegate = self
        self.present(NextVC, animated: false, completion: nil)
    }
    
    @objc func defaultsChanged() {
        fastMode = UserDefaults.standard.bool(forKey: "FAST_MODE")
        print("FAST MODE: \(fastMode)")
    }
    
}

//MARK: AffdexCamera Delegate
extension CamViewController: AffdexCameraDelegate {

    
    func updateImage(image: UIImage) {
        CameraView.image = image
    }
    
    func getKairos(image: UIImage, faces: NSMutableDictionary!) {
        if !API.isConnected() {
            print("Khong ket noi")
            self.updateError(error: "Không có kết nối")
            return
        }
        
        updateProcessing()
        
        API.getKairos(for: image) { (result, error) in
            
            
            DispatchQueue.main.async {
                self.faceI.image = image
                
                if let error = error {
                    print(error as AnyObject)
                    
                    AffdexCamera.instance().errorTime += 1
                    AffdexCamera.instance().hadKairos = false
                    
                    if AffdexCamera.instance().errorTime == 3 {
                        self.updateError(error: error as! String)
                    }
                    return
                }
                
                let name = (result as! [String:AnyObject])["name"] as? String
                let face_id = (result as! [String:AnyObject])["face_id"] as? String
                let confidence = (result as! [String:AnyObject])["confidence"] as? Float
                
                if let confidence = confidence, let name = name, let face_id = face_id {
                    for face in faces.allValues {
                        let faceO = face as! AFDXFace
                        self.face.firstUpdate(name: name, face_id: face_id, face: faceO)
                        break
                    }
                    
                    //Update Name here
                
                    if self.face.glasses {
                        if confidence < 0.91 {
                            self.updateError(error: "Không có dữ liệu khuôn mặt")
                            return
                        }
                    }
                    
                    if self.face.female {
                        if confidence < 0.75 {
                            self.updateError(error: "Không có dữ liệu khuôn mặt")
                            return
                        }
                    } else {
                        if confidence < 0.85 {
                            self.updateError(error: "Không có dữ liệu khuôn mặt")
                            return
                        }
                    }
                    
                    print("\(self.face.name): G:\(self.face.glasses), F:\(self.face.female)")
                    self.updateName(name: name)
                } else {
                    self.updateError(error: "Không có dữ liệu khuôn mặt")
                }
             
            }
        }
    
    }
    
    func updateFace(faces: NSMutableDictionary!) {
        for face in faces.allValues {
            let faceO = face as! AFDXFace
            self.face.update(face: faceO)
            break
        }
        
        print(face.realemotion() ?? " -- ")
        
    }
    
    @objc func restartDetect() {
        
        if !fastMode {
            toHelloViewController(helloV)
            return
        }
        
        print("reuse Dectect")

        AffdexCamera.instance().reuseDetector()
        
        REconfigFirstLook()
        
        
        if (face.face_id != ""){
            sendFace()
        }
        
        face = FaceObject()
        
    }
}

// MARK: API method
extension CamViewController {
    func sendFace() {
        if (face.face_id != "") {
            var param = Dictionary<String , AnyObject>()
            param["emotion_detect"] = face.realemotion() as AnyObject
            param["face_id"] = face.face_id as AnyObject
            param["employee_name"] = face.name as AnyObject
            
            API.postEmo(param: param) { (res) in
            }
            
            print("API emotion: \(param)")
        }
    }
    
    func checkConnection () {
        if !API.isConnected() {
            updateError(error: "Không có kết nối")
        }
    }
}

//MARK: UI config
extension CamViewController {
    func updateProcessing() {
        UIView.animate(withDuration: 0.2, animations: {
            self.helloL.alpha = 0
        }) { (Done) in
            if Done {
                UIView.animate(withDuration: 0.2) {
                    self.helloL.text = "Đang check hàng..."
                    self.helloL.alpha = 1
                    self.helloL.transform = .identity
                    self.helloL.center.y = 45
                    self.helloLcentreYcontraint.constant = 0
                }
            }
        }
    }
    
    func updateName(name: String) {
        helloLcentreYcontraint.constant = -18
        nameLbottomContraint.constant = 12
        notiVcontraint.constant = 60
        
        UIView.animate(withDuration: 0.5, animations: {
            self.helloL.center.y = self.helloV.frame.height/2
//            self.nameL.center.y = self.helloV.frame.height - 20
            self.helloL.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.helloL.alpha = 1
            
            self.helloL.center.y -= 18
            self.nameL.center.y -= 12
            
            self.nameL.text = name
            self.nameL.alpha = 1
            
            self.emoB.isHidden = false
            self.emoB.alpha = 1
            
            
        }) { (Done) in
            if Done {
                self.helloL.alpha = 0
                self.notiV.center.y = self.helloV.frame.height - self.notiV.frame.height/2
                UIView.animate(withDuration: 0.5) {
                    self.helloL.text = "Xin Chào"
                    self.helloL.alpha = 1
                    self.notiV.center.y += self.notiV.frame.height
                    self.notiV.alpha = 1
                }
            }
        }
        
    }
    
    func REconfigFirstLook() {
        self.helloLcentreYcontraint.constant = 0
        self.notiVcontraint.constant = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.helloL.center.y = 45
            self.helloL.transform = .identity

            self.nameL.alpha = 0
            
            self.notiV.center.y -= 60
            
            self.emoB.isHidden = true
            self.emoB.alpha = 0
            
            self.helloV.backgroundColor = UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0)
        }) { (Done) in
            if Done {
                self.helloL.text = "Mặt đâu rồi"
                self.notiV.alpha = 0
                self.helloL.alpha = 1
                self.nameLbottomContraint.constant = 0
            }
        }
        
        
    }
    
    func configFirstLook() {
   
        self.helloL.center.y = self.helloV.frame.height/2
        
        self.helloL.text = "Giữ nguyên cái mặt ở đấy"
        self.helloL.font = self.helloL.font.withSize(32)
        self.nameL.text = ""
        
        self.nameL.alpha = 0
        self.notiV.alpha = 0
        
        self.emoB.isHidden = true
        self.emoB.alpha = 0
        
        
    }
    
    func updateError(error: String){
        UIView.animate(withDuration: 0.2, animations: {
            self.helloL.alpha = 0
            self.nameL.alpha = 0
            
        }) { (Done) in
            if Done {
                UIView.animate(withDuration: 0.5, animations: {
                    self.helloL.text = error
                    self.helloL.alpha = 1
                    
                    self.helloV.backgroundColor = .red
                    
                })
                
            }
        }
        
        if !fastMode {
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(toHelloViewController(_:)), userInfo: nil, repeats: false)
            return
        }
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(restartDetect), userInfo: nil, repeats: false)
        
        if error == "Không có kết nối" {
            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(toHelloViewController(_:)), userInfo: nil, repeats: false)
            
            return
        }
        
        
        
     
    }
    
    
    @objc func updateEmotion() {
        
        var button = UIButton()
        
        switch face.nowEmotion() {
        case "happy":
            button = happyB
            break
        case "sad":
            button = sadB
            break
        case "fear":
            button = fearB
            break
        case "surprise":
            button = surpriseB
            break
        case "angry":
            button = angryB
            break
        case "neutral":
            button = neutralB
            break
        default:
            break
        }
        
        happyB.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        sadB.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        fearB.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        angryB.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        surpriseB.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        neutralB.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 3.0, options: [.allowUserInteraction], animations: {
            button.transform = .identity
        }, completion: { Done in
            if Done {
                //
            }
        })
        
    }
}

//MARK: CamViewController Delegate
extension CamViewController: CamViewControllerDelegate {
    
    func doSomething() {

        
        face = FaceObject()
        AffdexCamera.instance().affdexDelegate = self
        restartDetect()
    }
}


