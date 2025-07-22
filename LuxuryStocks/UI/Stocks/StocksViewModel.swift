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
    
    func fetchStocks() -> PassthroughSubject<[StocksEntity], Error> {
        let stocksPublisher = PassthroughSubject<[StocksEntity], Error>()
        
        let configutation = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        
        if let realm = try? Realm(configuration: configutation) {
            let realmPublisher = PassthroughSubject<Realm, Error>()
            
            Publishers.Zip(
                fetchStockData(),
                fetchCachedStocks(realmPublisher: realmPublisher)
            ).sink(receiveCompletion: { _ in
            }, receiveValue: { apiData, cachedData in
                let stocksData: [StocksEntity] = apiData.map { originalStocks in
                    originalStocks.isFavorite = cachedData.first { $0.symbol == originalStocks.symbol }?.isFavorite == true
                    return originalStocks
                }
                
                //print(stocksData)
                //print(cachedData)
                
                stocksPublisher.send(stocksData)
            }).store(in: &subscriptions)
            
            realmPublisher.send(realm)
        }
        
        return stocksPublisher
    }
    
    func fetchStockData() -> AnyPublisher<[StocksEntity], Error> {
        if let stocksURL = Bundle.main.infoDictionary?["Stocks URL"] as? String, let url = URL(string: stocksURL) {
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: [StocksEntity].self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
        } else {
            return Fail<[StocksEntity], Error>(error: URLError(.badURL)).eraseToAnyPublisher()
        }
    }
    
    func fetchCachedStocks(realmPublisher: PassthroughSubject<Realm, Error>) -> AnyPublisher<[StocksEntity], Error> {
        let publisher = realmPublisher.map { realm in
            return Array(realm.objects(StocksEntity.self))
        }.eraseToAnyPublisher()
        
        return publisher
    }
    
    // MARK: - Stocks images
    
    func fetchImageForStocks(for symbol: String, with url: String) -> PassthroughSubject<UIImage?, Error> {
        let stocksImagesPublisher = PassthroughSubject<UIImage?, Error>()
        
        let imagePublisher = PassthroughSubject<String, Error>()
        
        //print(url)
        
        if let url = URL(string: url) {
        
            Publishers.Zip(
                fetchImageData(for: symbol, url: url),
                fetchCachedImage(imagePublisher: imagePublisher)
            ).sink(receiveCompletion: { _ in
            }, receiveValue: { apiImage, cachedImage in
                //print(apiImage)
                //print(cachedImage)
                
                stocksImagesPublisher.send(apiImage)
            }).store(in: &subscriptions)
        } else {
            
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
        
    }
    
    private func cachedImage(for symbol: String) -> UIImage? {
        return UIImage()
    }
}
