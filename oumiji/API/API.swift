//
//  API.swift
//  oumiji
//
//  Created by ominext on 8/7/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

typealias completionBlock = ((AnyObject?, AnyObject?)->Void)

class API: NSObject {
    class func isConnected() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    class func getKairos(for image: UIImage, _ callback: @escaping completionBlock) -> Void {
        let Kairos = KairosAPI(app_id: "1316c881", app_key: "f72d0ad2fa24a8bbed931ddc3bb48813")
        
        let base64ImageData = Kairos.convertImageToBase64String(image: image)
        
        // setup json request params, with base64 data
        let jsonBodyDetect = [
            "image": base64ImageData,
            "gallery_name": "Ominext"
        ]
        
        Kairos.request(method: "recognize", data: jsonBodyDetect) { (data, error) in
            if let image = (data as? [String : AnyObject])!["images"]{
                // Parsing Response
                var images = image as! [AnyObject]
                let transaction = (images[0] as? [String : AnyObject])!["transaction"]!
                
                var passdata = [String:AnyObject]()
                passdata["name"] = (transaction as? [String : AnyObject])?["subject_id"] as? String as AnyObject
                passdata["face_id"] = (transaction as? [String : AnyObject])?["face_id"] as? String as AnyObject
                let sconfidence = (transaction as? [String : AnyObject])?["confidence"]
                
                print(data as Any)
                
                let confidence = (sconfidence as AnyObject).floatValue
                
                passdata["confidence"] = confidence as AnyObject
                
                if passdata["name"] != nil {
                    //print("Hello \(String(describing: passdata["name"]))")
                    callback(passdata as AnyObject, nil)
                } else {
                    print(error as Any)
                    let errorContent = Kairos.stringError(errors: error)
                    callback(nil, errorContent as AnyObject)
                }
            }
            else {
                print(error as Any)
                let errorContent = Kairos.stringError(errors: error)
                callback(nil, errorContent as AnyObject)
            }
        }
    }
    
    class func postEmo(param: [String:AnyObject]?, callBack: CompletionRequest) {
        NetWork.shared2.requestWith(method: .Post, apiName: "request.php", param: param, callBack: callBack)
    }
    
    class func getAdvice(param: [String: Any]?, callBack: CompletionRequest) {
        NetWork.shared.requestWith(method: .Post, apiName: ApiNameImageRequest, param: param, callBack: callBack)
    }
    
    class func sadSend (param: [String: Any]?, callBack: CompletionRequest) {
        NetWork.shared3.requestWith(method: .Post, apiName: ApiNameImageRequest, param: param, callBack: callBack)
    }
}
