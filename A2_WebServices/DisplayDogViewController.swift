import UIKit
import SDWebImage

class DisplayDogViewController: UIViewController {

// an array to store dog breeds
var dog = [String]()

override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    // set table row height
    self.tableView.rowHeight = 40.0
    
    // fetch dog breeds list
    APIHelper.fetchdog { newArray in
        self.dog = newArray
        self.tableView.reloadData()
    }
}

// MARK: - Table view data source
override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dog.count
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as! TableViewCell
    
    // set the cell's label with the dog breed
    cell.Name.text = dog[indexPath.row]
    
    // fetch the dog breed name
    APIHelper.fetchdog { newArray in
        let URL: String = "https://dog.ceo/api/breed/"
        let List = newArray[indexPath.row]
        let url: String = URL + List + "/images"
        
        // fetch the dog image with the dog breed
        APIHelper.fetchImage(url: url) { dogImage in
            // wait for some time to load the image
            for _ in 0...100000 {
                continue
            }
            
            do {
                try cell.dogImage.image = UIImage(data: NSData(contentsOf: NSURL(string: dogImage[0])! as URL) as Data)
            } catch let error {
                print(error)
            }
        }
    }
    return cell
}

// MARK: - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // get the index of the selected cell
    let index = tableView.indexPathForSelectedRow!.row
    // get the selected dog name (string)
    let selectedDog = dog[index].self
    let dst = segue.destination as! ImageViewController
    // set the dog breed view controller's variable dogName as the selected dog name
    dst.dogName = selectedDog
}
}





