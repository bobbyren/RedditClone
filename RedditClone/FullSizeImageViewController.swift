//
//  FullSizeImageViewController.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/9/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//

import UIKit

class FullSizeImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var imageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        load()
    }
    
    fileprivate func load() {
        imageView.load(imageUrl: imageUrl)
    }
}
