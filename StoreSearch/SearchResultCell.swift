//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by 文川术 on 15/8/8.
//  Copyright (c) 2015年 xiaoyao. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var aritistNameLabel: UILabel!
	@IBOutlet weak var artworkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

		/* old way doing this:
		let selectedView = UIView(frame: CGRect.zeroRect)
		selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
		selectedBackgroundView = selectedView
		*/

		// my way doing this:
		
		selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
