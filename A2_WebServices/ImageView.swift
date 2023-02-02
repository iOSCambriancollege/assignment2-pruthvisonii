import Foundation
import UIKit

class ImageViewController: UIViewController {
    
    //declare dog name variable
    var dogName: String!
    //API URL
    let URL: String = "https://dog.ceo/api/breed/"
    
    //Outlet for dog image
    @IBOutlet weak var dogImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Construct URL
        let url: String = URL + dogName + "/images"
        
        // Fetch dog image by breed name
        APIHelper.fetchImage(url: url ) {dogImage in
            
            // Delay execution for demonstration purposes
            for _ in 0...1000000 {
                continue
            }
            
            do {
                // Attempt to set the first image in the response as the dogImage
                self.dogImage.image = UIImage(data: try Data(contentsOf: URL(string: dogImage[0])!))
            } catch let error {
                print(error)
            }
        }
    }
    
    //Action for "New Image" button
    @IBAction func NewImageButton(_ sender: Any) {
        // Construct URL
        let url: String = URL + dogName + "/images"
        
        // Fetch dog image by breed name
        APIHelper.fetchImage(url: url ) {dogImage in
            
            // Delay execution for demonstration purposes
            for _ in 0...1000000 {
                continue
            }
            
            do {
                // Attempt to set a random image in the response as the dogImage
                self.dogImage.image = UIImage(data: try Data(contentsOf: URL(string: dogImage.randomElement()!)!))
            } catch let error {
                print(error)
            }
        }
    }
}
