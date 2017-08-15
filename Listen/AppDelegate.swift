//
//  AppDelegate.swift
//  Listen
//
//  Created by Jim Stevenson on 1/26/16.
//  Copyright © 2016 TStevenson Apps. All rights reserved.
//

import UIKit
import GameKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RevMobAdsDelegate {

    var window: UIWindow?
    var banner: RevMobBanner?
    
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        Chartboost.start(withAppId: "57632bb604b0167efaff400b", appSignature: "67ee80ad845ca46319c637a6375d48d55e7618d8", delegate: nil)
        
        Chartboost.setShouldRequestInterstitialsInFirstSession(true)
        
        let completionBlock: () -> Void = {
            
            self.showBanner()
            
        }
        
        let errorBlock: (NSError!) -> Void = {error in
            // check the error
            print(error)
        }
        RevMobAds.startSession(withAppID: "5765c5ca3f171c4f0b6dcc09",
                                        withSuccessHandler: completionBlock, andFailHandler: errorBlock as! (Error?) -> Void)
       
        
        return true
    }
    
    func showBanner(){
        banner = RevMobAds.session().banner()
        let bannerLoadedHandler: (RevMobBanner!) -> Void = {revmobBanner in
            self.banner!.showAd()
        }
        let bannerFailureHandler: (RevMobBanner?, NSError?) -> Void = {revmobBanner, error in
            NSLog("[RevMob Sample App] Banner failed to load with error: \(error!.localizedDescription)")
            //Banner failed to load
        }
        let bannerOnClickHandler: (RevMobBanner!) -> Void = {revmobBanner in
            NSLog("[RevMob Sample App] Banner clicked")
        }
        banner!.load(successHandler: bannerLoadedHandler, andLoadFailHandler: bannerFailureHandler as! RevMobBannerFailureHandler, onClickHandler: bannerOnClickHandler)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        Chartboost.showInterstitial(CBLocationHomeScreen)
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

