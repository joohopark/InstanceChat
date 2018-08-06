//
//  MyBubbleCell.swift
//  InstanceChat
//
//  Created by 주호박 on 2018. 8. 6..
//  Copyright © 2018년 주호박. All rights reserved.
//

import UIKit

class MyBubbleCell: UITableViewCell {
    
    @IBOutlet internal weak var myTextBubble: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
