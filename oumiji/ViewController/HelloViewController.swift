//
//  ViewController.swift
//  oumiji
//
//  Created by ominext on 8/6/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController {
    
    
    override var prefersStatusBarHidden: Bool { return true }
    
    var cameraIsPending = false
    var affdexCameraSucces = false

    @IBOutlet weak var helloV: UIView!
    
    @IBOutlet weak var helloVheightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var startB: UIButton!
    
    @IBOutlet weak var helloL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startB.layer.cornerRadius = startB.layer.frame.height/6
        
        //let backgroundQueue = DispatchQueue.global(qos: .background)
        //backgroundQueue.async {
            AffdexCamera.instance().createDetector(callback: {[weak self] (isSuccess) in
                if isSuccess == true
                {
                    self?.affdexCameraSucces = true
                    if (self?.cameraIsPending)! {
                        self?.openCamViewController()
                    }
                }
            })
        
        
        //}
        
        setHelloForDevice()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.helloL.alpha = 1
            self.startB.alpha = 1
            
            self.helloV.frame.origin.y = 0
        }
    }

    @IBAction func start(_ sender: UIButton) {
        
        if affdexCameraSucces == false {
            cameraIsPending = true
            return
        }
        if !UserDefaults.standard.bool(forKey: "FOR_GUEST") {
            openCamViewController()
            
        } else {
            openAffViewController()
        }
        
    }
    
    @IBAction func setting(_ sender: Any) {
        var settingView: SettingView? = SettingView.init(frame: self.view.bounds)
        
        self.view.addSubview(settingView!)
        settingView?.didClose = {
            settingView = nil
        }
        
    }
    @IBAction func infor(_ sender: Any) {
        let infoView = InfoView(frame: self.view.bounds)
        

        
        self.view.addSubview(infoView)
    }
}

extension HelloViewController {
    func openCamViewController() {
        UIView.animate(withDuration: 0.5, animations: {
            //self.helloV.frame.size.height = self.view.frame.height/10
            
            self.helloL.alpha = 0
            
            self.startB.alpha = 0
            
            self.helloV.frame.origin.y -= self.helloV.frame.size.height*9/10
        }) { (Done) in
            
            // Next View Controller
            DispatchQueue.main.async {

                let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let NextVC = Storyboard.instantiateViewController(withIdentifier: "CamViewController") as! CamViewController
                self.present(NextVC, animated: false, completion: nil)
            }
        }
    }
    
    func openAffViewController() {
        UIView.animate(withDuration: 0.5, animations: {
            //self.helloV.frame.size.height = 90
            
            self.helloL.alpha = 0
            
            self.startB.alpha = 0
            
            self.helloV.frame.origin.y -= self.helloV.frame.size.height*9/10
        }) { (Done) in
            
            // Next View Controller
            DispatchQueue.main.async {
                
                let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let NextVC = Storyboard.instantiateViewController(withIdentifier: "AffViewController") as! AffViewController
                self.present(NextVC, animated: false, completion: nil)
            }
        }
    }
    
    func setHelloForDevice() {
        let model = UIDevice.modelName
        let device = model.components(separatedBy: " ")
        let iphone = device[0]
        
        if iphone == "iPhone" {
            helloL.font = helloL.font.withSize(24)
        }
    }
}

