//
//  EmailService.swift
//
//  Created by Eugen Ackermann on 04.11.16.
//

import Foundation
import MessageUI

class EmailServie: NSObject, MFMailComposeViewControllerDelegate {
    
    var viewController: UIViewController?
    
    func sendPlainEmail(controller: UIViewController, subject: String, messageBody: String, recipients: Array<String>, attachmentFileName: String?, isHTML: Bool) {
        
        viewController = controller
        
        let toRecipients = recipients //["eugen.ackermann@modular-design.de"]
        
        let mcViewController = MFMailComposeViewController()
        mcViewController.mailComposeDelegate = self
        mcViewController.setSubject(subject)
        mcViewController.setMessageBody(messageBody, isHTML: isHTML)
        mcViewController.setToRecipients(toRecipients)
        
        if let attachmentFileName = attachmentFileName {
            
            let path = URL(string: "file://" + documentsDirectory() + "/" + attachmentFileName)
            
            do {
                let fileData = try Data(contentsOf: path!)
                mcViewController.addAttachmentData(fileData, mimeType: "application/xls", fileName: attachmentFileName)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        if MFMailComposeViewController.canSendMail() {
            controller.present(mcViewController, animated: true, completion: { () -> Void in
                print("\(#function): MFMailComposeViewController opened.")
            })
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result.rawValue {
            
        case MFMailComposeResult.saved.rawValue,
             MFMailComposeResult.sent.rawValue:
            
            print("Mail sent")
            
        case MFMailComposeResult.failed.rawValue:
            print("Mail sent failure: \(error!.localizedDescription)")
            
        case MFMailComposeResult.cancelled.rawValue:
            print("Mail cancelled")
            
        default:
            break
        }
        controller.dismiss(animated: false, completion: nil)
    }
    
    private func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        return documentsFolderPath
    }

}
