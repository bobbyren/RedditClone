//
//  PostsViewController.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/7/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {

    fileprivate enum PostsStatus {
        case loading
        case done
    }
    
    var posts: [Post] = []
    fileprivate let pageSize = 50
    
    fileprivate var status: PostsStatus = .loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44

        let service = PostService.shared
        loadNextPage()
    }
    
    fileprivate func reloadTableData() {
        // TODO: sort in some form
        posts = PostService.shared.allPosts
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < posts.count + 1 else { return UITableViewCell() }
        if indexPath.row == posts.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextPageCell", for: indexPath)
            configureLoadingCell(cell: cell)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
            let post: Post = posts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
    }
    
    // MARK: - Tablesource Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < posts.count + 1 else { return }
        if indexPath.row == posts.count {
            loadNextPage()
        } else {
            let post: Post = posts[indexPath.row]
            if let urlString = post.url, post.thumbnail != nil, post.thumbnail != "default" {
                performSegue(withIdentifier: "toFullSizeImage", sender: urlString)
            }
        }
    }
    
    fileprivate func configureLoadingCell(cell: UITableViewCell) {
        if let label = cell.viewWithTag(1) as? UILabel {
            if status == .loading {
                label.text = "Loading..."
            } else {
                let start = posts.count + 1
                let end = start + pageSize - 1
                label.text = "Load posts \(start) to \(end)"
            }
        }
    }
    fileprivate func loadNextPage() {
        status = .loading
        let indexPath = IndexPath(row: posts.count, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let service = PostService.shared
        service.load(pageSize: pageSize) { [weak self] (success) in
            self?.status = .done
            DispatchQueue.main.async {
                if success {
                    self?.reloadTableData()
                } else {
                    print("Error received while loading posts")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "toFullSizeImage", let controller = segue.destination as? FullSizeImageViewController, let urlString = sender as? String else { return }
        controller.imageUrl = urlString
    }
}
