//
//  Connection.swift
//  FiftyFifty
//
//  Created by Juan Marroquin on 5/8/17.
//  Copyright © 2017 Caroline Amy Debs. All rights reserved.
//

import Foundation

class Connection {
    private func fetch(endPoint: String, postString: String, completion: @escaping (_ json: [String:AnyObject]) -> Void) {
        var request = URLRequest(url: URL(string: "https://skillswapserver.herokuapp.com/\(endPoint)")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is ")
                print("response")
            }
            
            let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as! [String:AnyObject]
            print(json)
            completion(json)
            
        }
        task.resume()
    }
    
    
    func test() {
        fetch(endPoint: "testPing", postString: "hello=kek&id=3&juan=true", completion: {(json: [String:AnyObject]) -> Void in
            if (json["hello"] as? String) != nil {
                let hello = json["hello"] as? String
                print("\(hello!)")
            }
        })
    }
    
}
