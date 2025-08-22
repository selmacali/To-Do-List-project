//
//  AddTodoVC.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

class AddTodoVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    
    let context = appDelegate.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addTodo(_ sender: Any) {
        let title = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let note  = (noteTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !title.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter Title.")
            return
        }
        
        guard let idStr = UserDefaults.standard.string(forKey: "currentUserID"),
              let uuid = UUID(uuidString: idStr) else {
            showAlert(title: "No session", message: "Please log in again.")
            return
        }
        
        let uReq: NSFetchRequest<Users> = Users.fetchRequest()
        uReq.fetchLimit = 1
        uReq.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        guard let currentUser = try? context.fetch(uReq).first else {
            showAlert(title: "User not found", message: "Please log in again.")
            return
        }
        
        let todo = Tasks(context: context)
        todo.id        = UUID()
        todo.title     = title
        todo.notes     = note.isEmpty ? nil : note
        todo.isDone    = false
        todo.createdAt = Date()
        todo.owner     = currentUser
        
        do {
            try context.save()
            dismiss(animated: true)
        } catch {
            showAlert(title: "Registration failed", message: error.localizedDescription)
        }
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
