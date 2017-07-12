//
//  HomeViewController.swift
//  Quizee
//
//  Created by Devang Nathwani on 09/06/17.
//  Copyright © 2017 DND. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var btnTopics: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
//        for btn in btnTopics {
//            btn.applyGradient(colours: [UIColor(red: 37.0/255.0, green: 188.0/255.0, blue: 126.0/255.0, alpha: 1), UIColor.cyan])
//            btn.alpha = 0
//        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.btnTopics[0].alpha = 1;
        }) { (true) in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                self.btnTopics[1].alpha = 1;
            }) { (true) in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                    self.btnTopics[2].alpha = 1;
                }) { (true) in
                    UIView.animate(withDuration: 0.24, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        self.btnTopics[3].alpha = 1;
                    }) { (true) in
                        
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        UserDefaults.standard.set(segue.identifier, forKey: "topic")
    }
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
