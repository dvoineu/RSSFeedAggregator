//
//  Networking.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 1.12.24.
//

import Foundation

// MARK: - Network Layer

protocol Networking {
    func getNewsData(sourceURL: String, completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {

    ///Получение тестовых данных
    ///
    /// - Parameters:
    ///     - completion: Блок кода который выполнится на главном потоке
    func getNewsData(sourceURL: String, completion: @escaping (Data?, Error?) -> Void) {

        let url = URL(string: sourceURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"

        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    ///Формирует необходимую задачу для запроса данных из сети
    ///
    /// - Parameters:
    ///     - request: Сформированный запрос в сеть
    ///     - completion: Блок кода который выполнится на главном потоке
    /// - Returns:
    ///     Возвращает сконфигурированную задачу для получения данных из сети
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
