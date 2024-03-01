//
//  TimerManager.swift
//  AIImageGenerator
//
//  Created by Steven Kirke on 01.03.2024.
//

import Foundation

/// Протокол, таймера обратного отчета.
protocol IUpdateTimer {
	/// Передача оставшегося времени для визуализации.
	/// - Parameters:
	///   - returnTime: Время в строковом значении, в формате 00:00.
	///   - Note: Время по умолчанию, одна минута.
	func updateLabel(returnTime: String)
	/// Маркер что работа таймера закончена.
	func stopTimer()
}

final class TimerManager {

	// MARK: - Public properties

	var delegate: IUpdateTimer?

	// MARK: - Private properties
	/// Порог максимального количества секунд.
	private let maxTime: Int = 20
	private var timer: Timer?
	/// Активация таймера.
	private var isActiveTimer = false
	/// Количество секунд, для обратного отчета.
	private var count = 20 {
		willSet {
			delegate?.updateLabel(returnTime: handlerStringTimer())
		}
	}

	// MARK: - Initializator
	internal init(delegate: IUpdateTimer?) {
		self.delegate = delegate
	}

	// MARK: - Public methods
	@objc func startTimer() {
		if !isActiveTimer {
			createTimer()
			isActiveTimer = true
		}
		if count != 0 {
			self.count -= 1
		}

		if self.count == 0 {
			self.timer?.invalidate()
			isActiveTimer = false
			self.count = maxTime
			delegate?.stopTimer()
		}
	}

	// MARK: - Private methods
	private func createTimer() {
		timer = Timer.scheduledTimer(
			timeInterval: 1.0,
			target: self,
			selector: #selector(startTimer),
			userInfo: nil,
			repeats: true
		)
	}

	private func handlerStringTimer() -> String {
		let seconds: Int = count % 60
		let minutes: Int = (count / 60) % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
}

