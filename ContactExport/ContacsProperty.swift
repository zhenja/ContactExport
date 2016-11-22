//
//  ContacsProperties.swift
//  ContactExport
//
//  Created by Ackermann-Eugen on 20.10.15.
//  Copyright © 2015 Modular Design GmbH. All rights reserved.
//

import UIKit

class ContacsProperty: NSObject {

    static let sharedInstance = ContacsProperty()
    private override init() {} //This prevents others from using the default '()' initializer for this class.
    
    var boolId          : Bool = false
    var boolNamePrefix  : Bool = false
    var boolGivenName   : Bool = true   // Vorname
    var boolMiddleName  : Bool = false  // Zweiter Vorname
    var boolFamilyName  : Bool = true   // Nachname
    var boolNameSuffix  : Bool = false  // Namenszusatz
    var boolNickname    : Bool = false  // Spitzname
    
    var boolOrganizationName    : Bool = true  // Firma
    var boolDepartmentName      : Bool = false  // Abteilung
    var boolJobTitle            : Bool = false  // Position
    
    var boolNote                : Bool = false  // Notizen
    
    var boolPhoneNumbers        : Bool = false  // Telefonnummern
    var boolEmailAddresses      : Bool = false  // E-Mail-Adressen
    var boolPostalAddresses     : Bool = false  // Adressen
    var boolUrlAddresses        : Bool = false  // URL-Adressen
    
    var boolGeburtstag          : Bool = false  // Geburtstag
}









































