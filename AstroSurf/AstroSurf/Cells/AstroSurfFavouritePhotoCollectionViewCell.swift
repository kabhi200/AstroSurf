//
//  AstroSurfFavouritePhotoCollectionViewCell.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 28/02/22.
//

import UIKit

class AstroSurfFavouritePhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var favouriteImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    /// To update the UI of the collection view cell
    /// - Parameter index: index of the selected cell
    func updateUI(index: Int) {
        self.titleLabel.text = AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoTitleForIndex(index: index)
        if let imageData = AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoDataForIndex(index: index) {
            DispatchQueue.main.async { [self] in
                self.favouriteImage.image = UIImage(data: imageData)
            }
        }
    }
}
