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

        //navigationItem.rightBarButtonItem = UIBarButtonItem(image: newMessageImage, style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkUserLoggedIn()
    }
    
    @objc func handleNewMessage() {
        let newMessageViewController = NewMessageViewController()
        present(UINavigationController(rootViewController: newMessageViewController), animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    
    func checkUserLoggedIn() {
        guard let uid = Auth.auth().currentUser?.uid else {
            perform(#selector(handleLogout), with: self, afterDelay: 0)
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String: AnyObject] {
                self.navigationItem.title = user["name"] as!String
            }
        }, withCancel: nil)
    }

}
