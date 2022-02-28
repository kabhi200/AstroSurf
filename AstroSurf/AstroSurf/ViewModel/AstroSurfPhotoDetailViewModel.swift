//
//  AstroSurfPhotoDetailViewModel.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//

import UIKit

public protocol AstroSurfPhtoDetailProtocol {
    func showPhotoDetail()
    func showErrorPopup(errorTitle: String, errorMessage: String)
}

public protocol AstroSurfMediaDescriptionProtocol {
    func mediaSavedLocally()
    func mediaNotSavedLocally()

}

class AstroSurfPhotoDetailViewModel: NSObject {
    
    var networkingDelegate: AstroSurfNeetworkingProtocol?
    var photoDetailDelegate: AstroSurfPhtoDetailProtocol?
    var mediaDescriptionDelegate: AstroSurfMediaDescriptionProtocol?

    public lazy var bundle = Bundle(for: AstroSurfPhotoDetailViewModel.self)
    lazy var storyboard = UIStoryboard(name: "Main", bundle: bundle)
    private let cache = NSCache<NSString, AstronomerPhotoVideoCacheModel>()

    var isFavouriteSelected = false
    var selectedFavouritePhotoIndex = -1
    
    var photoDetailModel: AstronomerPhotoVideoModel?
    var cachedPhotoDetailModel: AstronomerPhotoVideoCacheModel?
    var favouriteImages = [FavouriteImage]()
    
    public static let shared = AstroSurfPhotoDetailViewModel()
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(onDataSavedLocally), name: .dataSavedLocally, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDataNotSavedLocally), name: .errorInSavingData, object: nil)
    }
    
    
    /// To get the Photo Detail for the selected date from the server or cache
    /// - Parameter selectedDate: selected date
    func getPhotoDetailforDate(selectedDate: String) {
        let _ = AstroSurfNetworkingService()
        isFavouriteSelected = false
        if Reachability.isConnectedToNetwork() {
            self.networkingDelegate?.callNetworkAPI(selectedDate: selectedDate, completion: { photoModel, error in
                if photoModel != nil {
                    self.photoDetailModel = photoModel
                    self.updatePhotoDetailInCache()
                    self.photoDetailDelegate?.showPhotoDetail()
                } else {
                    self.photoDetailDelegate?.showErrorPopup(errorTitle: (error as? ErrorHandler)?.title ?? "Error", errorMessage: (error as? ErrorHandler)?.errorDescription ?? "UnknownError")
                }
            })
        } else {
            self.photoDetailModel = nil
            if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                cachedPhotoDetailModel = cachedPhotoModel
                self.photoDetailDelegate?.showPhotoDetail()
            } else {
                // return errorPopUp for no internet connection
            }
        }
    }
    
    
    /// To get the image data from the url.
    /// - Returns: optional Data object
    func getDataFromImageUrl() -> Data? {
        if self.isFavouriteSelected {
            return self.getFavouritePhotoDataForIndex(index: self.selectedFavouritePhotoIndex)
        } else {
            if let photoModel = photoDetailModel {
                guard let urlData = try? Data(contentsOf: URL(string: photoModel.hdurl ?? "")!) else {
                    return nil
                }
                return urlData
            } else {
                if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                    return cachedPhotoModel.imageData
                }
            }
            return nil
        }
    }
    
    
    /// To get the published date.
    /// - Returns: String object
    func getPublishedDate() -> String {
        if self.isFavouriteSelected {
            return self.getFavouritePhotoDateForIndex(index: self.selectedFavouritePhotoIndex)
        } else {
            if let photoModel = photoDetailModel {
                return photoModel.date
            } else {
                if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                    return cachedPhotoModel.date
                }
            }
            return ""
        }
    }
    
    /// To get the photo title.
    /// - Returns: String object
    func getPhotoTitle() -> String {
        if self.isFavouriteSelected {
            return self.getFavouritePhotoTitleForIndex(index: self.selectedFavouritePhotoIndex)
        } else {
            if let photoModel = photoDetailModel {
                return photoModel.title
            } else {
                if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                    return cachedPhotoModel.title
                }
            }
            return ""
        }
    }
    
    /// To get the media type
    /// - Returns: MediaType object
    func getMediaType() -> MediaType {
        if self.isFavouriteSelected {
            return self.getFavouriteMediaTypeForIndex(index: self.selectedFavouritePhotoIndex)
        } else {
            if let photoModel = photoDetailModel {
                return photoModel.mediaType
            } else {
                if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                    return cachedPhotoModel.mediaType
                }
            }
            return .image
        }

    }
    
    /// To get the photo description
    /// - Returns: String object
    func getPhotoDescription() -> String {
        if self.isFavouriteSelected {
            return self.getFavouritePhotoDescriptionForIndex(index: self.selectedFavouritePhotoIndex)
        } else {
            if let photoModel = photoDetailModel {
                return photoModel.explanation
            } else {
                if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                    return cachedPhotoModel.description
                }
            }
            return ""
        }
     }
    
    /// To get the media url
    /// - Returns: String object
    func getMediaUrl() -> String {
        if self.isFavouriteSelected {
            return self.getFavouriteMediaUrlForIndex(index: self.selectedFavouritePhotoIndex)
        } else {
            if let photoModel = photoDetailModel {
                return photoModel.url
            } else {
                if let cachedPhotoModel = cache.object(forKey: "cachedPhotoData") {
                    return cachedPhotoModel.mediaUrl
                }
            }
            return ""
        }

    }
    
    /// To update latest media detail in cache.
    func updatePhotoDetailInCache() {
        var data: Data? = nil
        if AstroSurfPhotoDetailViewModel.shared.getMediaType() == .image {
            data = self.getDataFromImageUrl()
        }
        cachedPhotoDetailModel = AstronomerPhotoVideoCacheModel(publishedDate: self.photoDetailModel!.date, photoDescription: self.photoDetailModel!.explanation, imageData: data, photoTitle: self.photoDetailModel!.title, mediaUrl: self.photoDetailModel!.url, mediaType: AstroSurfPhotoDetailViewModel.shared.getMediaType())
        self.cache.setObject(cachedPhotoDetailModel!, forKey: "cachedPhotoData")
    }
    
    /// To check if internet is available or not.
    func isInternetReachable() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
}

