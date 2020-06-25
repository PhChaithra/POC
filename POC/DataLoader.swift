//
//  DataLoader.swift
//  POC
//
//  Created by ChaithraPH on 25/06/20.
//  Copyright © 2020 ChaithraPH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class DataLoader:NSObject {
    var networkData:String = ""
    var contents:[Content] = [Content]()
    
    static let sharedLoader = DataLoader()
    
    private override init()
    {
        
    }
    func loadContentFrom(url:String,completionHandler: @escaping(_ success:Bool)-> ())
    {
        
        AF.request(url).responseData{ response in
                switch response.result
                {
                    case .success:
                        var json:JSON
                        if JSONSerialization.isValidJSONObject(response.data!)
                        {
                            json = JSON(response.data!)
                        }
                        else
                        {
                            let string = String(decoding: response.data!, as: UTF8.self)
                            let datFromString = Data(string.utf8)
                            json = JSON(datFromString)
                        }
                        
                        self.deSerialize(json: json)
                    completionHandler( true)
                        
                    case .failure(let error):
                        
                        print(error)
                }
            }
            

    }

    private func deSerialize(json:JSON)
    {
        networkData = json["title"].string!
        
        let titles = json["rows"].arrayValue.map{$0["title"].string}
        let descriptions = json["rows"].arrayValue.map{$0["description"].string}
        let imageUrls = json["rows"].arrayValue.map{$0["imageHref"].string}
         let count = titles.count
        for index in 0..<count {
            var title:String = ""
            var url: String = ""
            var desc : String = ""
            
            if titles[index] != nil {
                title = titles[index]!
            }
            if imageUrls[index] != nil {
                url = imageUrls[index]!
            }
            if descriptions[index] != nil {
                desc = descriptions[index]!
            }
            if title.count>0 || url.count>0 || desc.count>0
            {
                let content = Content(title: title, imageURL: url, description: desc)
                self.contents.append(content)
            }
            
        }
    }
}