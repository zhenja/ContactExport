//
//  ViewController.swift
//  ContactExport
//
//  Created by Eugen Ackermann on 17.11.16.
//  Copyright © 2016 modular design GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let exportService = ExportService()
    let emailService = EmailServie()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func exportPressed(_ sender: Any) {
        
//        let alertController = UIAlertController(title: "Kontakte exportiert", message: "", preferredStyle: .alert)
//        
//        let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
//            print("You've pressed OK button");
//        }
//        
//        alertController.addAction(OKAction)
//        self.present(alertController, animated: true, completion:nil)
        
        
        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
            
            if accessGranted {
                self.exportService.exportContacts()
                
                self.emailService.sendPlainEmail(controller: self, subject: "Meine Kontakte", messageBody: "", recipients: [], attachmentFileName: fileNameContactsXls, isHTML: false)
            }
        }
        
        
      
        
    
        
    }

    @IBAction func settingsPressed(_ sender: Any) {
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "sidSettingsVC"))! as UIViewController
        vc.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        present(vc, animated: true, completion: nil)
        
    }

}

