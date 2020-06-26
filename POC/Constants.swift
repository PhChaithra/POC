//
//  Constants.swift
//  POC
//
//  Created by ChaithraPH on 26/06/20.
//  Copyright © 2020 ChaithraPH. All rights reserved.
//

import Foundation
//All constant used in project
struct Constants {
    static let ContentURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    
    struct JSONKeys {
        static let ContentTitleKey = "title"
        static let  ContentRowKey = "rows"
        static let  DescriptionKey = "description"
        static let ImageUrlKey = "imageHref"
    }
}
