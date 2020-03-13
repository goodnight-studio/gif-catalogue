//
//  SceneDelegate.swift
//  GIF Catalogue
//
//  Created by Geof Crowl on 1/22/20.
//  Copyright © 2020 Geof Crowl. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        #if targetEnvironment(macCatalyst)
        if let titlebar = windowScene.titlebar {
            
//            let toolbar = NSToolbar(identifier: "toolbar")
//            
//            toolbar.delegate = self
//            toolbar.allowsUserCustomization = false
//            toolbar.centeredItemIdentifier = NSToolbarItem.Identifier("searchBar")
//            
//            titlebar.toolbar = toolbar
            
            titlebar.titleVisibility = .hidden
        }
        #endif
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = RootViewController()
        window?.makeKeyAndVisible()
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

#if targetEnvironment(macCatalyst)
extension SceneDelegate: NSToolbarDelegate {
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if itemIdentifier == NSToolbarItem.Identifier("refreshItem") {
            
            let refreshBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(SceneDelegate.refresh))
            let refreshItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "refreshItem"), barButtonItem: refreshBarItem)
            
            return refreshItem
        }
        
        if itemIdentifier == NSToolbarItem.Identifier("titleText") {
            //            let textBarItem = UIBarItem
            let titleItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "titleText"))
            titleItem.title = "GIF Catalogue"
            
            return titleItem
        }
        
        if itemIdentifier == NSToolbarItem.Identifier("searchBar") {

            let searchBar = UISearchBar()
            searchBar.placeholder = "Popular GIFs"
            //            searchBar.frame.size.width = 200
            let searchBarItem = UIBarButtonItem(customView: searchBar)
            let barItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier("searchBar"),  barButtonItem: searchBarItem)
            return barItem
        }
        
        if itemIdentifier == NSToolbarItem.Identifier("spacer") {
            
            let spacerItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier.space)
            
            return spacerItem
        }
        
        if itemIdentifier == NSToolbarItem.Identifier("search") {
            
            let searchBarItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SceneDelegate.search))
            let searchItem = NSToolbarItem(itemIdentifier: NSToolbarItem.Identifier(rawValue: "search"), barButtonItem: searchBarItem)
            
            return searchItem
        }
        
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
//            NSToolbarItem.Identifier.space,
            NSToolbarItem.Identifier.space,
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier(rawValue: "titleText"),
            NSToolbarItem.Identifier.flexibleSpace,
            NSToolbarItem.Identifier(rawValue: "search"),
//            NSToolbarItem.Identifier(rawValue: "refreshItem"),
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
    
    @objc func refresh() {
//        NotificationCenter.default.post(name: .dataShouldRefresh, object: [])
    }
    
    @objc func search() {
        print("search")
        NotificationCenter.default.post(name: NSNotification.Name("com.geofcrowl.gif-catalogue.toggleSearch"), object: [])
    }
}
#endif

