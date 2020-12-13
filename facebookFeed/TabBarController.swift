//
//  TabBarControllerViewController.swift
//  facebookFeed
//
//  Created by LeeChan on 8/30/16.
//  Copyright © 2016 MarkiiimarK. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestsController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestsController)
        secondNavigationController.title = "Request"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerViewController = UIViewController()
        messengerViewController.navigationItem.title = "SOME TITLE"
        let messengerNavigationController = UINavigationController(rootViewController: UIViewController())
        messengerNavigationController.title = "Messenger"
        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsNavigationController = UINavigationController(rootViewController: UIViewController())
        notificationsNavigationController.title = "Noticfication"
        notificationsNavigationController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreNavigationController = UINavigationController(rootViewController: UIViewController())
        moreNavigationController.title = "More"
        moreNavigationController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavigationController, moreNavigationController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        
//        tabBar.clipsToBounds = true
        
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
