//
//  SignUpVC.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none

        [emailTextField, fullNameTextField, passwordTextField, password2TextField].forEach { $0?.delegate = self }
        
    }
    
    @IBAction func logInPage(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hidePassword(_ sender: Any) {
        let newState = !(passwordTextField.isSecureTextEntry)
        passwordTextField.isSecureTextEntry = newState
        password2TextField.isSecureTextEntry = newState
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let email = (emailTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let fullName = (fullNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let pass1 = passwordTextField.text ?? ""
        let pass2 = password2TextField.text ?? ""
        
        guard isValidEmail(email) else {
            showAlert(title:"Invalid email", message:"Please enter a valid email address.")
            return
        }
        guard pass1.count >= 6 else {
            showAlert(title:"Password too short", message:"Must be at least 6 characters.")
            return
        }
        guard pass1 == pass2 else {
            showAlert(title:"Passwords do not match", message:"The two passwords must be the same.")
            return
        }
        
        if emailExists(email) {
            showAlert(title:"Email in use", message:"An account with this email already exists.")
            return
        }
        
        do {
            let user = Users(context: context)
            user.id = UUID()
            user.email = email
            user.fullName = fullName.isEmpty ? nil : fullName
            user.password = pass1
            try context.save()

            if let id = user.id?.uuidString {
                UserDefaults.standard.set(id, forKey: "currentUserID")
            }

                // 6) Başarılı → ana sayfaya geç
            performSegue(withIdentifier: "signUpToHome", sender: nil)
        } catch {
            showAlert(title: "Registration failed", message:error.localizedDescription)
        }
        
        
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
    
    func emailExists(_ email: String) -> Bool {
        let req: NSFetchRequest<Users> = Users.fetchRequest()
        req.fetchLimit = 1
        req.predicate = NSPredicate(format: "email ==[c] %@", email)
        do {
            return try context.count(for: req) > 0
        } catch {
            return false
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    
}
