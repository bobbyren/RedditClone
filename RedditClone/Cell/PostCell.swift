//
//  PostCell.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/7/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var constraintThumbnailWidth: NSLayoutConstraint!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelComments: UILabel!
    
    var post: Post?
    
    func configure(with post: Post) {
        self.post = post
        labelTitle.text = post.title ?? "N/A"
        labelAuthor.text = post.author ?? "N/A"
        labelComments.text = "Comments: \(post.comments)"
        
        if let url = post.thumbnail {
            constraintThumbnailWidth.constant = 68
            thumbnailView.load(imageUrl: url)
        } else {
            constraintThumbnailWidth.constant = 0
        }
        
        if let date = post.created {
            let hours = date.hoursAgo
            if hours == 1 {
                labelDate.text = "1 hour ago"
            } else if hours > 1 {
                labelDate.text = "\(hours) hours ago"
            } else {
                let min = date.minAgo
                if min > 5 {
                    labelDate.text = "\(min) minutes ago"
                } else {
                    labelDate.text = "Less than 5 minutes ago"
                }
            }
        }
    }
}

extension Date {
    var hoursAgo: Int {
        let seconds = self.timeIntervalSinceNow
        return Int(floor(seconds / 3600))
    }
    
    var minAgo: Int { // if less than an hour, return mins
        let seconds = self.timeIntervalSinceNow
        let hoursInSeconds = Double(hoursAgo) * 3600.0
        let secondsAgo = seconds - hoursInSeconds
        return Int(floor(secondsAgo / 60))
    }
}
