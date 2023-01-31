import UIKit
import SDWebImage

class DogBreedsTableViewController: UITableViewController {
    
    // Dictionary to store breeds and its subbreeds
    var breeds: [String: [String]] = [:]
    // Array to store keys of the dictionary, i.e., breeds
    var breedKeys = [String]()
    // Array to store images of all the breeds
    var breedImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clearing selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Adding activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: tableView.center.x, y: tableView.center.y-100, width: 20, height: 20)
        tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Fetch breeds and its images in a background thread
        Task {
            do {
                // Fetching all the breeds
                self.breeds = try await DogAPI_Helper.fetchBreeds()
                // Sorting the breed keys
                self.breedKeys = self.breeds.keys.sorted(by: <)
                
                // Fetching images of all the breeds
                for _ in 0...self.breeds.count - 1 {
                    let image = try await DogApi_ImageHelper.fetchBreeds()
                    self.breedImages.append(image)
                }
                
                // Reload the table view on the main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    activityIndicator.stopAnimating()
                }
            } catch let error {
                print("something went wrong: \(error)")
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return breeds.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let breed = breedKeys[section]
        var numberOfSubbreeds = 1
        if breeds[breed]!.count > 0 {
            numberOfSubbreeds = breeds[breed]!.count + 1
        }
        return numberOfSubbreeds
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breed", for: indexPath) as! SubbreedTableViewCell
        
        let breed = breedKeys[indexPath.section]
        if breeds[breed]!.count > 0 && indexPath.row != 0 {
            cell.breedName.text = "\(breed):"
            cell.subBreedName.text = breeds[breed]![indexPath.row - 1]
        } else {
            cell.breedName.text = breed
            cell.subBreedName.alpha = 0
        }
        
        cell.imgView.sd_setImage(with: URL(string: self.breedImageURLs[indexPath.section]), placeholderImage: UIImage())

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DogViewController") as! DogViewController
        vc.breed = keys[indexPath.section]
        navigationController!.pushViewController(vc, animated: true)
    }
}


