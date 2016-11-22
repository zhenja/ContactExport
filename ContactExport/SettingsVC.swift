//
//  SettingsVC.swift
//  ContactExport
//
//  Created by Ackermann-Eugen on 11.01.16.
//  Copyright © 2016 Modular Design GmbH. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let contactsProperty = ContacsProperty.sharedInstance
    
    let sectionName         = 0
    let sectionOrganisation = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(_ sender: Any) {
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "sidViewController"))! as UIViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        present(vc, animated: true, completion: nil)
    }

    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == sectionName {
            return 3
        }
        else if section == sectionOrganisation {
            return 1
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Wähle die Felder aus, die exportiert werden sollen:"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath as IndexPath)
        
        if indexPath.section == sectionName {
            if indexPath.row == 0 {
                cell.textLabel!.text = "Vorname"
                getAccessoryTypeForCell(cell: cell, contactsPropertyBool: contactsProperty.boolGivenName)
            }
            else if indexPath.row == 1 {
                cell.textLabel!.text = "Zweiter Vorname"
                getAccessoryTypeForCell(cell: cell, contactsPropertyBool: contactsProperty.boolMiddleName)
            }
            else if indexPath.row == 2 {
                cell.textLabel!.text = "Nachname"
                getAccessoryTypeForCell(cell: cell, contactsPropertyBool: contactsProperty.boolFamilyName)
            }
        }
        
        if indexPath.section == sectionOrganisation {
            if indexPath.row == 0 {
                cell.textLabel!.text = "Firma"
                getAccessoryTypeForCell(cell: cell, contactsPropertyBool: contactsProperty.boolOrganizationName)
            }
            if indexPath.row == 1 {
                cell.textLabel!.text = "Abteilung"
                getAccessoryTypeForCell(cell: cell, contactsPropertyBool: contactsProperty.boolDepartmentName)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        
        if indexPath.section == sectionName {
            if indexPath.row == 0 {
                setAccessoryTypeForContact(cell: cell!, contactsPropertyBool: contactsProperty.boolGivenName)
            }
            else if indexPath.row == 1 {
                setAccessoryTypeForContact(cell: cell!, contactsPropertyBool: contactsProperty.boolMiddleName)
            }
            else if indexPath.row == 2 {
                setAccessoryTypeForContact(cell: cell!, contactsPropertyBool: contactsProperty.boolFamilyName)
            }
        }
        if indexPath.section == sectionOrganisation {
            if indexPath.row == 0 {
                setAccessoryTypeForContact(cell: cell!, contactsPropertyBool: contactsProperty.boolOrganizationName)
            }
        }
        
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
    }
    
    
    // MARK: Custom
    func getAccessoryTypeForCell(cell: UITableViewCell, contactsPropertyBool: Bool) {
        
        if contactsPropertyBool {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
    func setAccessoryTypeForContact(cell: UITableViewCell, contactsPropertyBool: Bool) {
        
        if cell.accessoryType == UITableViewCellAccessoryType.checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.none
            
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        
    }
    
    

    
}


