//
//  AstroSurfSelectedPhotoViewController.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit
import AVKit
import AVFoundation

class AstroSurfSelectedPhotoViewController: UIViewController {

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var addToFavoriteButton: UIButton!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var videoLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var isFavouriteSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateUI()
        self.updateGesture()
    }
    
    
    /// To update the gesture on the view.
    func updateGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDetailView(sender:)))

        if AstroSurfPhotoDetailViewModel.shared.getMediaType() == .image {
            photoImageView.addGestureRecognizer(tapGesture)
        } else {
            headerLabel.addGestureRecognizer(tapGesture)
        }
        
        tapGesture.cancelsTouchesInView = false
        
        let videoTapGesture = UITapGestureRecognizer(target: self, action: #selector(showVidoDetailView(sender:)))
        
        videoLabel.addGestureRecognizer(videoTapGesture)
        videoTapGesture.cancelsTouchesInView = false

    }
    
    /// To update the ui.
    func updateUI() {
        AstroSurfPhotoDetailViewModel.shared.mediaDescriptionDelegate = self
        self.title = AstroSurfPhotoDetailViewModel.shared.getPhotoTitle()
        imageTitleLabel.text = "Dated: " + AstroSurfPhotoDetailViewModel.shared.getPublishedDate()
        self.addToFavoriteButton.isHidden = AstroSurfPhotoDetailViewModel.shared.isFavouriteSelected ? true : false
        
        
        if AstroSurfPhotoDetailViewModel.shared.getMediaType() == .image {
            self.videoLabel.isHidden = true
            self.photoImageView.isHidden = false
            if let imageData = AstroSurfPhotoDetailViewModel.shared.getDataFromImageUrl() {
                DispatchQueue.main.async { [self] in
                    photoImageView.image = UIImage(data: imageData)
                }
            }
        } else {
            self.headerLabel.text = "Please tap here to see Video Detail"
            self.photoImageView.isHidden = true
            self.videoLabel.isHidden = false
        }
        self.handleDarkMode()
    }
    
    
    /// Handle dark mode
    func handleDarkMode() {
        if self.traitCollection.userInterfaceStyle == .dark {
            self.view.backgroundColor = .white
            self.imageTitleLabel.textColor = .black
            self.headerLabel.textColor = .black
        }
    }
    
    /// To show Photo detail
    /// - Parameter : tap gesture

    @objc func showDetailView(sender _: UITapGestureRecognizer) {
        let photoDetailViewController = AstroSurfPhotoDetailViewModel.shared.storyboard.instantiateViewController(withIdentifier: "PhotoDetail") as! AstroSurfPhotoDetailsViewController

        self.navigationController?.present(photoDetailViewController, animated: true, completion: nil)
    }
    
    
    /// This is called to add the photo/video details in the core data
    /// - Parameter sender: add to favourite button
    @IBAction func addToFavouriteButtonAction(_ sender: UIButton) {
        if isFavouriteSelected {
            self.showAlert(title: "Added to Favourite", message: "The image is already added to Favourites")
        } else {
            DispatchQueue.main.async { [self] in
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            }

            isFavouriteSelected = true
            AstroSurfPhotoDetailViewModel.shared.addPhotoDetailToFavourites()
        }
    }
    
    
    /// To show video detail
    /// - Parameter : tap gesture
    @objc func showVidoDetailView(sender _: UITapGestureRecognizer) {
        if AstroSurfPhotoDetailViewModel.shared.isInternetReachable() {
            let photoDetailViewController = AstroSurfPhotoDetailViewModel.shared.storyboard.instantiateViewController(withIdentifier: "WebViewController") as! AstroSurfWebViewController

            self.navigationController?.present(photoDetailViewController, animated: true, completion: nil)
        } else {
            self.showAlert(title: "No Internet", message: "Please connect to Internet to play the video")
        }
    }

    /// Method to show the alert popup
    /// - Parameters:
    ///   - errorTitle: title of the alert
    ///   - errorMessage: alert message

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

extension AstroSurfSelectedPhotoViewController : AstroSurfMediaDescriptionProtocol{

    /// This is called when media data is saved in core data
    func mediaSavedLocally() {
        DispatchQueue.main.async { [self] in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.addToFavoriteButton.setTitle("Added to Favourite", for: .normal)
        }
    }
    
    
    /// This is called when media data is not saved in core data
    func mediaNotSavedLocally() {
        DispatchQueue.main.async { [self] in
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }

        isFavouriteSelected = false
    }
}
