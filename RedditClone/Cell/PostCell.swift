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
        labelDate.text = post.created?.debugDescription
        labelComments.text = "Comments: \(post.comments)"
        
        if let url = post.thumbnail {
            // TODO: load thumbnail
            constraintThumbnailWidth.constant = 68
        } else {
            constraintThumbnailWidth.constant = 0
        }
    }
}
