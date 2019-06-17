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
    var messageViewController: MessageViewController?

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
                user.id = snapshot.key
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name

        cell.detailTextLabel?.text = user.email
        cell.profileImageView.loadImageFromUrlString(urlString: user.profileImageUrl)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        dismiss(animated: true) { [unowned self] in
            self.messageViewController?.showChatPageFor(user)
        }
    }
}

class UserCell: UITableViewCell {
    var message: Message? {
        didSet {
            setupNameAndProfileImage()
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timeStamp?.doubleValue {
                let timeStampDate = Date(timeIntervalSince1970: seconds)
                 let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timeStampDate)
                
            }
        }
    }
    
    private func setupNameAndProfileImage() {

        if let toId = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(toId)
            ref.observe(.value) { snapshot in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.textLabel?.text = dictionary["name"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImageFromUrlString(urlString: profileImageUrl)
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 86, y: textLabel?.frame.origin.y ?? 0 - 2, width: textLabel?.frame.size.width ?? 0, height: textLabel?.frame.size.height ?? 0)
        detailTextLabel?.frame = CGRect(x: 86, y: detailTextLabel?.frame.origin.y ?? 0 + 2, width: detailTextLabel?.frame.size.width ?? 0, height: detailTextLabel?.frame.size.height ?? 0)
    }
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00:00"
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        timeLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
