//
//  HomeVC.swift
//  To-Do-List
//
//  Created by Selma Çalı on 20.08.2025.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    @IBOutlet weak var todoTableView: UITableView!
    
    let context = appDelegate.persistentContainer.viewContext
    
    var todoList = [Tasks]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        todoTableView.dataSource = self
        todoTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchToDo()
        DispatchQueue.main.async { self.todoTableView.reloadData() }
    }


    func fetchToDo() {
        guard let idStr = UserDefaults.standard.string(forKey: "currentUserID"),
              let uuid = UUID(uuidString: idStr) else {
            todoList = []
            return
        }
        
        let req: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        req.predicate = NSPredicate(format: "owner.id == %@", uuid as CVarArg)
        req.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        do {
            todoList = try context.fetch(req)
        } catch {
            print("Fetch error:", error.localizedDescription)
            todoList = []
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToDetails" {
            let index = sender as! Int
            let task = todoList[index]
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.task = task
        }
    }
    
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as! TaskTableViewCell
        cell.titleLabel.text = todoList[indexPath.row].title
        cell.noteLabel.text = todoList[indexPath.row].notes
        cell.task = todoList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "homeToDetails", sender: indexPath.row)
    }
}
