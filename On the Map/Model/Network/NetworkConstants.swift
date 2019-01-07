//
//  NetworkConstants.swift
//  On the Map
//
//  Created by Saud Alhelali on 05/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import Foundation


struct NetworkConstants {
    
    struct HeaderKeys {
        static let ACCEPT = "Accept"
        static let CONTENT_TYPE = "Content-Type"
        static let UDACITY_APP_ID = "X-Parse-Application-Id"
        static let UDACITY_API_KEY = "X-Parse-REST-API-Key"
        
    }
    
    struct HeaderValues {
        static let UDACITY_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let UDACITY_API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct ParameterKeys {
        static let LIMIT = "limit"
        static let SKIP = "skip"
        static let ORDER = "order"
    }
    
    struct Urls {
        private static let MAIN = "https://parse.udacity.com"
        static let SESSION = "https://onthemap-api.udacity.com/v1/session"
        static let PUBLIC_USER = "https://onthemap-api.udacity.com/v1/users/"
        static let STUDENT_LOCATION = MAIN + "/parse/classes/StudentLocation"
    }
    
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}
