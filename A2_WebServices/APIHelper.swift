import Foundation
import UIKit

class APIHelper{
    
    private static let baseURL : String = "https://dog.ceo/api/breeds/"

    private static let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
  
    static func fetchdog(callback: @escaping ([String]) -> Void){
        guard
            let url = URL(string: baseURL + "list")
        else{return}
        //new array to receive data from API
        var newArray = [String]()
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, response, error in

            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard
                        let jsonDictionary = jsonObject as? [AnyHashable: Any],
                        let dogType = jsonDictionary["message"] as? [String]
                    else {preconditionFailure("could not parse Json data")}
                    //receive data from jsonDictionary
                    for i in 0..<dogType.count {
                       let item = dogType[i]
                        newArray.append(item)
                    }
                    OperationQueue.main.addOperation {
                        callback(newArray)
                    }
                } catch let e {
                    print("error \(e)")
                }
            } else if let error = error {
                print("there was an error: \(error)")
            } else {
                print("something went wrong")
            }
        }
        task.resume()
    }
    
    static func fetchImage(url: String, callback: @escaping ([String]) -> Void){
        
        guard
            //set up dog image url later with dog breed from previous API result
            let url = URL(string: url)
        else{return}
        
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            data, response, error in

            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard
                        let jsonDictionary = jsonObject as? [AnyHashable: Any],
                        let dogImage = jsonDictionary["message"] as? [String]
                    else {preconditionFailure("could not parse JSOn data")}
      
                    OperationQueue.main.addOperation {
                        callback(dogImage)
                    }
                } catch let e {
                    print("error \(e)")
                }
            } else if let error = error {
                print("there was an error: \(error)")
            } else {
                print("something went wrong")
            }
        }
        task.resume()
    }
}
