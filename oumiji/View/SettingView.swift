//
//  SettingView.swift
//  oumiji
//
//  Created by ominext on 8/15/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit
class SettingView: UIView {
    
    
    @IBOutlet var content: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var settingFeature: UIView!
    
    @IBOutlet weak var guestModeSwitchKey: UISwitch!
    
    @IBOutlet weak var fastModeSwitchKey: UISwitch!
    
    @IBOutlet weak var defaultModeSwitchKey: UISwitch!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func customInit() {
       
        
        //
        Bundle.main.loadNibNamed("SettingView", owner: self, options: nil)
        self.addSubview(content)
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(destroySettingView(_:)))
        
        blurView.addGestureRecognizer(tap)
        
        settingFeature.layer.cornerRadius = 16
        
        
        if UserDefaults.standard.bool(forKey: "FAST_MODE") {
            UserDefaults.standard.setValue( false0, forKey: "FOR_GUEST")
        }
        
        fastModeSwitchKey.isOn = UserDefaults.standard.bool(forKey: "FAST_MODE")
        guestModeSwitchKey.isOn = UserDefaults.standard.bool(forKey: "FOR_GUEST")
        defaultModeSwitchKey.isOn = UserDefaults.standard.bool(forKey: "FOR_GUEST") || UserDefaults.standard.bool(forKey: "FAST_MODE") ? false : true
        
    }
    
    @objc fileprivate func destroySettingView(_ sender: UIView) {
        self.removeFromSuperview()
    }
    
    @IBAction func guestMode(_ sender: UISwitch) {
        if sender.isOn {
            guestModeSwitchKey.isOn = true
            fastModeSwitchKey.isOn = false
            defaultModeSwitchKey.isOn = false
        } else {
            defaultModeSwitchKey.isOn = true
        }
        
        UserDefaults.standard.setValue( guestModeSwitchKey.isOn, forKey: "FOR_GUEST")
        
        UserDefaults.standard.setValue( fastModeSwitchKey.isOn, forKey: "FAST_MODE")
    }
    
    @IBAction func fastMode(_ sender: UISwitch) {
        if sender.isOn {
            guestModeSwitchKey.isOn = false
            fastModeSwitchKey.isOn = true
            defaultModeSwitchKey.isOn = false
        } else {
            defaultModeSwitchKey.isOn = true
        }
        
        UserDefaults.standard.setValue( guestModeSwitchKey.isOn, forKey: "FOR_GUEST")
        
        UserDefaults.standard.setValue( fastModeSwitchKey.isOn, forKey: "FAST_MODE")
    }

    @IBAction func defaulfMode(_ sender: UISwitch) {
        if sender.isOn {
            guestModeSwitchKey.isOn = false
            fastModeSwitchKey.isOn = false
            defaultModeSwitchKey.isOn = true
        } else {
            defaultModeSwitchKey.isOn = true
        }
        
        UserDefaults.standard.setValue( guestModeSwitchKey.isOn, forKey: "FOR_GUEST")
        
        UserDefaults.standard.setValue( fastModeSwitchKey.isOn, forKey: "FAST_MODE")
    }
    
}
