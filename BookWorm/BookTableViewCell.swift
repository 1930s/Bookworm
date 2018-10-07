//
//  BookTableViewCell.swift
//  BookWorm
//
//  Created by Hegde, Vandana on 8/27/16.
//  Copyright © 2016 Hegde, Vikram. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var editionLabel: UILabel!
    @IBOutlet weak var shelf: UIImageView!
    @IBOutlet weak var noBookLabel: UILabel!
    
    var book: Book! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
