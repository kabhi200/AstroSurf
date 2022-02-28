//
//  AstroSurfPhotoDetailsViewController.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit

class AstroSurfPhotoDetailsViewController: UIViewController {

    @IBOutlet var imageTitleLabel: UILabel!
    @IBOutlet var imageDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        self.updateGesture()
    }
    
    /// To update the ui.
    func updateUI() {
        self.imageTitleLabel.text = AstroSurfPhotoDetailViewModel.shared.getPhotoTitle()
        self.imageDescriptionLabel.text = AstroSurfPhotoDetailViewModel.shared.getPhotoDescription()
    }
    
    /// To update the gesture on the view.
    func updateGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(sender:)))
        self.view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
    /// To dismiss the presented view
    /// - Parameter : tap gesture
    @objc func dismissView(sender _: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
}
