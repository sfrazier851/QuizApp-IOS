//
//  ViewRankingTableViewCell.swift
//  QuizApp-IOS
//
//  Created by Maricel Sumulong on 3/23/22.
//

import UIKit

class ViewRankingTableViewCell: UITableViewCell {

    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var score: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
