//
//  UnlockViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/15/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit

class UnlockViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var unlockTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.unlockTextField.delegate = self
        self.unlockTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func keyTextFieldEditingChanged(sender: AnyObject) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if (unlockTextField.text == delegate.key!) {
            self.performSegueWithIdentifier("unlock", sender: self)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
