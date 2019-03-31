//
//  RegisterVC.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 02/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MessageViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        let menuBtn = UIButton(type: .custom)
        menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        menuBtn.setImage(UIImage(named:"newMessageIcon"), for: .normal)
        menuBtn.tintColor = .blue
        menuBtn.addTarget(self, action: #selector(handleNewMessage), for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: menuBtn)
        let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
        currWidth?.isActive = true
        let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
        currHeight?.isActive = true
        self.navigationItem.rightBarButtonItem = menuBarItem
        observeMessages()
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { snapshot in
            if let value = snapshot.value as? [String: AnyObject] {
                let message = Message()
                message.setValuesForKeys(value)
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message.toId
        cell.detailTextLabel?.text = message.text
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkUserLoggedIn()
    }
    
    @objc func handleNewMessage() {
        let newMessageViewController = NewMessageViewController()
        newMessageViewController.messageViewController = self
        present(UINavigationController(rootViewController: newMessageViewController), animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        let loginViewController = LoginViewController()
        loginViewController.messageViewController = self
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
    func checkUserLoggedIn() {
        guard let _ = Auth.auth().currentUser?.uid else {
            perform(#selector(handleLogout), with: self, afterDelay: 0)
            return
        }
        
        fetchUserAndSetupNavBar()
    }
    
    func fetchUserAndSetupNavBar() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDict = snapshot.value as? [String: Any] {
                let user = User()
                user.setValuesForKeys(userDict)
                self.setupNavBar(user: user)
            }
        }, withCancel: nil)

    }
    
    func setupNavBar(user: User) {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageFromUrlString(urlString: profileImageUrl)
        }
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let titleLabel = UILabel()
        containerView.addSubview(titleLabel)
        titleLabel.text = user.name
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: titleView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        self.navigationItem.titleView = titleView
        
        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatPageFor)))
        
    }
    
    @objc func showChatPageFor(_ user: User) {
        let chatViewController = ChatLogController()
        chatViewController.user = user
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}
