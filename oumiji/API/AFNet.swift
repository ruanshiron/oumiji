//
//  AFNet.swift
//  oumiji
//
//  Created by ominext on 8/7/18.
//  Copyright © 2018 ominext. All rights reserved.
//

import AFNetworking
import UIKit
import Foundation

enum Method_: String {
    case Post = "POST"
    case Get = "GET"
}

let ApiNameImageRequest = "imageRequest.php"

typealias CompletionRequest = ((_ resutl: Result)->Void)?

class NetWork: AFHTTPSessionManager {
    
    static let shared: NetWork = NetWork(baseURL: URL(string: "http://192.168.1.67:8888/testExample/imageRequest.php"), sessionConfiguration: nil)
    
    static let shared2: NetWork = NetWork(baseURL: URL(string: "http://192.168.1.67:8888/testExample/request.php"), sessionConfiguration: nil)
    
    static let shared3: NetWork = NetWork(baseURL: URL(string: "http://192.168.1.67:8888/testExample/sent.php"), sessionConfiguration: nil)
    
    override init(baseURL url: URL?, sessionConfiguration configuration: URLSessionConfiguration?) {
        super.init(baseURL: url, sessionConfiguration: configuration)
        let request = AFHTTPRequestSerializer()
        let response = AFHTTPResponseSerializer()
        
        let acceptableTypes = NSSet(set: self.responseSerializer.acceptableContentTypes ?? Set<String>())
        acceptableTypes.addingObjects(from: ["application/json","text/html", "text/json", "image/png", "image/jpeg", "image/jpg"])
        response.acceptableContentTypes = acceptableTypes as? Set<String>
        
        self.securityPolicy.allowInvalidCertificates = true
        self.securityPolicy.validatesDomainName = false
        
        request.timeoutInterval = 30
        
        
        self.requestSerializer = request
        self.responseSerializer = response
        self.reachabilityManager.startMonitoring()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestWith(method: Method_, apiName: String ,param: [String: Any]?, callBack: CompletionRequest) {
        
        let url = (self.baseURL?.absoluteString)! + apiName
        
        let request = self.requestSerializer.request(withMethod: method.rawValue, urlString: url, parameters: param, error: nil)
        
        let task = self.dataTask(with: request as URLRequest, uploadProgress: nil, downloadProgress: nil) { (response, responseObject, error) in
            let result = Result.init(withResponse: response, dataResponse: responseObject, error: error)
            callBack?(result)
        }
        
        task.resume()
    }
}



