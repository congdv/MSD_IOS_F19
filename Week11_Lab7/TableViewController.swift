//
//  TableViewController.swift
//  Week11_Lab7
//
//  Created by Student on 2019-11-15.
//  Copyright © 2019 Student. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var items = [String]()
    let userDefault = UserDefaults.standard

    
    @IBAction func addNewItem(_ sender: Any) {
        let alertController = UIAlertController(title: "New item", message: "", preferredStyle: .alert)
        var itemTextField = UITextField()
        alertController.addTextField() {
            (textField) in
            textField.placeholder = "Add new Item"
            itemTextField = textField
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            (action) in
            if(itemTextField.text! != "") {
                self.items.append(itemTextField.text!)
                self.userDefault.set(self.items, forKey: "items")
                self.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            (action) in
            print(self.items)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true, completion: nil)
        
        
          
    }
    override func viewDidLoad() {
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 38/255.0, green: 185/255.0, blue: 153/255.0, alpha: 1.0)
        super.viewDidLoad()
        if(self.userDefault.array(forKey: "items") != nil) {
            self.items = self.userDefault.array(forKey: "items") as! [String]
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = items[indexPath.row]
        default:
            cell.textLabel?.text = items[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") {
            (action, indexPath) in
            self.items.remove(at: indexPath.row)
            self.userDefault.set(self.items, forKey: "items")
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [deleteAction]
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
