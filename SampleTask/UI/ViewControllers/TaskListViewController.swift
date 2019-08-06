//
//  TaskListViewController.swift
//  SampleTask
//
//  Created by Rajeev Kumar on 05/08/19.
//  Copyright © 2019 anilpahadiya. All rights reserved.
//

import UIKit
import CoreData


class TaskListViewController: UIViewController {

    let appDelegateObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var dataArray = [NSManagedObject]()    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
    
        
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchDataInTableList()
    }
    @IBAction func createTaskButtonClick(_ sender: Any) {
    
        let taskdetailsvc = storyboard!.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        taskdetailsvc.editRecNo =  -1
         taskdetailsvc.title = "New Task"
        self.navigationController?.pushViewController(taskdetailsvc, animated:true)
    }
   
    func fetchDataInTableList() {
        let entityDescription = NSEntityDescription.entity(forEntityName: KTaskList, in: appDelegateObj.managedObjectContext)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDescription
        
        do {
            dataArray = try appDelegateObj.managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func showSimpleAlert(index : Int ,title : String , mess : String ) {
        let alert = UIAlertController(title: title, message: mess , preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
                                        //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: TableView Delegate
extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        let taskdetailsvc = storyboard!.instantiateViewController(withIdentifier: "TaskDetailsViewController") as! TaskDetailsViewController
        taskdetailsvc.editRecNo =  indexPath.row
        taskdetailsvc.dataArray = dataArray
        taskdetailsvc.title = "Task Details"
        self.navigationController?.pushViewController(taskdetailsvc, animated:true)

    }
  
}

// MARK: TableView DataSource
extension TaskListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasklist_cell", for: indexPath) as! TaskListTCell
        cell.lblTitle.text = dataArray[indexPath.row].value(forKey: kName) as? String
        cell.lblDes.text = dataArray[indexPath.row].value(forKey: kDes) as? String
        cell.lblDate.text = dataArray[indexPath.row].value(forKey: kDate) as? String

        return cell
    }
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Delete" , handler: { (action:UITableViewRowAction, indexPath:IndexPath) -> Void in
        })
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            appDelegateObj.managedObjectContext.delete(dataArray[indexPath.row])
            do {
                try appDelegateObj.managedObjectContext.save()
                dataArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
        }
    }

    
}
