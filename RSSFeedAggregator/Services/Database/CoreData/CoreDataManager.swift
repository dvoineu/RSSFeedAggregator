//
//  CoreDataManager.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 1.12.24.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func loadNews() -> [Feed]? {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
        
        do {
            let news = try context.fetch(fetchRequest)
            return news
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteNews() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
        
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func addNews(feedTitle: String, feedDate: String, feedDescription: String) -> Feed? {
        let context = getContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Feed", in: context) else { return nil }
        
        let feedObject = Feed(entity: entity, insertInto: context)
        feedObject.title = feedTitle
        feedObject.date = feedDate
        feedObject.feedDescription = feedDescription
        
        do {
            try context.save()
            return feedObject
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveNews(news: [Feed]) {
        
        for i in 0..<news.count {
            let context = getContext()
            
            guard let entity = NSEntityDescription.entity(forEntityName: "Feed", in: context) else { return }
            
            let feedObject = Feed(entity: entity, insertInto: context)
            feedObject.title = news[i].title
            feedObject.date = news[i].date
            feedObject.feedDescription = news[i].feedDescription
            feedObject.isReading = news[i].isReading
            
            do {
                try context.save()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}

