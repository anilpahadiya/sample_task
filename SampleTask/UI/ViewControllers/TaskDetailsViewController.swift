//
//  TaskDetailsViewController.swift
//  SampleTask
//
//  Created by Rajeev Kumar on 05/08/19.
//  Copyright © 2019 anilpahadiya. All rights reserved.
//

import UIKit
import CoreData

class TaskDetailsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtDes: UITextField!
    @IBOutlet weak var lblTaskName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtDate: UITextField!
    
    
    let datePicker = UIDatePicker()
    
    
    let appDelegateObj : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var editRecNo = Int()
    var dataArray = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDatePicker()

        if editRecNo != -1 {
            print(editRecNo)
            txtTaskName.text = self.dataArray[editRecNo].value(forKey: kName) as? String
            txtDes.text = self.dataArray[editRecNo].value(forKey: kDes) as? String
            txtDate.text = self.dataArray[editRecNo].value(forKey: kDate) as? String
        }
        
        let backBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(showNotificationScreen))
        self.navigationItem.leftBarButtonItem = backBarButtonItem
    }
    func showSimpleAlert(title : String , mess : String ) {
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

    @IBAction func submitBtnClick(_ sender: Any) {
        
        
        if txtTaskName.text == "" && txtDate.text == "" && txtDes.text == ""
        {
            showSimpleAlert(title: "Empty Field", mess: "Please fill all required field")
        }else if txtTaskName.text == ""
        {
            showSimpleAlert(title: "Alert", mess: "Please enter task name")

        }else if txtDes.text  == ""
        {
            showSimpleAlert(title: "Alert", mess: "Please enter task description")

        }else if txtDate.text  == ""
        {
            showSimpleAlert(title: "Alert", mess: "Please select task date")

        }else{
            

        if editRecNo != -1 {
            self.dataArray[editRecNo].setValue(txtTaskName.text!, forKey: kName)
            self.dataArray[editRecNo].setValue(txtDes.text!, forKey: kDes)
            self.dataArray[editRecNo].setValue(txtDate.text!, forKey: kDate)
            
            do {
                try self.dataArray[editRecNo].managedObjectContext?.save()
            } catch {
                print("Error occured during updating entity")
            }
        } else {
            
            let entityDescription = NSEntityDescription.entity(forEntityName: KTaskList, in: appDelegateObj.managedObjectContext)
            let newPerson = NSManagedObject(entity: entityDescription!, insertInto: appDelegateObj.managedObjectContext)
            newPerson.setValue(txtTaskName.text!, forKey: kName)
            newPerson.setValue(txtDes.text!, forKey: kDes)
            newPerson.setValue(txtDate.text!, forKey: kDate)
            
            do {
                try newPerson.managedObjectContext?.save()
            } catch {
                print("Error occured during save entity")
            }
        }
        
            self.navigationController?.popViewController(animated: true)
        }
//        self.dismiss(animated: true, completion: nil)
    }
    @objc  func showNotificationScreen()  {
        self.navigationController?.popViewController(animated: true)
    }
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        txtDate.delegate = self
        
        addToolBar(textField: txtDate)
        txtDate.inputView = datePicker
    }
    func addToolBar(textField: UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    @objc func donePressed(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        txtDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelPressed(){
        view.endEditing(true) // or do something
    }

    
}

