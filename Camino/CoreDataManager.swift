import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "SavedDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveConcerts(_ concerts: [Concert], category: String) {
        deleteConcerts(for: category)
        
        concerts.forEach { concert in
            convertToEntity(concert, context: context)
        }
        
        saveContext()
    }
    
    func fetchConcerts(for category: String) -> [Concert] {
        let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@", category)
        
        do {
            let fetchedConcerts = try context.fetch(request)
            
            return fetchedConcerts.map { entity in
                return convertToConcert(entity)
            }
        } catch {
            print("Error fetching concerts for \(category): \(error)")
            return []
        }
    }
    
    
    func deleteConcerts(for category: String) {
        let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let concerts = try context.fetch(request)
            concerts.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting concerts for \(category): \(error)")
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data: \(error)")
        }
    }
    
    private func convertToEntity(_ concert: Concert, context: NSManagedObjectContext) {
        let entity = ConcertEntity(context: context)
        entity.artistId = concert.artistId
        entity.artistName = concert.artistName
        entity.cityName = concert.cityName
        entity.closestAirport = concert.closestAirport
        entity.date = concert.date
        entity.id = concert.id
        entity.imageUrl = concert.imageUrl
        entity.latitude = concert.latitude
        entity.longitude = concert.longitude
        entity.timezone = concert.timezone
        entity.venueAddress = concert.venueAddress
        entity.venueName = concert.venueName
        
        if let lineupData = try? JSONEncoder().encode(concert.lineup) {
            entity.lineup = lineupData
        }
        
        if let nameData = try? JSONEncoder().encode(concert.name) {
            entity.name = nameData
        }
        
        if let urlData = try? JSONEncoder().encode(concert.url) {
            entity.lineup = urlData
        }
    }
    
    private func convertToConcert(_ entity: ConcertEntity) -> Concert {
        let lineup: [SuggestedArtist]
        let name: [String]
        let url: [String]
        
        if let lineupData = entity.lineup,
           let decodedLineup = try? JSONDecoder().decode([SuggestedArtist].self, from: lineupData) {
            lineup = decodedLineup
        } else {
            lineup = []
        }
        
        if let nameData = entity.name,
           let decodedName = try? JSONDecoder().decode([String].self, from: nameData) {
            name = decodedName
        } else {
            name = []
        }
        
        if let urlData = entity.url,
           let decodedUrl = try? JSONDecoder().decode([String].self, from: urlData) {
            url = decodedUrl
        } else {
            url = []
        }
        
        
        
        return Concert(name: name, id: entity.id ?? "", artistName: entity.artistName ?? "", artistId: entity.artistId ?? "", url: url, imageUrl: entity.imageUrl ?? "", date: entity.date ?? Date(), timezone: entity.timezone ?? "", venueName: entity.venueName ?? "", venueAddress: entity.venueAddress ?? "", cityName: entity.cityName ?? "", latitude: entity.latitude, longitude: entity.longitude, lineup: lineup, closestAirport: entity.closestAirport)
    }
    
}
