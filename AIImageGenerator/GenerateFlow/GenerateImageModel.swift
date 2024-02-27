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
		case success(Image)
		case failure(Error)

		struct Image {
			let url: URL
		}
	}
	/// Сущность для отображения.
	enum ViewModel {
		case success(ImageURL)
		case failure(String)

		struct ImageURL {
			let url: URL
		}
	}
}
// swiftlint:enable nesting

extension MainSearchViewModel.Request.Image {
	init(from: URL) {
		self.init(url: from)
	}
}

extension MainSearchViewModel.ViewModel.ImageURL {
	init(from: MainSearchViewModel.Request.Image) {
		self.init(url: from.url)
	}
}
