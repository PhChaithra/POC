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
    func loadContentFrom(url:String,completionHandler: @escaping(Bool, NSError?)-> ())
    {
        
        AF.request(url).responseData{ response in
                switch response.result
                {
                    case .success:
                        var json:JSON
                        if JSONSerialization.isValidJSONObject(response.data!)
                        {
                            //If its a valid json then convert it to JSOn object
                            json = JSON(response.data!)
                        }
                        else
                        {
                            //If not valid JSON then convert to a valid one and then convert to JSON Object
                            let string = String(decoding: response.data!, as: UTF8.self)
                            let datFromString = Data(string.utf8)
                            json = JSON(datFromString)
                        }
                        
                        self.deSerialize(json: json)
                        completionHandler( true,nil)
                        
                    case .failure(let error):
                        
                        completionHandler( false,error as NSError)
                }
            }
            

    }

    private func deSerialize(json:JSON)
    {
        
        networkData = json[Constants.JSONKeys.ContentTitleKey].string!
        
        let titles = json[Constants.JSONKeys.ContentRowKey].arrayValue.map{$0[Constants.JSONKeys.ContentTitleKey].string}
        let descriptions = json[Constants.JSONKeys.ContentRowKey].arrayValue.map{$0[Constants.JSONKeys.DescriptionKey].string}
        let imageUrls = json[Constants.JSONKeys.ContentRowKey].arrayValue.map{$0[Constants.JSONKeys.ImageUrlKey].string}
         let count = titles.count
        self.contents.removeAll()
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
                //If any of the field is valid then only create one
                let content = Content(title: title, imageURL: url, description: desc)
                self.contents.append(content)
            }
            
        }
    }
}