extension AstroSurfPhotoDetailViewModel {
    
    
    /// To insert the media detail in the core data
    func addPhotoDetailToFavourites() {
        if let photoModel = photoDetailModel {
            if AstroSurfPhotoDetailViewModel.shared.getMediaType() == .image {
                guard let urlData = try? Data(contentsOf: URL(string: photoModel.hdurl ?? "")!) else {
                    return
                }
                let photoDetail = AstronomerPhotoVideoCacheModel(publishedDate: photoModel.date, photoDescription: photoModel.explanation, imageData: urlData, photoTitle: photoModel.title, mediaUrl: photoModel.url, mediaType: .image)
                CoreDataManager.sharedManager.insertPhotoDetail(photoDetailModel: photoDetail)
            } else {
                let photoDetail = AstronomerPhotoVideoCacheModel(publishedDate: photoModel.date, photoDescription: photoModel.explanation, imageData: nil, photoTitle: photoModel.title, mediaUrl: photoModel.url, mediaType: .video)
                CoreDataManager.sharedManager.insertPhotoDetail(photoDetailModel: photoDetail)
            }
        }
    }
    
    
    /// Notification if data saved in core data.
    @objc func onDataSavedLocally() {
        self.mediaDescriptionDelegate?.mediaSavedLocally()
    }
    
    /// Notification if data is not saved in core data.
    @objc func onDataNotSavedLocally() {
        self.mediaDescriptionDelegate?.mediaNotSavedLocally()
    }
    
    
    /// get the favourite media title for selected index
    /// - Parameter index: selected index
    /// - Returns: String object
    func getFavouritePhotoTitleForIndex(index: Int) -> String {
        return favouriteImages[index].title!
    }

    /// get the favourite media date for selected index
    /// - Parameter index: selected index
    /// - Returns: String object
    func getFavouritePhotoDateForIndex(index: Int) -> String {
        return favouriteImages[index].publishedDate!
    }

    /// get the favourite media data for selected index
    /// - Parameter index: selected index
    /// - Returns: Data object
    func getFavouritePhotoDataForIndex(index: Int) -> Data? {
        return favouriteImages[index].imageData
    }
    
    /// get the favourite media description for selected index
    /// - Parameter index: selected index
    /// - Returns: String object
    func getFavouritePhotoDescriptionForIndex(index: Int) -> String {
        return favouriteImages[index].imageDescription!
    }
    
    /// get the favourite media url for selected index
    /// - Parameter index: selected index
    /// - Returns: String object
    func getFavouriteMediaUrlForIndex(index: Int) -> String {
        return favouriteImages[index].mediaUrl!
    }

    /// get the favourite media type for selected index
    /// - Parameter index: selected index
    /// - Returns: MediaType object
    func getFavouriteMediaTypeForIndex(index: Int) -> MediaType {
        return favouriteImages[index].mediaType
    }

    /// To get all the records from the core data
    func getAllFavouritePhotoDetail() {
        if CoreDataManager.sharedManager.fetchAllFavouritePhotoDetail() != nil {
            favouriteImages = CoreDataManager.sharedManager.fetchAllFavouritePhotoDetail()!
        }
    }
    
    /// To get and return the number of records in core data
    /// - Returns: number of records
    func getFavouritePhotoCount() -> Int {
        isFavouriteSelected = true
        self.getAllFavouritePhotoDetail()
        return favouriteImages.count
    }
    
    /// Date formatting from Date object to String object
    /// - Parameter selectedDate: Date object
    /// - Returns: the date after formatting
    func getDateString(selectedDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        return dateString
    }
    
    /// To set the index of the selected favourite index
    /// - Parameter index: selected favourite index
    func setFavouritePhotoIndex(index: Int) {
        self.selectedFavouritePhotoIndex = index
    }
}


