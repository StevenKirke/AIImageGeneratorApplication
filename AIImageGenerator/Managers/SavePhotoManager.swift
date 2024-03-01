//
//  SavePhotoManager.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 28.02.2024.
//

import UIKit

/// Протокол сохранения данных в галлерею.
protocol ISavePhotoManager: AnyObject {
	/// Сохранение изображения в фото-галлерею.
	func saveImage(image: UIImage, completion: ((Error?) -> Void)?)
}

final class SavePhotoManager: NSObject, ISavePhotoManager {

	// MARK: - Public properties
	var completion: ((Error?) -> Void)? = nil

	// MARK: - Public methods
	func saveImage(image: UIImage, completion: ((Error?) -> Void)?) {
		self.completion = completion
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
		completion?(error)
		completion = nil
	}
}
