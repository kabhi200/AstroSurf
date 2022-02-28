//
//  AppConfig.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//

import UIKit

struct AppConfig {
    static let apodAPIUrl = "https://api.nasa.gov/planetary/apod"
    static let apodAPIKey = "ZHmXlalZ7azIcwtKO6eRf1LhuwhnryFuKX5HBYDr"
    static let httpHeaderFieldContentType = "Content-Type"
    static let httpHeaderJsonValue = "application/json"
    static let getMethod = "GET"
    static let dateParameter = "date"
}

public extension Notification.Name {
    static let dataSavedLocally = Notification.Name("DataSavedInDataBase")
    static let errorInSavingData = Notification.Name("ErrorInSavingData")

}
