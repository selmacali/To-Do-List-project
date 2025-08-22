//
//  SettingsVC.swift
//  To-Do-List
//
//  Created by Selma Çalı on 21.08.2025.
//

import UIKit
import CoreData

class SettingsVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
    }
    
    func fetchUser() {
        guard let idString = UserDefaults.standard.string(forKey: "currentUserID"), let userUUID = UUID(uuidString: idString) else {
            showAlert(title: "Kullanıcı bulunamadı", message: "Lütfen tekrar giriş yapın.")
            return
        }
        
        let request: NSFetchRequest<Users> = Users.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", userUUID as CVarArg)
        
        do {
            if let currentUser = try context.fetch(request).first {
                nameLabel.text = currentUser.fullName
                mailLabel.text = currentUser.email
            } else {
                showAlert(title: "Kullanıcı bulunamadı", message: "Lütfen tekrar giriş yapın.")
            }
        } catch {
            showAlert(title: "Hata", message: "Kullanıcı bilgisi alınamadı: \(error.localizedDescription)")
        }
    }

    @IBAction func cangePassword(_ sender: Any) {
        
    }
    
    @IBAction func logOutButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "currentUserID")

        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInVC")
            let navigationController = UINavigationController(rootViewController: signInVC)
            sceneDelegate.window?.rootViewController = navigationController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
