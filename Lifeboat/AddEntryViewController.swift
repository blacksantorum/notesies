//
//  AddEntryViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/14/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit
import CoreData

class AddEntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var addEntryButton: UIBarButtonItem!
    
    @IBOutlet weak var fakeTextField: UITextField!
    
    
    @IBAction func fakeTextFieldTapped(sender: AnyObject) {
        fakeTextField.hidden = true
        contentTextView.hidden = false
        contentTextView.becomeFirstResponder()
    }
    
    @IBAction func addEntry(sender: AnyObject) {
        self.insertNewObject(self.addEntryButton)
    }
    
    var fetchedResultsController : NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleTextField.delegate = self
        self.contentTextView.delegate = self
        self.contentTextView.contentInset = UIEdgeInsetsMake(0, -5, 0, 0)
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        contentTextView.hidden = false
        fakeTextField.hidden = true
        contentTextView.becomeFirstResponder()
        return true
    }
    
    @IBAction func titleTextFieldEditingDidChange(sender: AnyObject) {
        self.addEntryButton.enabled = !self.titleTextField.text.isEmpty && !self.contentTextView.text.isEmpty
    }
    
    func textViewDidChange(textView: UITextView) {
        self.addEntryButton.enabled = !self.titleTextField.text.isEmpty && !self.contentTextView.text.isEmpty
        
        if self.contentTextView.text.isEmpty {
            contentTextView.hidden = true
            fakeTextField.hidden = false
            fakeTextField.resignFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(sender: AnyObject) {
        let context = self.fetchedResultsController!.managedObjectContext
        let entity = self.fetchedResultsController!.fetchRequest.entity!
        let newManagedObject = NSEntityDescription.insertNewObjectForEntityForName(entity.name!, inManagedObjectContext: context) as NSManagedObject
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        newManagedObject.setValue(NSDate(), forKey: "timeStamp")
        newManagedObject.setValue(titleTextField.text, forKey: "title")
        newManagedObject.setValue(contentTextView.text, forKey: "content")
        
        // Save the context.
        var error: NSError? = nil
        if !context.save(&error) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //println("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        self.performSegueWithIdentifier("added", sender: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let kbFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        self.textViewBottomConstraint.constant += kbFrame!.height
        self.contentTextView.setNeedsUpdateConstraints()
        self.contentTextView.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let kbFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        self.textViewBottomConstraint.constant -= kbFrame!.height
        self.contentTextView.setNeedsUpdateConstraints()
        self.contentTextView.layoutIfNeeded()
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
