import UIKit
import SDWebImage

class DogBreedListViewController: UITableViewController {

    var breeds: [String: [String]] = [:]
    var breedKeys = [String]()
    var breedImageURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: tableView.center.x, y: tableView.center.y - 100, width: 20, height: 20)
        tableView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        Task {
            do {
                self.breeds = try await DogAPI_Helper.fetchBreeds()
                self.breedKeys = self.breeds.keys.sorted(by: <)
                
                for _ in 0...self.breeds.count - 1 {
                    let imgURL = try await DogApi_ImageHelper.fetchBreeds()
                    self.breedImageURLs.append(imgURL)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    activityIndicator.stopAnimating()
                }
            } catch let error {
                print("Something went wrong: \(error)")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return breeds.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let breed = breedKeys[section]
        return breeds[breed]?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breed", for: indexPath) as! SubbreedTableViewCell

        let breed = breedKeys[indexPath.section]
        if let subbreeds = breeds[breed], subbreeds.count > 0, indexPath.row != 0 {
            cell.breedName.text = "\(breed):"
            cell.subBreedName.text = subbreeds[indexPath.row - 1]
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
