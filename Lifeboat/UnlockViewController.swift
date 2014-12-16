//
//  UnlockViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/15/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit

class UnlockViewController: UIViewController , UITextFieldDelegate {
    
    let password = "nodagpie"
    
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
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let newString = textField.text + string
        
        if (newString == password) {
            self.performSegueWithIdentifier("unlock", sender: self)
        }
        
        return true
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
