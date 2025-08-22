//
//  DetailsVC.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

class DetailsVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notesLabel: UITextView!
    
    var task:Tasks?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let title = task?.title, let note = task?.notes{
            titleLabel.text = title
            notesLabel.text = note
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailsToEdit" {
            let taskEditVC = segue.destination as! EditVC
            taskEditVC.task = task
        }
        
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Delete TODO?", message: "Are you sure?", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { alertAction in
            self.deleteTodo()
        }))
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(sheet, animated: true)
        
    }
    
    func deleteTodo() {
        context.delete(task!)
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    @IBAction func goEdit(_ sender: Any) {
        performSegue(withIdentifier: "detailsToEdit", sender: nil)
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
