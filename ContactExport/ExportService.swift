//
//  Export.swift
//  ContactExport
//
//  Created by Ackermann-Eugen on 08.01.16.
//  Copyright © 2016 Modular Design GmbH. All rights reserved.
//

import Contacts
import UIKit

class ExportService: NSObject {
    
    let contactsProperty = ContacsProperty.sharedInstance
    
    
//    func exportContacts() {
//        
//        AppDelegate.getAppDelegate().requestForAccess { (accessGranted) -> Void in
//            if accessGranted {
//                self.createExcel()
//            }
//        }
//    }
    
    
    func exportContacts() {
        

        
        let keysToFetch = [CNContactGivenNameKey, CNContactMiddleNameKey,
                           CNContactFamilyNameKey,
                           CNContactJobTitleKey,
                           CNContactOrganizationNameKey,
                           CNContactPhoneNumbersKey,
                           
                           CNPostalAddressCityKey,
                           CNPostalAddressCountryKey,
                           CNPostalAddressISOCountryCodeKey,
                           CNPostalAddressPostalCodeKey,
                           CNPostalAddressStateKey,
                           CNPostalAddressStreetKey,

                           CNContactEmailAddressesKey,

                           CNContactPostalAddressesKey
            

                           ] as [Any]
        

        let containerId = CNContactStore().defaultContainerIdentifier()
        let predicate: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        let contacts = try! CNContactStore().unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
        
        
        let numberOfPeople =  contacts.count
        let columnCount     = "100"
        let rowCount        = String(numberOfPeople + 1)
        
        print("\(#function): numberOfPeople : \(numberOfPeople)")
        
        
        // XML Header
        var xml =
        "<?xml version=\"1.0\"?>" +
            "<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"" +
            " xmlns:o=\"urn:schemas-microsoft-com:office:office\"" +
            " xmlns:x=\"urn:schemas-microsoft-com:office:excel\"" +
            " xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"" +
            " xmlns:html=\"http://www.w3.org/TR/REC-html40\">" +
            
        "<Worksheet ss:Name=\"Sheet1\">"
        
        
        xml = xml + "<Table ss:ExpandedColumnCount=\"" + columnCount + "\""
        xml = xml + " ss:ExpandedRowCount=\"" + rowCount + "\""
        xml = xml + " x:FullColumns=\"1\" x:FullRows=\"1\""
        xml = xml + " ss:DefaultColumnWidth=\"90\" ss:DefaultRowHeight=\"15\">"
        
        xml = xml + "<Row>"
        if contactsProperty.boolGivenName {
            xml = xml + "<Cell><Data ss:Type=\"String\">Vorname</Data></Cell>"
        }
        if contactsProperty.boolMiddleName {
            xml = xml + "<Cell><Data ss:Type=\"String\">Zweiter Vorname</Data></Cell>"
        }
        if contactsProperty.boolFamilyName {
            xml = xml + "<Cell><Data ss:Type=\"String\">Nachname</Data></Cell>"
        }
        if contactsProperty.boolOrganizationName {
            xml = xml + "<Cell><Data ss:Type=\"String\">Firma</Data></Cell>"
        }
        xml = xml + "<Cell><Data ss:Type=\"String\">Position</Data></Cell>"
        
        xml = xml + "<Cell><Data ss:Type=\"String\">Straße</Data></Cell>"
        xml = xml + "<Cell><Data ss:Type=\"String\">PLZ</Data></Cell>"
        xml = xml + "<Cell><Data ss:Type=\"String\">Ort</Data></Cell>"
        
        xml = xml + "<Cell><Data ss:Type=\"String\">Straße 2</Data></Cell>"
        xml = xml + "<Cell><Data ss:Type=\"String\">PLZ 2</Data></Cell>"
        xml = xml + "<Cell><Data ss:Type=\"String\">Ort 2</Data></Cell>"
        
        xml = xml + "<Cell><Data ss:Type=\"String\">Adresse 1</Data></Cell>"
        xml = xml + "<Cell><Data ss:Type=\"String\">Adresse 2</Data></Cell>"
        xml = xml + "<Cell><Data ss:Type=\"String\">Telefonnummer</Data></Cell>"
        xml = xml + "</Row>"
        
        
        for contact in contacts {
            
            print("\(#function): contact.givenName : \(contact.givenName)")
            print("\(#function): contact.familyName : \(contact.familyName)")
            
            
            //let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName) ?? "No Name"
            
            var phoneNumbers = ""
            for number in contact.phoneNumbers {
                
                guard var phoneLabel = number.label else {
                    print("no number.label")
                    continue
                }
                let phoneNumber = number.value 
                
                //let customLabel = String (stringInterpolationSegment: ABAddressBookCopyLocalizedLabel(phoneLabel))
                
                phoneLabel = phoneLabel.replacingOccurrences(of:"_$!<", with: "")
                phoneLabel = phoneLabel.replacingOccurrences(of:">!$_", with: "")
                
                
                phoneNumbers = phoneNumbers + phoneLabel + ": " + phoneNumber.stringValue + " "
            }
            
            
            xml = xml + "<Row>"
            if contactsProperty.boolGivenName {
                xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.givenName + "</Data></Cell>"
            }
            if contactsProperty.boolMiddleName {
                xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.middleName + "</Data></Cell>"
            }
            if contactsProperty.boolFamilyName {
                xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.familyName + "</Data></Cell>"
            }
            xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.organizationName + "</Data></Cell>"
            xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.jobTitle + "</Data></Cell>" // Position
            
            
            // POSTALISCHE ADRESSE
            
            
            guard let firstAddress = contact.postalAddresses.first else {
                print("no postal address could be found")
                xml = xml + "</Row>"
                continue
            }
            
         
            
//            let formatter = CNPostalAddressFormatter()
//            let formattedAddress = formatter.string(from: firstAddress.value)
//            
//            print("The address is \(formattedAddress)")
            

            let a = contact.postalAddresses as [CNLabeledValue]
            
            print(contact.postalAddresses)
            
            var value = CNPostalAddress()
            
            var streetFirst = ""
            var postalCodeFirst = ""
            var cityFirst = ""
            
            

            for i in 0..<a.count {
            
                
                let address = contact.postalAddresses[i]
                
                if i == 2 {break} // Nur 2 Adressen
                
                value = address.value 
                
                xml = xml + "<Cell><Data ss:Type=\"String\">" + value.street + "</Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\">" + value.postalCode + "</Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\">" + value.city + "</Data></Cell>"
                
                if i == 0 {
                    streetFirst = value.street
                    postalCodeFirst = value.postalCode
                    cityFirst = value.city
                }
            }
            
            if a.count == 0 {
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
            }
            
            if a.count == 1 {
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
                
                // Adressetikett
                xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.givenName + " " + contact.familyName + " " + value.street + " " + value.postalCode + " " + value.city + "</Data></Cell>"
                
                xml = xml + "<Cell><Data ss:Type=\"String\"></Data></Cell>"
            }
            
            if a.count == 2 {
                xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.givenName + " " + contact.familyName + " " + streetFirst + " " + postalCodeFirst + " " + cityFirst + "</Data></Cell>"
                xml = xml + "<Cell><Data ss:Type=\"String\">" + contact.givenName + " " + contact.familyName + " " + value.street + " " + value.postalCode + " " + value.city + "</Data></Cell>"
            }
            
            xml = xml + "<Cell><Data ss:Type=\"String\">" + phoneNumbers + "</Data></Cell>"
            xml = xml + "</Row>"
        }
        
        
        
        
        
        xml = xml + "</Table>"
        
        xml = xml + "</Worksheet>" + "</Workbook>"
        
        
        writeToFile(xml: xml)
        
        
    }
    
    
    
    
    func writeToFile(xml: String) {
        
        // https://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file/24098149#24098149
        
        let file = fileNameContactsXls
        
        if let dir : NSString = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first as NSString? {
            let path = dir.appendingPathComponent(file);
            
            //writing
            do {
                try xml.write(toFile: path, atomically: false, encoding: String.Encoding.utf8)
                #if DEBUG
                    print("\(#function): Writing finished")
                #endif
                //UIAlertView(title: "Kontakte exportiert", message: "", delegate: self, cancelButtonTitle: "Ok").show()
            }
            catch {
                print("\(#function): Error")
                UIAlertView(title: "Fehler beim exportieren deiner Kontakte", message: "", delegate: self, cancelButtonTitle: "Ok").show()
            }
            
            //reading
            /*
            do {
            let text2 = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
            */
        }
    }

}


