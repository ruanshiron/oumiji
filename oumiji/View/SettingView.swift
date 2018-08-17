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
    
    
    var didClose: (()-> Void)?
    
    @IBOutlet var content: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var settingFeature: UIView!
    
    @IBOutlet weak var guestModeSwitchKey: UISwitch!
    
    @IBOutlet weak var fastModeSwitchKey: UISwitch!
    
    @IBOutlet weak var defaultModeSwitchKey: UISwitch!
    
    weak var top: NSLayoutConstraint!
    weak var bot: NSLayoutConstraint!
    weak var leadding: NSLayoutConstraint!
    weak var trailling: NSLayoutConstraint!
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
            UserDefaults.standard.setValue( false, forKey: "FOR_GUEST")
        }
        
        fastModeSwitchKey.isOn = UserDefaults.standard.bool(forKey: "FAST_MODE")
        guestModeSwitchKey.isOn = UserDefaults.standard.bool(forKey: "FOR_GUEST")
        defaultModeSwitchKey.isOn = UserDefaults.standard.bool(forKey: "FOR_GUEST") || UserDefaults.standard.bool(forKey: "FAST_MODE") ? false : true
        
        
        
    }
    
    
    override func didMoveToSuperview() {
        layoutInSuperView()
    }
    
    override func removeFromSuperview() {
        self.superview?.removeConstraints([top, leadding, bot, trailling])
        self.setNeedsLayout()
        self.setNeedsDisplay()
        self.superview?.layoutIfNeeded()
        if self.didClose != nil {
            self.didClose!()
        }
        
    }
   
    
    private func layoutInSuperView()
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        top = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1, constant: 0)
        leadding = NSLayoutConstraint.init(item: self, attribute: .leading, relatedBy: .equal, toItem: self.superview, attribute: .leading, multiplier: 1, constant: 0)
        bot = NSLayoutConstraint.init(item: self.superview!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        trailling = NSLayoutConstraint.init(item: self.superview!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        self.superview?.addConstraints([top, leadding, bot, trailling])
    }
    
    @objc fileprivate func destroySettingView(_ sender: UIView) {
        
        self.content.removeFromSuperview()
        self.content = nil
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
