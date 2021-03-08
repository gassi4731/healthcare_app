//
//  EatTableViewCell.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/01.
//

import UIKit

class EatTableViewCell: UITableViewCell {

    @IBOutlet var typeAndContentLabel: UILabel!
    @IBOutlet var calLabel: UILabel!
    
    func setup(typeAndContent: String, cal: String) {
        typeAndContentLabel.text = typeAndContent
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
