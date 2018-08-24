//
//  FaceObject.swift
//  oumiji
//
//  Created by ominext on 8/7/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import Affdex

class FaceObject: NSObject {
    var name: String = ""
    var face_id: String = ""
    var gender: String = ""
    
    var joy: Float = 0
    var anger: Float = 0
    var fear: Float = 0
    var surprise: Float = 0
    var sadness: Float = 0
    var valence: Float = 0
    var disgust: Float = 0
    var contempt: Float = 0
    
    var nowjoy: Float = 0
    var nowanger: Float = 0
    var nowfear: Float = 0
    var nowsurprise: Float = 0
    var nowsadness: Float = 0
    var nowvalence: Float = 0
    var nowdisgust: Float = 0
    var nowcontempt: Float = 0
    
    var ad = (12, 12)
    var glasses = false
    var female = false
    
    var emotion: String = ""
    
    func firstUpdate(name: String, face_id: String, gender: String, face: AFDXFace) {
        self.name = name
        self.face_id = face_id
        self.gender = gender
        
        self.joy = Float(face.emotions.joy)
        self.anger = Float(face.emotions.anger)
        self.fear = Float(face.emotions.fear)
        self.surprise = Float(face.emotions.surprise)
        self.sadness = Float(face.emotions.sadness)
        self.valence = Float(face.emotions.valence)
        self.disgust = Float(face.emotions.disgust)
        self.contempt = Float(face.emotions.contempt)
        
        self.glasses = face.appearance.glasses == AFDX_GLASSES_YES ? true : false
        
        self.female = face.appearance.gender == AFDX_GENDER_FEMALE ? true : false
    }
    
    func update(face: AFDXFace) -> Void {
        self.joy = Float(face.emotions.joy)/2 + self.joy/2
        self.anger = Float(face.emotions.anger)/2 + self.anger/2
        self.fear = Float(face.emotions.fear)/2 + self.fear/2
        self.surprise = Float(face.emotions.surprise)/2 + self.surprise/2
        self.sadness = Float(face.emotions.sadness)/2 + self.sadness/2
        self.valence = Float(face.emotions.valence)/2 + self.valence/2
        self.disgust = Float(face.emotions.disgust)/2 + self.disgust/2
        self.contempt = Float(face.emotions.contempt)/2 + self.contempt/2
        
        self.nowjoy = Float(face.emotions.joy)
        self.nowanger = Float(face.emotions.anger)
        self.nowfear = Float(face.emotions.fear)
        self.nowsurprise = Float(face.emotions.surprise)
        self.nowsadness = Float(face.emotions.sadness)
        self.nowvalence = Float(face.emotions.valence)
        self.nowdisgust = Float(face.emotions.disgust)
        self.nowcontempt = Float(face.emotions.contempt)
        
        self.glasses = face.appearance.glasses == AFDX_GLASSES_YES ? true : false
        
        self.female = face.appearance.gender == AFDX_GENDER_FEMALE ? true : false
    }
    
    override init() {
//        super.init()
//        let obj = xxx()
//        obj.serve(customer: printx())
    }
    
    func realemotion() -> String? {
        var emo = Dictionary<String,Float>()
        emo["happy"] = self.joy
        emo["angry"] = self.anger
        emo["fear"] = self.fear
        emo["sad"] = self.sadness
        emo["surprise"] = self.surprise
        emo["neutral"] = 5 - self.joy - self.anger - self.fear - self.surprise - self.sadness
        //print(emo)
        let greatest = emo.max { a, b in a.value < b.value }
        let emoM = greatest?.key
        return emoM
    }
    
    func nowEmotion() -> String {
        var emo = Dictionary<String,Float>()
        emo["happy"] = self.nowjoy/0.02
        emo["angry"] = self.nowanger/0.02
        emo["fear"] = self.nowfear/0.02
        emo["sad"] = self.nowsadness/0.02
        emo["surprise"] = self.nowsurprise/0.02
        emo["neutral"] = (100 - self.nowjoy - self.nowanger - self.nowfear - self.nowsurprise - self.nowsadness)
        print(emo)
        //print(emo)
        //let greatest = emo.max { a, b in a.value < b.value }
        
        let greatest = emo.max { (key1, key2) -> Bool in
            return key1.value < key2.value
        }
       
        let emoM = greatest?.key
        return emoM!
        
        
    }
    
    func printx() -> Void {
        print(self)
    }
    
    deinit {
        print("deinit \(self)")
    }
}


