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
    var allPosts: [String: Post] = [:]
    
    func load(completion: ((Bool)->Void)?) {
        guard let url = URL(string: "https://www.reddit.com/r/all/top.json?limit=2") else { return }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            //print("response \(response) error \(error)")
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    let postData = json?["data"] as? [String: Any]
                    guard let posts = postData?["children"] as? [[String: Any]] else { return }
                    print("parsed posts: \(posts)")
                    
                    for postDict in posts {
                        let post = Post(json: postDict)
                        if let id = post.id {
                            self?.allPosts[id] = post
                        }
                    }
                    completion?(true)
                } catch let err {
                    print("parse error: \(err)")
                    completion?(false)
                }
            } else {
                if nil != error {
                    print("request error: \(error)")
                }
                completion?(false)
            }
        }
        task.resume()
    }
}
