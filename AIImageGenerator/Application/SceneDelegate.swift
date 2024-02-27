//
//  SceneDelegate.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	// MARK: - Dependencies
	private var appCoordinator: AppCoordinator!

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)
		let navigateController = UINavigationController()

		appCoordinator = AppCoordinator(navigateController: navigateController)

		window.rootViewController = navigateController
		window.makeKeyAndVisible()

		appCoordinator.start()

		self.window = window

	}
}
