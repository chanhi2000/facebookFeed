//
//  SceneDelegate.swift
//  facebookFeed
//
//  Created by LeeChan on 12/13/20.
//  Copyright © 2020 MarkiiimarK. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private var tabBarController: UITabBarController {
        let feedVC = FeedController()
        let feedNC = UINavigationController(rootViewController: feedVC)
        feedNC.title = "News Feed"
        feedNC.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestVC = FriendRequestsController()
        let friendRequestNC = UINavigationController(rootViewController: friendRequestVC)
        friendRequestNC.title = "Request"
        friendRequestNC.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerVC = UIViewController()
        messengerVC.navigationItem.title = "Messenger"
        messengerVC.view.backgroundColor = .systemBackground
        let messengerNC = UINavigationController(rootViewController: messengerVC)
        messengerNC.title = "Messenger"
        messengerNC.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsVC = UIViewController()
        notificationsVC.navigationItem.title = "Notification"
        notificationsVC.view.backgroundColor = .systemBackground
        let notificationsNC = UINavigationController(rootViewController: notificationsVC)
        notificationsNC.title = "Noticfication"
        notificationsNC.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreVC = UIViewController()
        moreVC.navigationItem.title = "More"
        moreVC.view.backgroundColor = .systemBackground
        let moreNC = UINavigationController(rootViewController: moreVC)
        moreNC.title = "More"
        moreNC.tabBarItem.image = UIImage(named: "more_icon")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            feedNC,
            friendRequestNC,
            messengerNC,
            notificationsNC,
            moreNC
        ]
        tabBarController.tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        
        return tabBarController
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let sceneWindow = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: sceneWindow)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITabBar.appearance().tintColor = UIColor.rgb(red: 70, green: 146, blue: 250)
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}
