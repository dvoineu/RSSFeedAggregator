//
//  NetworkError.swift
//  RSSAggregator
//
//  Created by dvoineu on 2.12.24.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidData
    case parsingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Указан некорректный URL. Пожалуйста, проверьте введенный URL и попробуйте снова."
        case .invalidResponse:
            return "Сервер вернул некорректный ответ. Попробуйте снова позже."
        case .invalidData:
            return "Не удалось загрузить данные. Проверьте подключение к интернету или попробуйте другой URL."
        case .parsingError:
            return "Произошла ошибка при обработке данных. Попробуйте использовать другой URL."
        }
    }
}
