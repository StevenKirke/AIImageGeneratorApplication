//
//  ShowPictureModel.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

// Псевдонимы цикла ShowPicture.
/// Псевдоним запроса.
typealias SPResponse = ShowPictureModel.Response
/// Псевдоним ответа для полученных данных с сети или другого источника.
typealias SPRequest = ShowPictureModel.Request
/// Псевдоним данных для отображения.
typealias SPViewModel = ShowPictureModel.ViewModel

// swiftlint:disable nesting
/// Модель для цикла ShowPicture.
enum ShowPictureModel {
	/// Запрашиваемая сущность.
	enum Response {
		case success(ImageURL)

		struct ImageURL {
			let url: URL
		}
	}

	/// Сущность ответа.
	enum Request {
		case success(ImageURL)
		case failure(Error)

		struct ImageURL {
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

extension ShowPictureModel.Request.ImageURL {
	init(from: URL) {
		self.init(url: from)
	}
}

extension ShowPictureModel.ViewModel.ImageURL {
	init(from: ShowPictureModel.Request.ImageURL) {
		self.init(url: from.url)
	}
}
