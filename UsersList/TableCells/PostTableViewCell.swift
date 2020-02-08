//
//  PostTableViewCell.swift
//  UsersList
//
//  Created by user164501 on 2/8/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var body: UILabel!
    var post: Post?
    
    func configure() {
        if let post = post {
            title.text = post.title
            body.text = post.body
        }
    }
}
