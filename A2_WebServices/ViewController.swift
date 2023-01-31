import UIKit
import SDWebImage

class DisplayDogViewController: UIViewController {

    // Outlet for breed name label
    @IBOutlet weak var breedNameLabel: UILabel!
    
    // Outlet for dog image view
    @IBOutlet weak var dogImage: UIImageView!
    
    // Breed name
    var breed = String()
    
    // Array of breed images
    var breeds: [String] = []
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch the breed images using DogApi_ImageFull
        Task {
            do {
                self.breeds = try await DogApi_ImageFull.fetchBreeds(breed: self.breed)
                self.breedNameLabel.text = "Total Images for \(self.breed) = " + String(self.breeds.count)
                self.dogImage.sd_setImage(with: URL(string: self.breeds[0]), placeholderImage: UIImage())
            } catch let error {
                print("Error fetching breed images: \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func randomImage(_ sender: Any) {
        self.dogImage.sd_setImage(with: URL(string: self.breeds[Int.random(in: 0...self.breeds.count-1 )]), placeholderImage: UIImage())
    }
}
