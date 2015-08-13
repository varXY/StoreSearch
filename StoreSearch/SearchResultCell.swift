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

		/* old way doing this:
		let selectedView = UIView(frame: CGRect.zeroRect)
		selectedView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
		selectedBackgroundView = selectedView
		*/

		// my way doing this:
		
		selectedBackgroundView = UIView()
		selectedBackgroundView.backgroundColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 0.5)
	}

	override func prepareForReuse() {
		super.prepareForReuse()

		downloadTask?.cancel()
		downloadTask = nil

		nameLabel.text = nil
		artistNameLabel.text = nil
		artworkImageView.image = nil

		println("resused")
	}

	func configureForSearchResults(searchResult: SearchResult) {
		nameLabel.text = searchResult.name

		if searchResult.artistName.isEmpty {
			artistNameLabel.text = "Unknown"
		} else {
			artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, kindForDisplay(searchResult.kind))
		}

		artworkImageView.image = UIImage(named: "Placeholder")
		if let url = NSURL(string: searchResult.artworkURL60) {
			downloadTask = artworkImageView.loadImageWithURl(url)
		}
	}

	func kindForDisplay(kind: String) -> String {
		switch kind {
		case "album": return "Album"
		case "audiobook": return "Audio Book"
		case "book": return "Book"
		case "ebook": return "E-Book"
		case "feature-movie": return "Movie"
		case "music-video": return "Music Video"
		case "podcast": return "Podcast"
		case "software": return "App"
		case "song": return "Song"
		case "tv-episode": return "TV Episode"
		default: return kind
		}
	}

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
