//
//  TaskTableViewCell.swift
//  health-plus
//
//  Created by Yo Higashida on 2021/03/09.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var checkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func check() {
        
    }
    
    func setup(labelText: String, image: Bool) {
        label.text = labelText
        if image {
            checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
        } else {
            checkButton.setImage(UIImage(systemName: "circle"), for: UIControl.State.normal)
        }
    }
}
