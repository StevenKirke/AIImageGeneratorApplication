//
//  SavePhotoManager.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 28.02.2024.
//

import UIKit

// Обработчик данных полученных в результате сохранения изображения в галлерею.
protocol IReturnResultSavePhotoDelegate: AnyObject {
	func returnResultSaveImage(result: Result<Bool, Error>)
}

/// Протокол сохранения данных в галлерею.
protocol ISavePhotoManager: AnyObject {
	/// Сохранение изображения в фото-галлерею.
	func saveImage(image: UIImage)
}

final class SavePhotoManager: NSObject, ISavePhotoManager {

	// MARK: - Public properties
	var handlerSaveImage: IReturnResultSavePhotoDelegate?

	// MARK: - Initializator
	internal init(handlerSaveImage: IReturnResultSavePhotoDelegate?) {
		self.handlerSaveImage = handlerSaveImage
	}

	// MARK: - Public methods
	func saveImage(image: UIImage) {
		save(image: image)
	}
}

extension SavePhotoManager {
	private func save(image: UIImage) {
		UIImageWriteToSavedPhotosAlbum(
			image,
			self,
			#selector(saveCompleted),
			nil
		)
	}

	@objc func saveCompleted(
		_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer
	) {
		if let currentError = error {
			handlerSaveImage?.returnResultSaveImage(result: .failure(currentError))
		}
		handlerSaveImage?.returnResultSaveImage(result: .success(true))
	}
}
