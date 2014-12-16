//
//  DetailViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/14/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var entryContentTextView: UITextView!

    var detailItem: AnyObject? {
        didSet {
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let textView = self.entryContentTextView {
                textView.text = detail.valueForKey("content")!.description
                
                var formatter = NSDateFormatter()
                formatter.dateFormat = "M/d"
                
                let dateString = formatter.stringFromDate(detail.valueForKey("timeStamp")! as NSDate)
                
                let titleString = detail.valueForKey("title") as String
                
                self.title = dateString + " - " + titleString
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        if delegate.needsAuth {
            self.performSegueWithIdentifier("prompt", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

