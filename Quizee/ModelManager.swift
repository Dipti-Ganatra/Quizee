//
//  ModalManager.swift
//  Quizee
//
//  Created by Devang Nathwani on 09/06/17.
//  Copyright © 2017 DND. All rights reserved.
//

import UIKit
//import FMDatabase

class ModelManager: NSObject {
    static var sharedInstance : ModelManager? = nil
    var database: FMDatabase?
    
    class func getInstance() -> ModelManager {
            if (sharedInstance == nil) {
                sharedInstance = ModelManager()
                sharedInstance?.database = FMDatabase(path:self.getPath(fileName: "Quizee.sqlite"))
            }
        return sharedInstance!
    }
    
    class func getPath(fileName: String) -> String {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        return fileURL.path
    }
    
    class func copyFile(fileName: NSString) {
        let dbPath: String = getPath(fileName: fileName as String)
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbPath) {
            let documentsURL = Bundle.main.resourceURL
            let fromPath = documentsURL?.appendingPathComponent(fileName as String)
            var error : NSError?
            do {
                try fileManager.copyItem(atPath: fromPath!.path, toPath: dbPath)
            } catch let error1 as NSError {
                error = error1
            }
            print("copied...")
            //            let alert: UIAlertView = UIAlertView()
            //            if (error != nil) {
            //                alert.title = "Error Occured"
            //                alert.message = error?.localizedDescription
            //            } else {
            //                alert.title = "Successfully Copy"
            //                alert.message = "Your database copy successfully"
            //            }
            //            alert.delegate = nil
            //            alert.addButtonWithTitle("Ok")
            //            alert.show()
        }
    }
}
