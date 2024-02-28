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
		case success(ImageData)

		struct ImageData {
			let data: Data
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

extension ShowPictureModel.Response.ImageData {
	init(from: MainSearchViewModel.Request.ImageData) {
		self.init(data: from.data)
	}
}

extension ShowPictureModel.Request.ImageData {
	init(from: ShowPictureModel.Response.ImageData) {
		self.init(data: from.data)
	}
}

extension ShowPictureModel.ViewModel.ImageData {
	init(from: ShowPictureModel.Request.ImageData) {
		self.init(data: from.data)
	}
}
