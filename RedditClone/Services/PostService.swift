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
    let session = URLSession(configuration: .default)
    func load() {
        guard let url = URL(string: "https://www.reddit.com/r/all/top.json?limit=2") else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            //print("response \(response) error \(error)")
            if nil != error {
                print("error")
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    let postData = json?["data"] as? [String: Any]
                    let posts = postData?["children"] as? [[String: Any]]
                    print("parsed posts: \(posts)")
                } catch let err {
                    print("parse error: \(err)")
                }
            }
        }
        task.resume()
    }
}
