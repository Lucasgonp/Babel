import UIKit
import Contacts

struct PhoneContactModel {
    var fullName: String
    var phoneNumber = String()
    let image: UIImage?
    
    init(firstName: String, middleName: String?, lastName: String?, phoneNumbers: [CNLabeledValue<CNPhoneNumber>], imageData: Data?) {
        self.fullName = firstName
        self.image = imageData?.image
        
        if let middleName {
            self.fullName.append(" \(middleName)")
        }
        
        if let lastName {
            self.fullName.append(" \(lastName)")
        }
        
        for phoneNumber in phoneNumbers {
            let number = phoneNumber.value
            self.phoneNumber = number.stringValue
        }
        
        for phoneNumber in phoneNumbers {
            if let phoneLabel = phoneNumber.label, phoneLabel == CNLabelPhoneNumberMobile {
                let number = phoneNumber.value
                self.phoneNumber = number.stringValue
            }
        }
    }
}
