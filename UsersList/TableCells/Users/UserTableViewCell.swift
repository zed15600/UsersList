//
//  UserTableViewCell.swift
//  UsersList
//
//  Created by user164501 on 2/7/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import UIKit

protocol UserCellDelegate {
    func showDetails(for user: User?)
}

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var mail: UILabel!
    var delegate: UserCellDelegate!
    var user: User?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure() {
        if let user = user {
            name.text = user.name
            phone.text = user.phone
            mail.text = user.email
        }
    }
    
    @IBAction func details() {
        delegate.showDetails(for: user)
    }
}
