//
//  ShowPictureIterator.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 27.02.2024.
//

import Foundation

protocol IShowPictureIterator: AnyObject {
	/// Запрос данных с сети или другого источника.
	func fetch()
}

final class ShowPictureIterator {
	// MARK: - Dependencies
	var presenter: IShowPicturePresenter?
	let model: SPResponse

	// MARK: - Initializator
	init(presenter: IShowPicturePresenter?, model: SPResponse) {
		self.presenter = presenter
		self.model = model
	}
}

extension ShowPictureIterator: IShowPictureIterator {
	func fetch() {
		switch model {
		case .success(let url):
			let convert = ShowPictureModel.Request.ImageURL(from: url.url)
			presenter?.present(present: .success(convert))
		}
	}
}
