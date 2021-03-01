//
//  EatTableViewCell.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/01.
//

import UIKit

class EatTableViewCell: UITableViewCell {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var calLabel: UILabel!
    
    func setup(type: String, content: String, cal: String) {
        typeLabel.text = type
        contentLabel.text = content
        calLabel.text = cal
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
