//
//  PostService.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/7/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//
// paging: https://www.reddit.com/r/redditdev/comments/9jj52w/rallnew_now_stops_at_1000_posts/

import UIKit

class PostService: NSObject {
    static let shared = PostService()
    
    let session = URLSession(configuration: .default)
    var allPosts: [Post] = []
    var after: String?
    
    func load(pageSize: Int, completion: ((Bool)->Void)?) {
        var urlString = "https://www.reddit.com/r/all/top.json?limit=\(pageSize)"
        if let after = after {
            urlString = "\(urlString)&after=\(after)"
        }
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            //print("response \(response) error \(error)")
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    let postData = json?["data"] as? [String: Any]
                    guard let posts = postData?["children"] as? [[String: Any]] else { return }
                    print("parsed posts: \(posts)")
                    
                    // if this is a fresh request, clear old posts
                    if let val = postData?["after"] as? String{
                        self?.after = val
                    } else {
                        self?.allPosts.removeAll()
                    }
                    
                    for postDict in posts {
                        let post = Post(json: postDict)
                        self?.allPosts.append(post)
                    }
                    completion?(true)
                } catch let err {
                    print("parse error: \(err)")
                    completion?(false)
                }
            } else {
                if nil != error {
                    print("request error: \(String(describing: error))")
                }
                completion?(false)
            }
        }
        task.resume()
    }
}
