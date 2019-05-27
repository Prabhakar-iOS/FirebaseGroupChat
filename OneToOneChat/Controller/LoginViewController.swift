//
//  LoginViewController.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 02/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    var inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()
    
    var loginRegisterSegmentationControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.addTarget(self, action: #selector(handleSegmentAction), for: .valueChanged)
        return sc
    }()
    
    var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "name"
        return textField
    }()
    
    var nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 221, g: 221, b: 221)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "email"
        return textField
    }()
    
    var emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 221, g: 221, b: 221)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var headerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageUpload)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    var messageViewController: MessageViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61.0, g: 91.0, b: 151.0)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(headerImageView)
        view.addSubview(loginRegisterSegmentationControl)
        
        setupContainerView()
        setupRegisterButton()
        setupHeaderImageView()
        setupSegmentationControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var inputContainerHeightConstraint: NSLayoutConstraint?
    
    func setupContainerView() {
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerHeightConstraint = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerHeightConstraint?.isActive = true
        
        view.addSubview(nameTextField)
        view.addSubview(nameSeparatorView)
        view.addSubview(emailTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passwordTextField)
        
        setupNameTextField()
        setupEmailTextFiled()
        setupPasswordTextField()
    }
    
    func setupRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    var heightNameTextFieldConstraint: NSLayoutConstraint?
    var heightEmailTextFieldConstraint: NSLayoutConstraint?
    var heightPasswordTextFieldConstraint: NSLayoutConstraint?
    
    func setupNameTextField() {
        nameTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        
        heightNameTextFieldConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        heightNameTextFieldConstraint?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(lessThanOrEqualToConstant: 1).isActive = true
    }
    
    func setupEmailTextFiled() {
        emailTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.topAnchor).isActive = true
        heightEmailTextFieldConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        heightEmailTextFieldConstraint?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(lessThanOrEqualToConstant: 1).isActive = true
    }
    
    func setupPasswordTextField() {
        passwordTextField.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.topAnchor).isActive = true
        heightPasswordTextFieldConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        heightPasswordTextFieldConstraint?.isActive = true
    }
    
    func setupHeaderImageView() {
        headerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentationControl.topAnchor, constant: -12).isActive = true
        headerImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        headerImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupSegmentationControl() {
        loginRegisterSegmentationControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentationControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -10).isActive = true
        loginRegisterSegmentationControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentationControl.heightAnchor.constraint(equalToConstant: 36)
    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentationControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error)
                return
            }
            self.messageViewController?.fetchUserAndSetupNavBar()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            let uploadData = self.headerImageView.image!.jpegData(compressionQuality: 0.1)
            let storageRef = Storage.storage().reference().child("\(uid).png")
            storageRef.putData(uploadData!, metadata: nil) { (metaData, error) in
                storageRef.downloadURL(completion: { (url, error) in
                    if let urlText = url?.absoluteString {
                        let values = ["name": name, "email": email, "profileImageUrl": urlText]
                        self.registerUserWith(uid: uid, values: values)
                    }
                })
                

            }
            
        }
    }
    
    private func registerUserWith(uid: String, values: [String: String]) {
        let ref = Database.database().reference()
        let updateRef = ref.child("users").child(uid)
        
        updateRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil {
                return
            }
            let user = User()
            user.setValuesForKeys(values)
            self.messageViewController?.setupNavBar(user: user)
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    @objc func handleSegmentAction() {
        let title = loginRegisterSegmentationControl.titleForSegment(at: loginRegisterSegmentationControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        inputContainerHeightConstraint?.constant = loginRegisterSegmentationControl.selectedSegmentIndex == 0 ? 100 : 150
        heightNameTextFieldConstraint?.isActive = false
        heightNameTextFieldConstraint = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentationControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        heightNameTextFieldConstraint?.isActive = true
        
        heightEmailTextFieldConstraint?.isActive = false
        heightEmailTextFieldConstraint = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentationControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        heightEmailTextFieldConstraint?.isActive = true
        
        heightPasswordTextFieldConstraint?.isActive = false
        heightPasswordTextFieldConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: loginRegisterSegmentationControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        heightPasswordTextFieldConstraint?.isActive = true
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleImageUpload() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = image
        }
        headerImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
}
