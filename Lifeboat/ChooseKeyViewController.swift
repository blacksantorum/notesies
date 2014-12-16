//
//  ChooseKeyViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/15/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit



class ChooseKeyViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var introLabelA: UILabel!
    @IBOutlet weak var introLabelB: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var chooseKeyTextField: UITextField!
    
    var key: String?
    var isResetting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseKeyTextField.delegate = self
        if isResetting {
            introLabelA.hidden = true
            introLabelB.hidden = true
        } else {
            introLabelA.hidden = false
            introLabelB.hidden = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if key == nil {
            key = self.chooseKeyTextField.text
            self.chooseKeyTextField.placeholder = "Confirm your key"
            self.chooseKeyTextField.text = ""
        } else {
            let delegate = UIApplication.sharedApplication().delegate as AppDelegate
            
            if textField.text == key {
                // NSUserDefaults.standardUserDefaults().setNilValueForKey(delegate.keyKey)
                NSUserDefaults.standardUserDefaults().setObject(key!, forKey: delegate.keyKey)
                NSUserDefaults.standardUserDefaults().synchronize()
                delegate.key = key!
                self.performSegueWithIdentifier("keyChosen", sender: self)
            } else {
                textField.text = ""
                textField.placeholder = "Choose a key"
                key = nil
                errorLabel.hidden = false
            }
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        errorLabel.hidden = true
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        chooseKeyTextField.becomeFirstResponder()
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
