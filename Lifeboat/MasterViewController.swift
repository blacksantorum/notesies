//
//  MasterViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/14/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit
import CoreData
import MoPub

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, MPInterstitialAdControllerDelegate, MPAdViewDelegate
 {
    
    // TODO: Replace this test id with your personal ad unit id
    var interstitial: MPInterstitialAdController = MPInterstitialAdController(forAdUnitId:
        "66dd6a39d91c49af8d5b2a91bc0010f4")
    
    var hidden = true
    
    var managedObjectContext: NSManagedObjectContext? = nil

    @IBAction func unwindAfterCancelling(segue: UIStoryboardSegue) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.needsAuth = false
        hidden = false
        self.tableView.reloadData()
    }
    
    @IBAction func unlock(segue: UIStoryboardSegue) {
        // self.needsUnlock = false
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.needsAuth = false
        
        hidden = false
        self.tableView.reloadData()
    }
    
    @IBAction func unwindAfterAdding(segue: UIStoryboardSegue) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.needsAuth = false
        hidden = false
        self.tableView.reloadData()
        self.interstitial.loadAd()
    }
    
    @IBAction func unwindAfterChooseKey(segue: UIStoryboardSegue) {
        // self.needsUnlock = false
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.needsAuth = false
        
        hidden = false
        self.tableView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // hidden = true
        // tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // println("master did appear")
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        // println("Key in App delegate: \(delegate.key)")
        // println("Key length in App Delegate: \(delegate.key?.isEmpty)")
        
        if (delegate.key == nil || delegate.key!.isEmpty) {
            println("choose key")
            // self.tableView.hidden = true
            self.performSegueWithIdentifier("chooseKey", sender: self)
            // self.tableView.hidden = false
        }
        else if delegate.needsAuth {
            println("prompt")
            // self.tableView.hidden = true
            self.performSegueWithIdentifier("prompt", sender: self)
            // self.tableView.hidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interstitial.delegate = self
    }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }

    // Present the ad only after it has loaded and is ready
    func interstitialDidLoadAd(interstitial: MPInterstitialAdController) {
        if (interstitial.ready) {
            interstitial.showFromViewController(self)
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        delegate.needsAuth = false
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
            let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
            (segue.destinationViewController as DetailViewController).detailItem = object
            }
        }
        else if segue.identifier == "add" {
            (segue.destinationViewController as AddEntryViewController).fetchedResultsController = self.fetchedResultsController
            
        }
        else if segue.identifier == "resetKey" {
            // let delegate = UIApplication.sharedApplication().delegate as AppDelegate
            var destVc = (segue.destinationViewController as ChooseKeyViewController)
            destVc.isResetting = true
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return sectionInfo.numberOfObjects
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject)
                
            var error: NSError? = nil
            if !context.save(&error) {
                self.handleError(error!)
            }
        }
    }

    func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as NSManagedObject
        cell.textLabel!.text = object.valueForKey("title")!.description
        var formatter = NSDateFormatter()
        formatter.dateFormat = "M/d"
        cell.detailTextLabel!.text = formatter.stringFromDate(object.valueForKey("timeStamp")! as NSDate)
        
        if hidden {
            cell.textLabel?.hidden = true
            cell.detailTextLabel?.hidden = true
        } else {
            cell.textLabel?.hidden = false
            cell.detailTextLabel?.hidden = false
        }
        
    }
    
    func handleError(error: NSError)
    {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            var alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            UIAlertView(title: "Error", message: error.localizedDescription, delegate: self, cancelButtonTitle: "Dismiss").show()
        }
    }

    // MARK: - Fetched results controller

    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Entry", inManagedObjectContext: self.managedObjectContext!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timeStamp", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
    	var error: NSError? = nil
    	if !_fetchedResultsController!.performFetch(&error) {
    	     self.handleError(error!)
    	}
        
        return _fetchedResultsController!
    }    
    var _fetchedResultsController: NSFetchedResultsController? = nil

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, atIndexPath: indexPath!)
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            default:
                return
        }
    }

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         self.tableView.reloadData()
     }
     */

}

