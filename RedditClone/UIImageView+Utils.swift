//
//  UIImageView+Utils.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/9/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//

import UIKit
extension UIImageView {
    func load(imageUrl: String?) {
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else { return }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            } catch let error {
                print("Could not load image because of error \(error)")
                self.image = nil
            }
        }

    }
}
