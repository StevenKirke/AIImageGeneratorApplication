//
//  ShowPictureIterator.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import UIKit

protocol IShowPictureIterator: AnyObject {
	/// Запрос данных с сети или другого источника.
	func fetch()
	/// Сохранение изображения.
	func saveImage(image: UIImage)
	/// Назад на предыдущее View.
	func backToView()
}

final class ShowPictureIterator {

	// MARK: - Dependencies
	var presenter: IShowPicturePresenter?
	var savePhotoManager: ISavePhotoManager?
	let model: SPResponse

	// MARK: - Initializator
	init(
		presenter: IShowPicturePresenter?,
		savePhotoManager: ISavePhotoManager?,
		model: SPResponse
	) {
		self.presenter = presenter
		self.savePhotoManager = savePhotoManager
		self.model = model
	}
}

extension ShowPictureIterator: IShowPictureIterator {
	func fetch() {
		switch model {
		case .success(let data):
			let modelRequest = ShowPictureModel.Request.ImageData(from: data)
			presenter?.present(present: .success(modelRequest))
		}
	}

	func saveImage(image: UIImage) {
		savePhotoManager?.saveImage(image: image)
	}

	func backToView() {
		presenter?.backToView()
	}
}
