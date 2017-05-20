//
//  SearchResult.swift
//  Readability
//
//  Created by Sushant Tiwari on 20/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import ObjectMapper

class SearchResult: Mappable {
    var resultList: [Result]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        resultList <- map["items"]
    }
}

class Result: Mappable {
    var headline: String?
    var link: String?
    var description: String?
    var displayLink: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        headline <- map["title"]
        link <- map["link"]
        description <- map["snippet"]
        displayLink <- map["displayLink"]
    }
}
