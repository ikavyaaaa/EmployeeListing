//
//  ServiceConnection.swift
//  Test
//
//  Created by Kavya on 09/07/22.
//

import Foundation

public class ServiceConnection : NSObject, URLSessionDelegate  {
    
    func GetData(completionHandler: (([[String:Any]]) -> Void)?) {
        let urlString = "https://www.mocky.io/v2/5d565297300000680030a986"
        GET(ServiceURL: urlString, completionHandler: completionHandler)
    }
    
    func GET(ServiceURL: String, completionHandler: (([[String:Any]]) -> Void)?) {
        print("getUrl---->",ServiceURL)
        let myOpQueue = OperationQueue()
        myOpQueue.maxConcurrentOperationCount = 3
        let semaphore = DispatchSemaphore(value: 0)
        let myURL : NSURL = NSURL(string: ServiceURL)!
        myOpQueue.addOperation {
            let request = NSMutableURLRequest(url: myURL as URL)
            request.httpMethod = "GET"
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = ["Content-Type" : "application/json"]
            var session: URLSession!
            if ServiceURL.contains("12.191.17.47") {
                session = Foundation.URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
            } else {
                session = Foundation.URLSession(configuration: configuration)
            }
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    semaphore.signal()
                    let httpResponse = response as? HTTPURLResponse
                    
                    if httpResponse?.statusCode == 200 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String : Any]]
                            completionHandler?(json);
                        } catch {
                            print("Error: ", error)
                        }
                    } else {
                        
                    }
                }
                if error == nil {
                    print("No Errors")
                } else {
                    print(error!)
                }
            })
            task.resume()
            semaphore.wait()
        }
    }
    
}
    
