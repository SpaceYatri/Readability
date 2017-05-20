//
//  TableViewCell.swift
//  Readability
//
//  Created by Sushant Tiwari on 20/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var linkName: UILabel!
    @IBOutlet weak var linkScore: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func create(_ result: Result) {
        linkName.text = result.headline
        linkScore.text = "..."
        calculateReadabilityScore(forResult: result) {
            [unowned self] (readabilityScore: String) in
            self.linkScore.text = readabilityScore
        }
    }
    
    func calculateReadabilityScore(forResult result: Result, _ completionBlock: @escaping (String) -> ()) {
        guard let newsId = result.newsId else {
            completionBlock("?")
            return
        }
        FetchManager.getStoryFor(newsId: newsId) { [unowned self] (storyText: String) in
            DispatchQueue.global(qos: .background).async {
                let story = self.trim(storyText)
                let readabilityScore = self.calculateScoreFor(story)
                DispatchQueue.main.async {
                    completionBlock(readabilityScore)
                }
            }
        }
    }
    
    func trim(_ story: String) -> String {
        return story.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func calculateScoreFor(_ text: String) -> String {
        var charCount: Double = 0
        var wordCount: Double = 0
        var sentCount: Double = 0
        
        for char in text.characters {
            if(char == " ") {
                wordCount += 1
            } else if(char == ".") {
                sentCount += 1
            } else {
                charCount += 1
            }
        }
        
        if(wordCount == 0 || sentCount == 0) {
            return "?"
        }
        
        var readabilityScore = 4.71 * (charCount/wordCount) + 0.5 * (wordCount/sentCount) - 21.43
        readabilityScore = Double(Int(readabilityScore * 10)) / 10
        return "\(readabilityScore)"
    }
    
}
