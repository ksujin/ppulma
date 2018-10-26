//
//  SearchTVCell.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 27..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

class SearchTVCell: UITableViewCell {
    
    @IBOutlet weak var searchLbl: UILabel!
    func configure(data : String){
        searchLbl.text = data
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
