//
//  AstroSurfFavouritesViewController.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 25/02/22.
//

import UIKit

class AstroSurfFavouritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let cellReuseIdentifier = "FavouritePhotoCollectionViewCell"
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "AstroSurfFavouritePhotoCollectionViewCell", bundle: AstroSurfPhotoDetailViewModel.shared.bundle), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AstroSurfPhotoDetailViewModel.shared.getFavouritePhotoCount()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! AstroSurfFavouritePhotoCollectionViewCell
        cell.updateUI(index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AstroSurfPhotoDetailViewModel.shared.setFavouritePhotoIndex(index: indexPath.item)
        DispatchQueue.main.async { [self] in
            let photoViewController = AstroSurfPhotoDetailViewModel.shared.storyboard.instantiateViewController(withIdentifier: "SelectedPhoto") as! AstroSurfSelectedPhotoViewController
            self.navigationController?.pushViewController(photoViewController, animated: true)
        }
    }

 }

extension AstroSurfFavouritesViewController : UICollectionViewDelegateFlowLayout {
    //this method is for the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 200.0)
    }
    
    //these methods are to configure the spacing between items

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}
