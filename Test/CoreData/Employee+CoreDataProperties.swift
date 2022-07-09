//
//  Employee+CoreDataProperties.swift
//  Test
//
//  Created by Kavya on 09/07/22.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var email: String?
    @NSManaged public var profile_image: String?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var phone: String?
    @NSManaged public var website: String?
    @NSManaged public var companyname: String?
    @NSManaged public var catchPhrase: String?
    @NSManaged public var bs: String?

}

extension Employee : Identifiable {

}
