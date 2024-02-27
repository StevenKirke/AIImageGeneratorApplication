//
//  AppCoordinator.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit

protocol IAppCoordinator: ICoordinator {
	func showPictureGenerateFlow()
}

final class AppCoordinator: IAppCoordinator {

	var childCoordinators: [ICoordinator] = []

	var navigateController: UINavigationController

	internal init(navigateController: UINavigationController) {
		self.navigateController = navigateController
	}

	func start() {
		showPictureGenerateFlow()
	}

	func showPictureGenerateFlow() {
		let coordinator = GenerateImageCoordinator(navigateController: navigateController)
		childCoordinators.append(coordinator)
		coordinator.start()
	}
}
