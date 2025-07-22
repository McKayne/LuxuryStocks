//
//  StocksViewModel.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit
import Combine
import RealmSwift

class StocksViewModel {
    
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Stocks list
    
    func fetchStocks() -> PassthroughSubject<([StocksEntity], Bool), Error> {
        let stocksPublisher = PassthroughSubject<([StocksEntity], Bool), Error>()
        
        let configutation = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        if let stocksURL = Bundle.main.infoDictionary?["Stocks URL"] as? String, let url = URL(string: stocksURL), let realm = try? Realm(configuration: configutation) {
            let realmPublisher = PassthroughSubject<Realm, Error>()
            
            Publishers.Zip(
                fetchStockData(url: url),
                fetchCachedStocks(realmPublisher: realmPublisher)
            ).receive(on: RunLoop.main)
                .sink(receiveCompletion: { _ in
            }, receiveValue: { apiStocks, cachedStocks in
                
                if let apiStocks = apiStocks {
                    let stocks: [StocksEntity]
                    
                    if let cachedStocks = cachedStocks {
                        stocks = apiStocks.map { originalStocks in
                            originalStocks.isFavorite = cachedStocks.first { $0.symbol == originalStocks.symbol }?.isFavorite == true
                            return originalStocks
                        }
                    } else {
                        stocks = apiStocks
                    }
                    
                    self.saveStocksToCache(stocks: stocks, to: realm)
                    stocksPublisher.send((stocks, false))
                } else {
                    if let cachedStocks = cachedStocks {
                        stocksPublisher.send((cachedStocks, true))
                    }
                }
            }).store(in: &subscriptions)
            
            realmPublisher.send(realm)
        }
        
        return stocksPublisher
    }
    
    func fetchStockData(url: URL) -> AnyPublisher<[StocksEntity]?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [StocksEntity]?.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<[StocksEntity]?, Never> in
                return Just(nil).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCachedStocks(realmPublisher: PassthroughSubject<Realm, Error>) -> AnyPublisher<[StocksEntity]?, Never> {
        let publisher = realmPublisher.map { realm in
            return Array(realm.objects(StocksEntity.self))
        }.catch { error -> AnyPublisher<[StocksEntity]?, Never> in
            return Just(nil).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        return publisher
    }
    
    // MARK: - Stocks images
    
    func fetchImageForStocks(for symbol: String, with url: String) -> PassthroughSubject<UIImage?, Error> {
        let stocksImagesPublisher = PassthroughSubject<UIImage?, Error>()
        
        let imagePublisher = PassthroughSubject<String, Error>()
        
        if let url = URL(string: url) {
        
            Publishers.Zip(
                fetchImageData(for: symbol, url: url),
                fetchCachedImage(imagePublisher: imagePublisher)
            ).sink(receiveCompletion: { _ in
            }, receiveValue: { apiImage, cachedImage in
                if let apiImage = apiImage {
                    stocksImagesPublisher.send(apiImage)
                } else if let cachedImage = cachedImage {
                    stocksImagesPublisher.send(cachedImage)
                } else {
                    stocksImagesPublisher.send(nil)
                }
            }).store(in: &subscriptions)
        }
        
        imagePublisher.send(symbol)
        
        return stocksImagesPublisher
    }
    
    func fetchImageData(for symbol: String, url: URL) -> AnyPublisher<UIImage?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .map { data in
                let image = UIImage(data: data)
                if image != nil {
                    self.saveImageToCache(for: symbol, data: data)
                }
                return image
            }
            .catch { error -> AnyPublisher<UIImage?, Never> in
                return Just(nil).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCachedImage(imagePublisher: PassthroughSubject<String, Error>) -> AnyPublisher<UIImage?, Never> {
        let publisher = imagePublisher.map { symbol in
            return self.cachedImage(for: symbol)
        }.catch { error -> AnyPublisher<UIImage?, Never> in
            return Just(nil).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
        
        return publisher
    }
    
    private func saveImageToCache(for symbol: String, data: Data) {
        if let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsURL = URL(fileURLWithPath: documentsDirectory)
            let imageURL = documentsURL.appendingPathComponent(symbol + ".jpg")
            
            do {
                try data.write(to: imageURL)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    private func cachedImage(for symbol: String) -> UIImage? {
        var image: UIImage?
        
        if let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let documentsURL = URL(fileURLWithPath: documentsDirectory)
            let imageURL = documentsURL.appendingPathComponent(symbol + ".jpg")
            
            if FileManager.default.fileExists(atPath: imageURL.path) {
                do {
                    let data = try Data(contentsOf: imageURL)
                    image = UIImage(data: data)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        
        return image
    }
    
    // MARK: - Search history
    
    func fetchSearchHistory() -> PassthroughSubject<[SearchEntity], Error> {
        let searchPublisher = PassthroughSubject<[SearchEntity], Error>()
        
        let configutation = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        if let realm = try? Realm(configuration: configutation) {
            let realmPublisher = PassthroughSubject<Realm, Error>()
            
            fetchCachedSearches(realmPublisher: realmPublisher)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { _ in
            }, receiveValue: { cachedSearches in
                
                if let cachedSearches = cachedSearches {
                    searchPublisher.send(cachedSearches)
                } else {
                    searchPublisher.send([])
                }
            }).store(in: &subscriptions)
            
            realmPublisher.send(realm)
        }
        
        return searchPublisher
    }
    
    func fetchCachedSearches(realmPublisher: PassthroughSubject<Realm, Error>) -> AnyPublisher<[SearchEntity]?, Never> {
        let publisher = realmPublisher.map { realm in
            return Array(realm.objects(SearchEntity.self))
        }.catch { error -> AnyPublisher<[SearchEntity]?, Never> in
            return Just(nil).eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        return publisher
    }
    
    // MARK: - Database
    
    private func saveStocksToCache(stocks: [StocksEntity], to realm: Realm) {
        do {
            try realm.write {
                realm.add(stocks, update: .modified)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func changeFavoritesState(entity: StocksEntity) -> StocksEntity {
        let configutation = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        if let realm = try? Realm(configuration: configutation) {
            do {
                try realm.write {
                    let isFavorite = entity.isFavorite ?? false
                    entity.isFavorite = !isFavorite
                    
                    realm.add(entity, update: .modified)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return entity
    }
    
    func saveSearch(text: String) {
        let configutation = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        if let realm = try? Realm(configuration: configutation) {
            do {
                try realm.write {
                    let search = SearchEntity()
                    search.search = text
                    
                    realm.add(search, update: .modified)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
