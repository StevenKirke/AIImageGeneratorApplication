//
//  GenerateImageModel.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import Foundation

// Псевдонимы цикла GenerateImage.
/// Псевдоним запроса.
typealias MSResponse = MainSearchViewModel.Response
/// Псевдоним ответа для полученных данных с сети или другого источника.
typealias MSRequest = MainSearchViewModel.Request
/// Псевдоним данных для отображения.
typealias MSViewModel = MainSearchViewModel.ViewModel

// swiftlint:disable nesting
/// Модель для цикла GenerateImage.
enum MainSearchViewModel {
	/// Запрашиваемая сущность.
	enum Response {
		case success(ImageData)

		struct ImageData {
			let prompt: String
			let size: CGSize
		}
	}
	/// Сущность ответа.
	enum Request {
		case success(ImageData)
		case failure(Error)

		struct ImageData {
			let data: Data
		}
	}
	/// Сущность для отображения.
	enum ViewModel {
		case success(ImageData)
		case failure(String)

		struct ImageData {
			let data: Data
		}
	}
}
// swiftlint:enable nesting

extension MainSearchViewModel.Request.ImageData {
	init(from: Data) {
		self.init(data: from)
	}
}

extension MainSearchViewModel.ViewModel.ImageData {
	init(from: MainSearchViewModel.Request.ImageData) {
		self.init(data: from.data)
	}
}
