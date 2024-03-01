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
	var presenter: IShowPicturePresenter
	var savePhotoManager: ISavePhotoManager
	let model: Data

	// MARK: - Initializator
	init(
		presenter: IShowPicturePresenter,
		savePhotoManager: ISavePhotoManager,
		model: Data
	) {
		self.presenter = presenter
		self.savePhotoManager = savePhotoManager
		self.model = model
	}
}

extension ShowPictureIterator: IShowPictureIterator {
	func fetch() {
		presenter.present(present: .needShowImage(model))
	}

	func saveImage(image: UIImage) {
		savePhotoManager.saveImage(image: image) { error in
			if let error = error {
				self.presenter.present(present: .failureSaveImage(error))
			} else {
				self.presenter.present(present: .successSaveImage)
			}
		}
	}

	func backToView() {
		presenter.backToView()
	}
}
