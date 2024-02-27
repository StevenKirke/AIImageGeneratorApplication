//
//  Extension+UITextField.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 26.02.2024.
//

import UIKit

extension UITextField {
	/// Левый отступ
	/// - Parameters:
	///   - amount: Значение отступа
	func setLeftPadding(_ amount: CGFloat) {
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
		self.leftView = padding
		self.leftViewMode = .always
	}

	/// Правый отступ
	/// - Parameters:
	///   - amount: Значение отступа
	func setRightPadding(_ amount: CGFloat) {
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
		self.rightView = padding
		self.rightViewMode = .always
	}
}
