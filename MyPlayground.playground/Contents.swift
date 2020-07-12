import UIKit
 
let apiKey = "0dde3e9896a8c299d142e214fcb636f8"
 
struct Guest: Codable {
    let success: Bool
    let guestSessionId: String
    
    enum CodingKeys: String, CodingKey {
        case success
        case guestSessionId = "guest_session_id"
    }
}
 
func getGuestSessionId(completion: ((Guest) -> ())?) {
    var components = URLComponents(string: "https://api.themoviedb.org/3/authentication/guest_session/new")!
    
    components.queryItems = [
        URLQueryItem(name: "api_key", value: apiKey)
    ]
    
    let request = URLRequest(url: components.url!)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        if response.statusCode == 200 {
            let decoder = JSONDecoder()
            let response = try! decoder.decode(Guest.self, from: data)
            
            completion?(response)
        } else {
            print("ERROR: \(data), HTTP Status: \(response.statusCode)")
        }
    }
    
    task.resume()
}
 
getGuestSessionId { guest in
    // Base URL Post
    var components = URLComponents(string: "https://api.themoviedb.org/3/movie/339095/rating")!
    
    // Parameter
    components.queryItems = [
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "guest_session_id", value: guest.guestSessionId)
    ]
    
    var request = URLRequest(url: components.url!)
    
    // Header
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Data Post
    let reviewRequest = ReviewRequest(value: 10)
//    let jsonRequest = [
//        "value": 8.5
//    ]
    
    // Kirim data
    let jsonData = try! JSONEncoder().encode(reviewRequest)

    let task = URLSession.shared.uploadTask(with: request, from: jsonData) { data, response, error in
        guard let response = response as? HTTPURLResponse, let data = data else { return }
        
        if response.statusCode == 201 {
            print("DATA: \(data)")
        }
    }
    
    task.resume()
}

// Model pengiriman data
struct ReviewRequest: Codable {
    let value: Double
}
