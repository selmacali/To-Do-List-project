//
//  TaskTableViewCell.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var view: UIView!
    
    var task: Tasks?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkToDo(_ sender: Any) {
        let newTask = !(task!.isDone)
        task!.isDone = newTask
        
        if task!.isDone {
            checkButton.tintColor = .green
            view.backgroundColor = UIColor(red: 247/255.0,green: 158/255.0,blue: 137/255.0,alpha: 1.0)
        } else {
            checkButton.tintColor = .white
            view.backgroundColor = UIColor(red: 230/255.0, green: 116/255.0, blue: 111/255.0, alpha: 1.0)
        }
        
        appDelegate.saveContext()
        
    }
}
