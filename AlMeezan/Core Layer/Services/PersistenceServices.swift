//
//  PersistenceServices.swift
//  AlMeezan
//
//  Created by Atta khan on 30/11/2019.
//  Copyright © 2019 Atta khan. All rights reserved.
//

import Foundation
import CoreData

class PersistenceServices {
    private init() { }
    static let shared = PersistenceServices()
    var context: NSManagedObjectContext { return  persistentContainer.viewContext}
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "AlMeezan")
        /*add necessary support for migration*/
        let description = NSPersistentStoreDescription()
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions =  [description]
        /*add necessary support for migration*/
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                print("save into local db")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func create<T: NSManagedObject>() -> T {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: T.entityName(), in: context) else { fatalError("Unable to create \(T.entityName) NSEntityDescription") }
                guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? T else { fatalError("Unable to create \(T.entityName) NSManagedObject")}
                return object
    }
    
    func fetch<T: NSManagedObject>(_ type: T.Type, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        do {
            let object =  try context.fetch(request)
            completion(object)
        } catch {
            print(error)
            completion([])
        }
    }
    
    func fetchWithPredicate<T: NSManagedObject>(_ type: T.Type, _ predicate: NSPredicate, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.predicate = predicate
        do {
            let object =  try context.fetch(request)
            completion(object)
        } catch {
            print(error)
            completion([])
        }
    }
    
    func deleteObj<T: NSManagedObject>(_ type: T.Type, _ object: NSManagedObject){
        do {
            let objectToDelete = object
            context.delete(objectToDelete)
            saveContext()
        } catch let error {
            print("ERROR DELETING : \(error)")
        }
    }
    
    
    func clearEntityData<T: NSManagedObject>(_ type: T.Type) {
        do {
            let request = NSFetchRequest<T>(entityName: String(describing: type))
            
            do {
                let objects  = try context.fetch(request) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    
    func dataSaveIntoPresistance<T: Decodable>(decoder: JSONDecoder, modelType: T.Type) {
        do {
            guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
                fatalError("Failed to retrieve managed object context")
            }
            clearEntityData(T.self as! (NSManagedObject.Type))
            let managedObjectContext = context
            decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
            try context.save()
        } catch let error {
            print(error)
        }

    }

}

