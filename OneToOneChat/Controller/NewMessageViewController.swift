//
//  NewMessageViewController.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 03/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewMessageViewController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let snapshots = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(snapshots)
                self.users.append(user)
               
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
}

class UserCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
