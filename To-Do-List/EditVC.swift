//
//  EditVC.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

class EditVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextView!
    
    var task:Tasks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = task.title
        noteTextField.text  = task.notes ?? ""
        
    }
    
    @IBAction func editButton(_ sender: Any) {
        let newTitle = (titleTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let newNotes = (noteTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !newTitle.isEmpty else {
            showAlert(title: "Missing Information", message: "Please enter title.")
            return
        }
        
        task.title = newTitle
        task.notes = newNotes
        
        do {
            try context.save()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            showAlert(title: "Update Error", message: error.localizedDescription)
        }
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButtun = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButtun)
        present(alert, animated: true)
    }
    
}
