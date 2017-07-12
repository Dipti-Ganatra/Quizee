//
//  Util.swift
//  Quizee
//
//  Created by Devang Nathwani on 14/06/17.
//  Copyright © 2017 DND. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func showAlert(strTitle: NSString, strBody: NSString, delegate: AnyObject?)
    {
        var alert: UIAlertView = UIAlertView()
        alert.message = strBody as String
        alert.title = strTitle as String
        alert.delegate = delegate
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
}
