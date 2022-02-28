//
//  ErrorManager.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//

import Foundation


public class ErrorManager: NSObject {
    
    /// To get the Error based on error message and status code.
    /// - Parameters:
    ///   - errorMesssage: error message coming in the api response
    ///   - statusCode: sstatus code coming in the api response
    /// - Returns: Error
    public class func getError(errorMesssage: String, statusCode: Int) -> Error {
        let error = ErrorHandler.init(description: errorMesssage, code: statusCode)
        return error
    }
}

protocol ErrorProtocol: Error {
    var title: String { get }
    var code: Int { get }
}

struct ErrorHandler: ErrorProtocol {
    var title: String
    var code: Int
    var errorDescription: String

    init(description: String, code: Int) {
        self.title = "Error"
        self.errorDescription = description
        self.code = code
    }
}
