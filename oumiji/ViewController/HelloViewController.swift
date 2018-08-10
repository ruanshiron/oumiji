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
        startB.center.x = view.bounds.width/2
        startB.center.y = view.bounds.height/2 + helloV.bounds.height/2
        
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

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.helloV.frame.size.height = 335
            self.helloL.alpha = 1
        }
    }

    @IBAction func start(_ sender: UIButton) {
        if affdexCameraSucces == false {
            cameraIsPending = true
            return
        }
        openCamViewController()
    }
}

extension HelloViewController {
    func openCamViewController() {
        UIView.animate(withDuration: 0.5, animations: {
            self.helloV.frame.size.height = 90
            
            self.helloL.alpha = 0
        }) { (Done) in
            
            // Next View Controller
            DispatchQueue.main.async {

                let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let NextVC = Storyboard.instantiateViewController(withIdentifier: "CamViewController") as! CamViewController
                self.present(NextVC, animated: false, completion: nil)
            }
        }
    }
}

