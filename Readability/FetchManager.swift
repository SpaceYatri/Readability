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
        let urlStr = NSString(format: "https://www.googleapis.com/customsearch/v1?key=AIzaSyBS4gWNvLWwO2_WBnhAkZB69dADFk4C6ms&cx=012118702810664718029:zw8wtyesfao&q=%@", str)
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
    
    class func getScoreFor(_ urlString: String, _ completionBlock: @escaping (String) -> ()) {
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            completionBlock("?")
            return
        }
        let urlStr = NSString(format: "https://www.webpagefx.com/tools/read-able/check.php?tab=Test+By+Url&uri=%@", encodedString)
        guard let url = URL(string: urlStr as String) else {
            return
        }
        Alamofire.request(url).responseData { (response) in
            guard let value = response.value else {
                return
            }
            DispatchQueue.global(qos: .background).async {
                let str = String(data: value, encoding: String.Encoding.utf8)
                let score = parseHtmlForScore(str)
                DispatchQueue.main.async {
                    completionBlock(score)
                }
            }
        }
    }
    
    class func parseHtmlForScore(_ aRawHTML: String?) -> String {
        guard let rawHTML = aRawHTML else {
            return "?"
        }
        var filteredHTML = rawHTML.replacingOccurrences(of: " ", with: "")
        filteredHTML = filteredHTML.replacingOccurrences(of: "\n", with: "")
        if let range1 = filteredHTML.range(of: "<th>AutomatedReadabilityIndex</th><td>") {
            filteredHTML = filteredHTML.substring(from: range1.upperBound)
            if let range2 = filteredHTML.range(of: "</td>") {
                filteredHTML = filteredHTML.substring(to: range2.lowerBound)
                return filteredHTML
            }
        }
        return "?"
    }
}
