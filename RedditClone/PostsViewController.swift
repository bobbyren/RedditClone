//
//  PostsViewController.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/7/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {

    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44

        let service = PostService.shared
        service.load { [weak self] (success) in
            DispatchQueue.main.async {
                if success {
                    self?.reloadTableData()
                } else {
                    print("Error received while loading posts")
                }
            }
        }
    }
    
    fileprivate func reloadTableData() {
        // TODO: sort in some form
        posts = Array(PostService.shared.allPosts.values)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < posts.count else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        let post: Post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    // MARK: - Tablesource Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < posts.count else { return }
        let post: Post = posts[indexPath.row]
        if let urlString = post.url {
            performSegue(withIdentifier: "toFullSizeImage", sender: urlString)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toFullSizeImage", let controller = segue.destination as? FullSizeImageViewController, let urlString = sender as? String else { return }
        controller.imageUrl = urlString
    }
}
