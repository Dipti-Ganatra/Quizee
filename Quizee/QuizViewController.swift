//
//  QuizViewController.swift
//  Quizee
//
//  Created by Devang Nathwani on 14/06/17.
//  Copyright © 2017 DND. All rights reserved.
//

import UIKit


class QuizViewController: UIViewController {
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblQues: UILabel!
    @IBOutlet var btnOpt1: [UIButton]!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    var marrQuizData : NSMutableArray = NSMutableArray()
    var marrAns : NSMutableArray = NSMutableArray()
    
    var currIndex = 0
    var startTime = 0
    var score = 0
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnPrevious.alpha = 0.5
        getQuizData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackTapped(_ sender: AnyObject) {
        btnFinishTapped(sender)
    }

    func getQuizData() {
        let sharedInstance = ModelManager.getInstance()
        sharedInstance.database?.open()
    
        let resultSet: FMResultSet! = sharedInstance.database!.executeQuery("select * from \(UserDefaults.standard.value(forKey: "topic")!)", withArgumentsIn: [])
        if resultSet != nil {
            while resultSet.next() {
                let quizData : QuizData = QuizData()
                quizData.strId = resultSet.string(forColumn: "id")!
                quizData.ques = resultSet.string(forColumn: "ques")!
                quizData.ans = resultSet.string(forColumn: "ans")!
                
                quizData.A = resultSet.string(forColumn: "A")!
                quizData.B = resultSet.string(forColumn: "B")!
                quizData.C = resultSet.string(forColumn: "C")!
                quizData.D = resultSet.string(forColumn: "D")!
                
                marrQuizData.add(quizData)
            }
        }
        
        if marrQuizData.count > 0 {
            for _ in 0...marrQuizData.count - 1 {
                let rnd1 = arc4random_uniform(UInt32(marrQuizData.count))
                let rnd2 = arc4random_uniform(UInt32(marrQuizData.count))
                marrQuizData.exchangeObject(at: Int(rnd1), withObjectAt: Int(rnd2))
            }
            fillData()
            startTime = (marrQuizData.count * 60) / 2
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        } else {
            MTPopUp(frame: self.view.frame).show(complete: { (index) in
                self.navigationController!.popViewController(animated: true)
                }, view: self.view, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage: "Sorry. No questions found in this category!", btnArray: ["Ok"], strTitle: "Quizee")
        }
        
        sharedInstance.database!.close()
    }
    
    func fillData() {
        let quizData = marrQuizData.object(at: currIndex) as! QuizData
        lblQues.text = quizData.ques
        btnOpt1[0].setTitle(quizData.A, for: UIControlState.normal)
        btnOpt1[1].setTitle(quizData.B, for: UIControlState.normal)
        btnOpt1[2].setTitle(quizData.C, for: UIControlState.normal)
        btnOpt1[3].setTitle(quizData.D, for: UIControlState.normal)
        
        for btn in btnOpt1 {
            if currIndex < marrAns.count {
                if btn.titleLabel?.text ==  marrAns.object(at: currIndex) as? String {
                    print("checked")
                    btn.setImage(UIImage(named: "check.png"), for: UIControlState.normal)
                    btn.tag = 1
                    if btn.accessibilityLabel == btn.titleLabel?.text {
                        lblQues.tag = 1
                    } else {
                        lblQues.tag = 0
                    }
                } else {
                    print("uncheck")
                    btn.setImage(UIImage(named: "uncheck.png"), for: UIControlState.normal)
                    btn.tag = 0
                }
            } else {
                lblQues.tag = 0
                btn.setImage(UIImage(named: "uncheck.png"), for: UIControlState.normal)
                btn.tag = 0
            }
        }
        
        for btn in btnOpt1 {
            btn.accessibilityLabel = quizData.ans
        }
    }

//MARK: ---action methods
    
    @IBAction func btnOptTapped(_ sender: AnyObject) {
        let selectedButton = sender as! UIButton
        
        if selectedButton.tag == 0 {
            for btn in btnOpt1 {
                btn.setImage(UIImage(named: "uncheck.png"), for: UIControlState.normal)
                btn.tag = 0
            }
            
            selectedButton.setImage(UIImage(named: "check.png"), for: UIControlState.normal)
            selectedButton.tag = 1
            
            if currIndex < marrAns.count {
                marrAns.replaceObject(at: currIndex, with: selectedButton.titleLabel?.text)
            } else {
                marrAns.add(selectedButton.titleLabel?.text)
            }
            
            if selectedButton.accessibilityLabel == selectedButton.titleLabel?.text {
                score += 1
                lblQues.tag = 1
            } else {
                if lblQues.tag == 1 {
                    //lblQues.tag = 0
                    score -= 1
                }
            }
        }
    }
    
    @IBAction func btnPrevTapped(_ sender: AnyObject) {
        if currIndex > 0 {
            btnNext.alpha = 1
            btnNext.isUserInteractionEnabled = true
            currIndex -= 1
            fillData()
        } else {
            btnPrevious.alpha = 0.5
            btnPrevious.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func btnNextTapped(_ sender: AnyObject) {
        if currIndex < marrQuizData.count - 1 {
            btnPrevious.alpha = 1
            btnPrevious.isUserInteractionEnabled = true
            currIndex += 1
            fillData()
        } else {
            btnNext.alpha = 0.5
            btnNext.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func btnFinishTapped(_ sender: AnyObject) {
        self.timer?.invalidate()
        MTPopUp(frame: self.view.frame).show(complete: { (index) in
            if (index) == 1 {
                
                MTPopUp(frame: self.view.frame).show(complete: { (index) in
                    if (index) == 1 {
                        self.navigationController!.popViewController(animated: true)
                    } else {
                        let solutionViewController : SolutionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SolutionViewController") as! SolutionViewController
                        solutionViewController.marrQuizData = self.marrQuizData
                        self.navigationController?.pushViewController(solutionViewController, animated: true)
                    }
                    
                    }, view: self.view, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage: "Your score is \(self.score)/\(self.marrQuizData.count)", btnArray: ["Ok","Solution"], strTitle: "Quizee")
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            }
            }, view: self.view, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage: "Are you sure you want to finish the quiz?", btnArray: ["Yes","No"], strTitle: "Quizee")
    }
    
    func updateTime() {
        if(startTime > 0){
            let minutes = String(format: "%02d", startTime / 60)//startTime / 60
            let seconds = String(format: "%02d", startTime % 60)
            lblTimer.text = "\(minutes):\(seconds)"
            startTime -= 1
        } else {
            timer?.invalidate()
            MTPopUp(frame: self.view.frame).show(complete: { (index) in
                if (index) == 1 {
                    self.navigationController!.popViewController(animated: true)
                } else {
                    let solutionViewController : SolutionViewController = self.storyboard?.instantiateViewController(withIdentifier: "SolutionViewController") as! SolutionViewController
                    solutionViewController.marrQuizData = self.marrQuizData
                    self.navigationController?.pushViewController(solutionViewController, animated: true)
                }
                
                }, view: self.view, animationType: MTAnimation.ZoomIn_ZoomOut, strMessage: "Time Up! Your score is \(score)/\(self.marrQuizData.count)", btnArray: ["Ok","Solution"], strTitle: "Quizee")
        }
    }
    
    func okTapped() {
        if (self.navigationController != nil) {
            self.navigationController!.popViewController(animated: true)
        }
        else if (self.presentingViewController != nil) {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            // Unknown presentation
            print("nothing")
        }
    }
}
