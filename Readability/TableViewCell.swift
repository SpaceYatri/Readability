//
//  TableViewCell.swift
//  Readability
//
//  Created by Sushant Tiwari on 20/05/17.
//  Copyright © 2017 Sushant Tiwari. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var websiteName: UILabel!
    @IBOutlet weak var linkDescription: UILabel!
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
        title.text = result.headline
        websiteName.text = result.displayLink
        linkDescription.text = result.description
        linkScore.text = "..."
        if let link = result.link {
            FetchManager.getScoreFor(link) { [unowned self] (scoreResult) in
                self.linkScore.text = scoreResult
            }
        }
    }
}
