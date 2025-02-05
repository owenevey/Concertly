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
    
    func saveItems<T>(_ items: [T], category: String) {
        deleteItems(for: category)
        
        items.forEach { item in
            if let concert = item as? Concert {
                convertToConcertEntity(concert, category: category, context: context)
            }
        }
        
        saveContext()
    }

    
    func fetchItems<T>(for category: String) -> [T] {
        var items: [T] = []
        
        if T.self == Concert.self {
            let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category = %@", category)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            
            items = fetchEntities(for: request, category: category) { entity in
                return self.convertToConcert(entity) as! T
            }
        }
        else if T.self == SuggestedArtist.self {
            let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category = %@", category)
            
            items = fetchEntities(for: request, category: category) { entity in
                return convertToArtist(entity) as! T
            }
        }
//        else if T.self == SuggestedDestination.self {
//            let request: NSFetchRequest<DestinationEntity> = DestinationEntity.fetchRequest()
//            request.predicate = NSPredicate(format: "category = %@", category)
//            
//            items = fetchEntities(for: request, category: category) { entity in
//                return convertToDestination(entity) as! T
//            }
//        }
        
        return items
    }

    func fetchEntities<T, E: NSManagedObject>(for request: NSFetchRequest<E>, category: String, convert: @escaping (E) -> T) -> [T] {
        var items: [T] = []
        
        do {
            let fetchedEntities = try context.fetch(request)
            items = fetchedEntities.map { entity in
                return convert(entity)
            }
        } catch {
            print("Error fetching \(E.self) for \(category): \(error)")
        }
        
        return items
    }
    
    func deleteItems(for category: String) {
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
    
    func deleteArtists(for category: String) {
        let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category == %@", category)
        
        do {
            let artists = try context.fetch(request)
            artists.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting artists for \(category): \(error)")
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data: \(error)")
        }
    }
    
    private func convertToConcertEntity(_ concert: Concert, category: String, context: NSManagedObjectContext) {
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
        entity.category = category
        
        if let lineupData = try? JSONEncoder().encode(concert.lineup) {
            entity.lineup = lineupData
        }
        
        if let nameData = try? JSONEncoder().encode(concert.name) {
            entity.name = nameData
        }
        
        if let urlData = try? JSONEncoder().encode(concert.url) {
            entity.url = urlData
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
    
    private func convertToArtistEntity(_ artist: SuggestedArtist, category: String, context: NSManagedObjectContext) {
        let entity = ArtistEntity(context: context)
        entity.name = artist.name
        entity.id = artist.id
        entity.imageUrl = artist.imageUrl
        entity.category = category
    }
    
    private func convertToArtist(_ entity: ArtistEntity) -> SuggestedArtist {
        return SuggestedArtist(name: entity.name ?? "", id: entity.id ?? "", imageUrl: entity.imageUrl ?? "")
    }
    
}
