import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "SavedDataContainer")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load stores: \(error)")
            }
            
        }
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func saveItems<T>(_ items: [T], category: String = "") {
        if T.self == Concert.self {
            if category != ContentCategories.saved.rawValue {
                deleteItems(for: category, type: ConcertEntity.self)
            }
        }
        else if T.self == SuggestedArtist.self {
            if category != ContentCategories.following.rawValue && category != ContentCategories.recentSearches.rawValue {
                deleteItems(for: category, type: ArtistEntity.self)
            }
        }
        else if T.self == Destination.self {
            deleteItems(type: DestinationEntity.self)
        }
        else if T.self == Venue.self {
            deleteItems(type: VenueEntity.self)
        }
        
        items.forEach { item in
            var entity: NSManagedObject?
            
            if let concert = item as? Concert {
                entity = convertToConcertEntity(concert, category: category, context: context)
            }
            else if let artist = item as? SuggestedArtist {
                entity = convertToArtistEntity(artist, category: category, context: context)
            }
            else if let destination = item as? Destination {
                entity = convertToDestinationEntity(destination, context: context)
            }
            else if let venue = item as? Venue {
                entity = convertToVenueEntity(venue, context: context)
            }
            else if let notification = item as? SavedNotification {
                entity = convertToNotificationEntity(notification, context: context)
            }
        }
        
        saveContext()
    }
    
    func isConcertSaved(id: String) -> Bool {
        let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@ AND id = %@", ContentCategories.saved.rawValue, id)
        
        let items: [ConcertEntity] = fetchEntities(for: request)
        return items.count > 0
    }
    
    func saveConcert(_ concert: Concert) {
        unSaveConcert(id: concert.id)
        saveItems([concert], category: ContentCategories.saved.rawValue)
    }
    
    func unSaveConcert(id: String) {
        let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@ AND id = %@", ContentCategories.saved.rawValue, id)
        
        deleteEntities(request: request)
    }
    
    func isFollowingArtist(id: String) -> Bool {
        let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@ AND id = %@", ContentCategories.following.rawValue, id)
        
        let items: [ArtistEntity] = fetchEntities(for: request)
        return items.count > 0
    }
    
    func saveArtist(_ artist: SuggestedArtist, category: String) {
        saveItems([artist], category: category)
    }
    
    func unSaveArtist(id: String, category: String) {
        let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category = %@ AND id = %@", category, id)
        
        deleteEntities(request: request)
    }
    
    func fetchSavedConcert(id: String) -> Concert? {
        let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        let fetchedItems = fetchEntities(for: request) { entity in
            return self.convertToConcert(entity) as Concert
        }
        return fetchedItems.first
    }
    
    func fetchItems<T>(for category: String = "", type: T.Type, sortKey: String = "sortKey") -> [T] {
        var items: [T] = []
        
        if T.self == Concert.self {
            let request: NSFetchRequest<ConcertEntity> = ConcertEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category = %@", category)
            request.sortDescriptors = [NSSortDescriptor(key: sortKey, ascending: true), NSSortDescriptor(key: "id", ascending: true)]
            
            items = fetchEntities(for: request) { entity in
                return self.convertToConcert(entity) as! T
            }
        }
        else if T.self == SuggestedArtist.self {
            let request: NSFetchRequest<ArtistEntity> = ArtistEntity.fetchRequest()
            request.predicate = NSPredicate(format: "category = %@", category)
            var sortDescriptors: [NSSortDescriptor] = []
            
            if category == ContentCategories.recentSearches.rawValue {
                sortDescriptors.append(NSSortDescriptor(key: "creationDate", ascending: false))
            }
            else if category == ContentCategories.following.rawValue {
                sortDescriptors.append(NSSortDescriptor(key: "name", ascending: true))
            }
            else {
                sortDescriptors.append(NSSortDescriptor(key: "id", ascending: true))
            }
            
            request.sortDescriptors = sortDescriptors
            
            let entities: [ArtistEntity] = fetchEntities(for: request)
            
            if category == ContentCategories.recentSearches.rawValue {
                let first15Items = entities.prefix(15)
                let remainingItems = entities.dropFirst(15)
                
                remainingItems.forEach { context.delete($0) }
                saveContext()
                
                items = first15Items.compactMap { self.convertToArtist($0) as? T }
            } else {
                items = entities.compactMap { self.convertToArtist($0) as? T }
            }
        }
        else if T.self == Destination.self {
            let request: NSFetchRequest<DestinationEntity> = DestinationEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "geoHash", ascending: true)]
            
            items = fetchEntities(for: request) { entity in
                return self.convertToDestination(entity) as! T
            }
        }
        else if T.self == Venue.self {
            let request: NSFetchRequest<VenueEntity> = VenueEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "closestAirport", ascending: true)]
            
            items = fetchEntities(for: request) { entity in
                return self.convertToVenue(entity) as! T
            }
        }
        else if T.self == SavedNotification.self {
            let request: NSFetchRequest<SavedNotificationEntity> = SavedNotificationEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            items = fetchEntities(for: request) { entity in
                return self.convertToNotification(entity) as! T
            }
        }
        
        return items
    }
    
    private func fetchEntities<T, E: NSManagedObject>(for request: NSFetchRequest<E>, convert: @escaping (E) -> T = { $0 as! T }) -> [T] {
        var items: [T] = []
        
        do {
            let fetchedEntities = try context.fetch(request)
            items = fetchedEntities.map { entity in
                return convert(entity)
            }
        } catch {
            print(error)
        }
        
        return items
    }
    
    func deleteItems<T: NSManagedObject>(for category: String = "", type: T.Type) {
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: String(describing: T.self))
        
        switch type {
        case is ConcertEntity.Type, is ArtistEntity.Type:
            request.predicate = NSPredicate(format: "category = %@", category)
        case is DestinationEntity.Type, is VenueEntity.Type:
            break
            
        default:
            print("Unsupported entity type: \(T.self)")
            return
        }
        
        deleteEntities(request: request)
    }
    
    private func deleteEntities<E: NSManagedObject>(request: NSFetchRequest<E>) {
        do {
            let fetchedEntities = try context.fetch(request)
            fetchedEntities.forEach { context.delete($0) }
            saveContext()
        } catch {
            print("Error deleting items: \(error)")
        }
    }
    
    func deleteAllSavedItems() {
        let persistentStoreCoordinator = container.persistentStoreCoordinator
        let context = container.viewContext
        
        for entityName in persistentStoreCoordinator.managedObjectModel.entities.compactMap({ $0.name }) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            
            do {
                let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
            } catch {
                print("Failed to batch delete \(entityName): \(error)")
            }
        }
    }



    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data: \(error)")
        }
    }
    
    private func convertToConcertEntity(_ concert: Concert, category: String, context: NSManagedObjectContext) -> NSManagedObject {
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
        entity.sortKey = Int64(concert.sortKey ?? 0)
        entity.flightsPrice = Int64(concert.flightsPrice ?? -1)
        entity.hotelsPrice = Int64(concert.hotelsPrice ?? -1)
        
        if let lineupData = try? JSONEncoder().encode(concert.lineup) {
            entity.lineup = lineupData
        }
        
        if let nameData = try? JSONEncoder().encode(concert.names) {
            entity.name = nameData
        }
        
        if let urlData = try? JSONEncoder().encode(concert.urls) {
            entity.url = urlData
        }
        
        return entity
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
        
        return Concert(names: name, id: entity.id ?? "", artistName: entity.artistName ?? "", artistId: entity.artistId ?? "", urls: url, imageUrl: entity.imageUrl ?? "", date: entity.date ?? Date(), timezone: entity.timezone ?? "", venueName: entity.venueName ?? "", venueAddress: entity.venueAddress ?? "", cityName: entity.cityName ?? "", latitude: entity.latitude, longitude: entity.longitude, lineup: lineup, closestAirport: entity.closestAirport, sortKey: Int(entity.sortKey), flightsPrice: Int(entity.flightsPrice), hotelsPrice: Int(entity.hotelsPrice))
    }
    
    private func convertToArtistEntity(_ artist: SuggestedArtist, category: String, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = ArtistEntity(context: context)
        entity.name = artist.name
        entity.id = artist.id
        entity.imageUrl = artist.imageUrl
        entity.category = category
        
        if category == ContentCategories.recentSearches.rawValue {
            entity.creationDate = Date()
        }
        
        return entity
    }
    
    private func convertToArtist(_ entity: ArtistEntity) -> SuggestedArtist {
        return SuggestedArtist(name: entity.name ?? "", id: entity.id ?? "", imageUrl: entity.imageUrl ?? "")
    }
    
    private func convertToDestinationEntity(_ destination: Destination, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = DestinationEntity(context: context)
        entity.cityName = destination.cityName
        entity.closestAirport = destination.closestAirport
        entity.countryName = destination.countryName
        entity.geoHash = destination.geoHash
        entity.imageUrl = destination.imageUrl
        entity.latitude = destination.latitude
        entity.long_Description = destination.longDescription
        entity.longitude = destination.longitude
        entity.name = destination.name
        entity.short_Description = destination.shortDescription
        
        return entity
    }
    
    private func convertToDestination(_ entity: DestinationEntity) -> Destination {
        return Destination(name: entity.name ?? "", shortDescription: entity.short_Description ?? "", longDescription: entity.long_Description ?? "", imageUrl: entity.imageUrl ?? "", cityName: entity.cityName ?? "", countryName: entity.countryName ?? "", latitude: entity.latitude, longitude: entity.longitude, geoHash: entity.geoHash ?? "", closestAirport: entity.closestAirport ?? "")
    }
    
    private func convertToVenueEntity(_ venue: Venue, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = VenueEntity(context: context)
        entity.address = venue.address
        entity.cityName = venue.cityName
        entity.closestAirport = venue.closestAirport
        entity.countryName = venue.countryName
        entity.id = venue.id
        entity.imageUrl = venue.imageUrl
        entity.latitude = venue.latitude
        entity.longitude = venue.longitude
        entity.name = venue.name
        entity.short_Description = venue.description
        
        return entity
    }
    
    private func convertToVenue(_ entity: VenueEntity) -> Venue {
        return Venue(id: entity.id ?? "", name: entity.name ?? "", imageUrl: entity.imageUrl ?? "", description: entity.short_Description ?? "", cityName: entity.cityName ?? "", countryName: entity.countryName ?? "", latitude: entity.latitude, longitude: entity.longitude, address: entity.address ?? "", closestAirport: entity.closestAirport ?? "")
    }
    
    private func convertToNotificationEntity(_ notification: SavedNotification, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = SavedNotificationEntity(context: context)
        entity.type = notification.type
        entity.artistName = notification.artistName
        entity.deepLink = notification.deepLink
        entity.date = notification.date
        return entity
    }
    
    private func convertToNotification(_ entity: SavedNotificationEntity) -> SavedNotification {
        return SavedNotification(type: entity.type ?? "", artistName: entity.artistName ?? "", deepLink: entity.deepLink ?? "", date: entity.date ?? Date())
    }
}
