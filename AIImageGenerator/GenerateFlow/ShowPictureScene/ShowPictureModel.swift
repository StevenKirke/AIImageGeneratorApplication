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
/// Псевдоним данных для отображения.
typealias SPViewModel = ShowPictureModel.ViewModel

// swiftlint:disable nesting
/// Модель для цикла ShowPicture.
enum ShowPictureModel {

	/// Сущность ответа.
	enum Response {
		case needShowImage(Data)
		case successSaveImage
		case failureSaveImage(Error)
	}
	/// Сущность для отображения.
	struct ViewModel {
		let imageData: Data
	}
}
// swiftlint:enable nesting
