//
//  SolutionViewController.swift
//  Quizee
//
//  Created by Devang Nathwani on 06/07/17.
//  Copyright © 2017 DND. All rights reserved.
//

import UIKit

class SolutionViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    var marrQuizData : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("solution")
        print(marrQuizData)
        var html =
            /*HEADING*/"<head><center><br><h1><b>** <u>Solution</b></u> **</h1></br></center></head>" +
                /*DIVIDER*/"<center>- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -</center>" +
                /*BODY*/"<p><font size=3>"
        for i in 0 ..< marrQuizData.count {
            let quizData = marrQuizData.object(at: i) as! QuizData
            html += "<br><b>Ques: \(quizData.ques)</b></br><br>Ans: \(quizData.ans)</br>"
        }
        webView.loadHTMLString(html, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnBackTapped(_ sender: AnyObject) {
        self.navigationController!.popToRootViewController(animated: true)
    }
}
