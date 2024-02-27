//
//  ICoordinator.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit

protocol ICoordinator: AnyObject {

	var childCoordinators: [ICoordinator] { get set }

	var navigateController: UINavigationController { get set }

	func start()

	func finish()
}

extension ICoordinator {
	func finish() {
		childCoordinators.removeAll()
	}
}
