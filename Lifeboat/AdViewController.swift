//
//  AdViewController.swift
//  Lifeboat
//
//  Created by Chris Tibbs on 12/15/14.
//  Copyright (c) 2014 blacksantorum. All rights reserved.
//

import UIKit
import MoPub

class AdViewController: UIViewController, MPInterstitialAdControllerDelegate
 {
    // TODO: Replace this test id with your personal ad unit id
    var interstitial: MPInterstitialAdController = MPInterstitialAdController(forAdUnitId: "77ce0b65cf81438eb255695afe3b1904")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.interstitial.delegate = self
        self.interstitial.loadAd()
        
        // Do any additional setup after loading the view.
    }
    
    // Present the ad only after it has loaded and is ready
    func interstitialDidLoadAd(interstitial: MPInterstitialAdController) {
        if (interstitial.ready) {
            interstitial.showFromViewController(self)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
