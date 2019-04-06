//
//  ChatLogController.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 17/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UIViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            self.navigationItem.title = user?.name ?? ""
        }
    }
    
    lazy var inputTextField: UITextField  = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.delegate = self
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupMessageInputContainer()
    }
    
    func setupMessageInputContainer() {
        let containerView = UIView()
        self.view.addSubview(containerView)
        ///containerView.backgroundColor = .red
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton()
        containerView.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitleColor(.blue, for: .normal)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorView = UIView()
        containerView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor(displayP3Red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
        separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
    }
    
    @objc func handleSend() {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user?.id
        let fromId = Auth.auth().currentUser?.uid
        let timeStamp: Int = Int(Date().timeIntervalSince1970)
        let value = ["text": inputTextField.text!, "toId": toId!, "fromId": fromId!, "timeStamp": timeStamp] as [String : Any]
        
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error)
                return
            }
            
            let secondRef = Database.database().reference().child("user-messages")
            let secondChildRef = secondRef.child(fromId!)
            let messageId = ref.key
            let messageValue = [messageId: 1]
            
            secondChildRef.updateChildValues(messageValue)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
