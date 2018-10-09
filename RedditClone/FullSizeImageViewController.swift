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
    var imageUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        load()
    }
    
    fileprivate func load() {
        guard let url = imageUrl else { return }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } catch let error {
                print("Could not load image because of error \(error)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
