//
//  ViewController.swift
//  A2_WebServices
//
//  Created by Cambrian on 2023-01-25.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    @IBOutlet weak var breedNameLabel: UILabel!
    @IBOutlet weak var dogImage: UIImageView!
    
    var breed = String()
    var breeds: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

       // self.breedNameLabel.text = breed
        
        Task{
            do{
                self.breeds = try await DogApi_ImageFull.fetchBreeds(breed: breed)
                breedNameLabel.text = "Total Images for \(breed) = " + String(breeds.count) //name and image count
                self.dogImage.sd_setImage(with: URL(string: self.breeds[0]), placeholderImage: UIImage()) //bringing in the dog image as soon the view is displayed + caching with sdwebimage, 
            }
            catch let err{
                print("something went wrong: \(err)")
            }
        }
    }
       
    @IBAction func randomImage(_ sender: Any) { //bringing in new image
        self.dogImage.sd_setImage(with: URL(string: self.breeds[Int.random(in: 0...self.breeds.count-1 )]), placeholderImage: UIImage())
    }
}
