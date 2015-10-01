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
	@IBOutlet weak var artistNameLabel: UILabel!
	@IBOutlet weak var artworkImageView: UIImageView!

	var downloadTask: NSURLSessionDownloadTask?

    override func awakeFromNib() {
        super.awakeFromNib()

		selectedBackgroundView!.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		downloadTask?.cancel()
		downloadTask = nil

		nameLabel.text = nil
		artistNameLabel.text = nil
		artworkImageView.image = nil

	}

	func configureForSearchResults(searchResult: SearchResult) {
		nameLabel.text = searchResult.name

		if searchResult.artistName.isEmpty {
			artistNameLabel.text = "Unknown"
		} else {
			artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, searchResult.kindForDisplay())
		}

		artworkImageView.image = UIImage(named: "Placeholder")
		if let url = NSURL(string: searchResult.artworkURL60) {
			downloadTask = artworkImageView.loadImageWithURl(url)
		} else {
			print("Not getting artwork?")
		}
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
