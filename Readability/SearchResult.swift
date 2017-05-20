//
//  SearchResult.swift
//  Readability
//
//  Created by Sushant Tiwari on 20/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import ObjectMapper

class SearchResult: Mappable {
    var pageInfo: String?
    var resultList: [Result]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        pageInfo <- map["pg"]
        resultList <- map["items"]
    }
}

class Result: Mappable {
    var headline: String?
    var link: String?
    var newsId: String?
    var domain: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        headline <- map["hl"]
        link <- map["su"]
        newsId <- map["id"]
        domain <- map["dm"]
    }
}
