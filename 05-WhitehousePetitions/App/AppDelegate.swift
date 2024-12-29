//
//  AppDelegate.swift
//  05-WhitehousePetitions
//
//  Created by Igor Cotrim on 27/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = window?.rootViewController as? UITabBarController {
            print("TabBarController encontrado")
            let navigationController = storyboard.instantiateViewController(withIdentifier: "PetitionsNavController")
            print("NavigationController carregado: \(navigationController)")
            navigationController.tabBarItem = UITabBarItem(
                tabBarSystemItem: .topRated,
                tag: 1
            )
            tabBarController.viewControllers?.append(navigationController)
        } else {
            print(
                "TabBarController não encontrado: \(window?.rootViewController)"
            )
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

