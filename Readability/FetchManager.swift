//
//  FetchManager.swift
//  Readability
//
//  Created by Sushant Tiwari on 20/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class FetchManager: NSObject {
    class func getDataFor(_ str: String, _ completionBlock:@escaping ([Result])->()) {
        let urlStr = NSString(format: "https://toifeeds.indiatimes.com/feeds/testappsearch.cms?t=n&cleantag=syn&feedtype=sjson&query=%@&tag=relevance&ipver=425", str)
        guard let url = URL(string: urlStr as String) else {
            return
        }
        Alamofire.request(url).responseObject {
            (response: DataResponse<SearchResult>) in
            if let searchResults = response.result.value {
                if let resultList = searchResults.resultList {
                    completionBlock(resultList)
                }
            }
        }
    }
    
    class func getStoryFor(newsId id: String, _ completionBlock: @escaping (String) -> ()) {
        let urlStr = NSString(format: "https://toifeeds.indiatimes.com/feeds/testshowfeed.cms?feedtype=sjson&version=v5&tag=news&msid=%@&ipver=425", id)
        guard let url = URL(string: urlStr as String) else {
            return
        }
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, Any> {
                if let item = JSON["it"] as? Dictionary<String, Any> {
                    if let story = item["Story"] as? String {
                        completionBlock(story)
                    }
                }
            }
        }
    }
}
