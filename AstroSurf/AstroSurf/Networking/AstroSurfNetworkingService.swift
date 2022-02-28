//
//  AstroSurfNetworkingService.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//

import UIKit

public protocol AstroSurfNeetworkingProtocol {
    func callNetworkAPI(selectedDate: String, completion: @escaping (AstronomerPhotoVideoModel?, Error?) -> Void)
}

public class AstroSurfNetworkingService: AstroSurfNeetworkingProtocol {
    
    public init() {
        AstroSurfPhotoDetailViewModel.shared.networkingDelegate = self
    }
    
    
    /// Api call to get the photo/video details from the server
    /// - Parameters:
    ///   - selectedDate: published date of the the photo/video
    ///   - completion: to return the response back to the view model
    public func callNetworkAPI(selectedDate: String, completion: @escaping (AstronomerPhotoVideoModel?, Error?) -> Void) {
        let urlString = AppConfig.apodAPIUrl + "?api_key=" + AppConfig.apodAPIKey + "&" + AppConfig.dateParameter + "=" + selectedDate
        var urlRequest = URLRequest(url: URL(string: urlString)!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                if let photoModel = try? JSONDecoder().decode(AstronomerPhotoVideoModel.self, from: data) {
                    completion(photoModel, nil)
                } else if error == nil {
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                        let error = ErrorManager.getError(errorMesssage: "Parsing Error", statusCode: (response as? HTTPURLResponse)?.statusCode ?? 9999)
                        completion(nil, error)
                        return
                    }
                    if let dictionary = json as? [String: Any] {
                        var errorMessage = ""
                        if let errMsg = dictionary["msg"] as? String {
                            errorMessage = errMsg
                        } else {
                            if let errMsg = dictionary["msg"] as? String {
                                errorMessage = errMsg
                            }
                        }
                        let error = ErrorManager.getError(errorMesssage: errorMessage, statusCode: (response as? HTTPURLResponse)?.statusCode ?? 9999)
                        completion(nil, error)
                    } else {
                        let error = ErrorManager.getError(errorMesssage: "Parsing Error", statusCode: (response as? HTTPURLResponse)?.statusCode ?? 9999)
                        completion(nil, error)
                    }

                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                    completion(nil, error)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
