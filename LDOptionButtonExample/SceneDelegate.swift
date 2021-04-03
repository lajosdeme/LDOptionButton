//
//  SceneDelegate.swift
//  LDOptionButtonExample
//
//  Created by Lajos Deme on 2021. 04. 03..
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
    }
}

