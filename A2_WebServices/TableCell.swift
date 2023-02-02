import Foundation
import UIKit

// Class for custom table view cell
class TableCell: UITableViewCell {

swift
Copy code
// Outlet for dog breed name label
@IBOutlet weak var Name: UILabel!

// Outlet for dog breed image view
@IBOutlet weak var dogImage: UIImageView!

// Function to be called when cell is created from the storyboard
override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}

// Function to be called when cell is selected
override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
}
}
