//
//  CoreDataManager.swift
//  AstroSurf
//
//  Created by Abhishek Kumar on 27/02/22.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {
  
    static let sharedManager = CoreDataManager.init()
    
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AstroSurf")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        })
        return container
  }()
  
    
    /// To save the details in the core data
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    /// To insert data in the core data based on data in the model class
    /// - Parameter photoDetailModel: model class object
    func insertPhotoDetail(photoDetailModel: AstronomerPhotoVideoCacheModel) {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "FavouriteImage",
                                              in: managedContext)!
        let photoDetail = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
      
        photoDetail.setValue(photoDetailModel.imageData, forKeyPath: "imageData")
        photoDetail.setValue(photoDetailModel.description, forKeyPath: "imageDescription")
        photoDetail.setValue(photoDetailModel.date, forKeyPath: "publishedDate")
        photoDetail.setValue(photoDetailModel.title, forKeyPath: "title")
        photoDetail.setValue(photoDetailModel.mediaUrl, forKeyPath: "mediaUrl")
        photoDetail.setValue(photoDetailModel.mediaType.rawValue, forKeyPath: "media_type")

        do {
            try managedContext.save()
            NotificationCenter.default.post(name: .dataSavedLocally, object: nil)
        } catch let error as NSError {
            NotificationCenter.default.post(name: .errorInSavingData, object: nil)
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    /// To fetch all records from the core data
    /// - Returns: the array of all records
    func fetchAllFavouritePhotoDetail() -> [FavouriteImage]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteImage")
        do {
            let photoDetail = try managedContext.fetch(fetchRequest)
            return photoDetail as? [FavouriteImage]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }

}
