//
//  SceneDelegate.swift
//  MyLocations
//
//  Created by Lagash Systems on 19/03/2020.
//  Copyright © 2020 Lagash Systems. All rights reserved.
//

import UIKit
import CoreData
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    lazy var persistentContainer:NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            storeDescription, error in
            if let error = error {
                fatalError("Could load data store: \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext =
        persistentContainer.viewContext
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        // Override point for customization after application launch.
        let tabController = window!.rootViewController as! UITabBarController
        
        if let tabViewControllers = tabController.viewControllers{
            // First Tab
            var navController = tabViewControllers[0] as! UINavigationController
            let controller1 = navController.viewControllers.first as! CurrentLocationViewController
            controller1.managedObjectContext = managedObjectContext
            
            //Second Tab
            navController = tabViewControllers[1] as! UINavigationController
            let controller2 = navController.viewControllers.first as! LocationViewController
            controller2.managedObjectContext = managedObjectContext
            let _ = controller2.view
            
            //Third Tab
            navController = tabViewControllers[2] as! UINavigationController
            let controller3 = navController.viewControllers.first as! MapViewController
            controller3.managedObjectContext = managedObjectContext
            let _ = controller3.view
        }
        
        print(applicationDocumentsDirectory)
        listenForFatalCoreDataNotifications()
        customizeAppearence()
        
    }
    
    func customizeAppearence() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().barTintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.foregroundColor:UIColor.white]
        let tintColor = UIColor(red: 255/255.0, green: 238/255.0, blue: 136/255.0, alpha: 1)
        UITabBar.appearance().tintColor = tintColor
    }
    
    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification, object: nil, queue: OperationQueue.main,
                                               using: { notification in
                                                
                                                let message = """
        There was a fatal error in app and it cannot continue.

        Press OK to terminate the app. Sorry for the inconvenient.
"""
                                                let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
                                                
                                                let action = UIAlertAction(title: "OK", style: .default) { _ in
                                                    
                                                    let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data Error", userInfo: nil)
                                                    exception.raise()
                                                }
                                                alert.addAction(action)
                                                let tabController = self.window!.rootViewController
                                                tabController?.present(alert, animated: true, completion: nil)
                                                
                                                
        })
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

