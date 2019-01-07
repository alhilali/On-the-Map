//
//  Network.swift
//  On the Map
//
//  Created by Saud Alhelali on 05/01/2019.
//  Copyright © 2019 Saud. All rights reserved.
//

import Foundation

class Network {
    
    private static var userProfile = UserProfile()
    private static var sessionId: String?
    
    // MARK: Session related APIs
    
    static func postSession(email: String, password: String, completion: @escaping (String?)->Void) {
        guard let url = URL(string: NetworkConstants.Urls.SESSION) else {
            completion("URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: NetworkConstants.HeaderKeys.ACCEPT)
        request.addValue("application/json", forHTTPHeaderField: NetworkConstants.HeaderKeys.CONTENT_TYPE)
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 { // Success response
                    
                    let newData = data?.subdata(in: 5..<data!.count)
                    if let json = try? JSONSerialization.jsonObject(with: newData!, options: []),
                        let dict = json as? [String:Any],
                        let sessionDict = dict["session"] as? [String: Any],
                        let accountDict = dict["account"] as? [String: Any]  {
                        
                        self.userProfile.key = accountDict["key"] as? String // User for getting profile
                        self.sessionId = sessionDict["id"] as? String // Used for loging out
                        
                        self.getUserInfo(completion: { err in
                        })
                    } else {
                        errString = "Couldn't parse response"
                    }
                } else { // Http Call returned error status
                    errString = "Username/Password is incorrect"
                }
            } else { // Request wasn't sent
                errString = "No internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    static func getUserInfo(completion: @escaping (Error?)->Void) {
        guard let url = URL(string: "\(NetworkConstants.Urls.PUBLIC_USER)\(self.userProfile.key!)") else { // Invalid URL
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { //Response is ok
                    
                    if error != nil {
                        print(error!.localizedDescription)
                    }
                    
                    guard let data = data else { return }
                    
                    let range = (5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    do {
                        self.userProfile = try JSONDecoder().decode(UserProfile.self, from: newData)
                        print(userProfile)
                    } catch let jsonError {
                        print(jsonError) // couldn't pares jsob object
                    }
                } else {
                    completion(error)
                }
            }
            
        }
        task.resume()
    }
    
    static func deleteSession(completion: @escaping (String?)->Void) {
        guard let url = URL(string: NetworkConstants.Urls.SESSION) else {
            completion("URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.delete.rawValue
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 { // Success response
                    let range = (5..<data!.count)
                    if let data = data {
                        let newData = data.subdata(in: range)
                        print(String(data: newData, encoding: .utf8)!)
                    } else {
                        errString = "Failed reading response"
                    }
                } else { // Error in given login credintials
                    errString = "Request failed"
                }
            } else { // Request failed to sent
                errString = "No internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    
    
    // MARK: Location related APIs

    static func getStudentInformationList(limit: Int = 100, skip: Int = 0, orderBy: SLParam = .updatedAt, completion: @escaping (LocationsData?)->Void) {
        guard let url = URL(string: "\(NetworkConstants.Urls.STUDENT_LOCATION)?\(NetworkConstants.ParameterKeys.LIMIT)=\(limit)&\(NetworkConstants.ParameterKeys.SKIP)=\(skip)&\(NetworkConstants.ParameterKeys.ORDER)=-\(orderBy.rawValue)") else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(NetworkConstants.HeaderValues.UDACITY_APP_ID, forHTTPHeaderField: NetworkConstants.HeaderKeys.UDACITY_APP_ID)
        request.addValue(NetworkConstants.HeaderValues.UDACITY_API_KEY, forHTTPHeaderField: NetworkConstants.HeaderKeys.UDACITY_API_KEY)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var studentLocations: [StudentInformation] = []
            if let statusCode = (response as? HTTPURLResponse)?.statusCode { //Request sent succesfully
                if statusCode >= 200 && statusCode < 300 { // Success response
                    
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let dict = json as? [String:Any],
                        let results = dict["results"] as? [Any] {
                        
                        for location in results {
                            let data = try! JSONSerialization.data(withJSONObject: location)
                            let studentLocation = try! JSONDecoder().decode(StudentInformation.self, from: data)
                            studentLocations.append(studentLocation)
                        }
                        
                    } else {
                        print("Couldn't parse data")
                    }
                } else {
                    print("Couldn't read data correctly")
                }
            } else {
                print("No internet connection")
            }
            
            DispatchQueue.main.async {
                completion(LocationsData(studentLocations: studentLocations))
            }
            
        }
        task.resume()
    }
    
    static func postLocation(_ location: StudentInformation, completion: @escaping (String?)->Void) {
        guard let url = URL(string: NetworkConstants.Urls.STUDENT_LOCATION) else {
            completion("URL is invalid")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue(NetworkConstants.HeaderValues.UDACITY_APP_ID, forHTTPHeaderField: NetworkConstants.HeaderKeys.UDACITY_APP_ID)
        request.addValue(NetworkConstants.HeaderValues.UDACITY_API_KEY, forHTTPHeaderField: NetworkConstants.HeaderKeys.UDACITY_API_KEY)
        request.addValue("application/json", forHTTPHeaderField: NetworkConstants.HeaderKeys.CONTENT_TYPE)
        var locationData = location
        locationData.uniqueKey = userProfile.key
        locationData.firstName = userProfile.first_name
        locationData.lastName = userProfile.last_name
        
        let jsonData = try! JSONEncoder().encode(locationData)
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            var errString: String?
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 { // Success response
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []),
                        let _ = json as? [String:Any] {
                        print("Successfully posted a new location")
                    } else { // Error while reading data
                        errString = "Couldn't parse response"
                    }
                } else { // Error in given login credintials
                    errString = "Courldn't post a new location"
                }
            } else { // Request failed to sent
                errString = "No internet connection"
            }
            DispatchQueue.main.async {
                completion(errString)
            }
            
        }
        task.resume()
    }
    
    
    
}
