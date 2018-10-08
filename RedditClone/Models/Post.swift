//
//  Post.swift
//  RedditClone
//
//  Created by Bobby Ren on 10/7/18.
//  Copyright © 2018 RenderApps LLC. All rights reserved.
//

import UIKit

class Post: NSObject {
    fileprivate let dict: [String: Any]?
    fileprivate let kind: String?
    init(json: [String: Any]) {
        dict = json["data"] as? [String: Any]
        kind = json["kind"] as? String
    }
    
    var id: String? {
        return dict?["id"] as? String
    }
    
    var created: Date? {
        if let val = dict?["created"] as? TimeInterval {
            return Date(timeIntervalSince1970: val)
        }
        return nil
    }
    
    var title: String? {
        return dict?["title"] as? String
    }
    
    var author: String? {
        return dict?["author"] as? String
    }
    
    var thumbnail: String? {
        return dict?["thumbnail"] as? String
    }
    
    var comments: Int {
        return dict?["num_comments"] as? Int ?? 0
    }
    
    var url: String? {
        return dict?["url"] as? String
    }
}
