//
//  ViewController.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

class SignInVC: UIViewController, UITextFieldDelegate{
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func signInButton(_ sender: Any) {
        
        let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let password = passwordTextField.text ?? ""
        
        guard !email.isEmpty, !password.isEmpty else {
            showAlert(title:"missing information", message:"Please enter your email and password.")
            return
        }
        
        let req: NSFetchRequest<Users> = Users.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "email ==[c] %@", email)
        
        do {
            if let user = try context.fetch(req).first {
                if user.password == password {
                    // Giriş başarılı
                    if let id = user.id?.uuidString {
                        UserDefaults.standard.set(id, forKey: "currentUserID")
                    }
                    
                    // Ana sayfaya geçiş (segue veya kod ile)
                    performSegue(withIdentifier: "toHome", sender: self)
                    
                } else {
                    showAlert(title:"Incorrect password", message:"password is wrong.")
                }
            } else {
                showAlert(title:"User not found", message:"There is no account registered with this email address..")
            }
        } catch {
            showAlert(title:"Error", message:error.localizedDescription)
        }
        
    }
    @IBAction func hidePassword(_ sender: Any) {
        let newState = !(passwordTextField.isSecureTextEntry)
        passwordTextField.isSecureTextEntry = newState
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
}

