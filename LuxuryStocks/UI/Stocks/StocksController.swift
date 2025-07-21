//
//  StocksController.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit

class StocksController: UIViewController {
    
    private let stocksViewModel = StocksViewModel()
    
    var currentStocks: [StocksEntity] = []
    
    // MARK: - View groups
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var stocksView: UIView!
    
    @IBOutlet weak var suggestingsView: UIView!
    
    // MARK: - Search bar
    
    // MARK: - Stocks list
    
    @IBOutlet weak var stocksTableView: UITableView!
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    @IBOutlet weak var nowLoadingIndicator: UIActivityIndicatorView!
        
    // MARK: - Search suggestings
    
    @IBOutlet weak var suggestionsBox: SuggestionsBoxView!
    
    @IBOutlet weak var searchHistoryBox: SuggestionsBoxView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowLoadingIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        fetchStocks()
        
        suggestionsBox.appendSuggestion(text: "Apple")
        suggestionsBox.appendSuggestion(text: "Amazon")
        suggestionsBox.appendSuggestion(text: "Google")
        suggestionsBox.appendSuggestion(text: "Tesla")
        suggestionsBox.appendSuggestion(text: "Microsoft")
        suggestionsBox.appendSuggestion(text: "First Solar")
        suggestionsBox.appendSuggestion(text: "Alibaba")
        suggestionsBox.appendSuggestion(text: "Facebook")
        suggestionsBox.appendSuggestion(text: "Mastercard")
        
        searchHistoryBox.appendSuggestion(text: "Nvidia")
        searchHistoryBox.appendSuggestion(text: "Nokia")
        searchHistoryBox.appendSuggestion(text: "Yandex")
        searchHistoryBox.appendSuggestion(text: "GM")
        searchHistoryBox.appendSuggestion(text: "Microsoft")
        searchHistoryBox.appendSuggestion(text: "Baidu")
        searchHistoryBox.appendSuggestion(text: "Intel")
        searchHistoryBox.appendSuggestion(text: "AMD")
        searchHistoryBox.appendSuggestion(text: "Visa")
        searchHistoryBox.appendSuggestion(text: "Bank of America")
    }
    
    // MARK: - Fetching stocks
    
    private func fetchStocks() {
        nowLoadingIndicator.isHidden = false
        
        stocksViewModel.fetchStocks()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
        }, receiveValue: { stocks in
            self.updateStocks(stocks: stocks)
        }).store(in: &stocksViewModel.subscriptions)
    }
    
    private func updateStocks(stocks: [StocksEntity]) {
        //stocksViewModel.fetchImageForStocks(for: stocks[0].symbol, with: stocks[0].logo)
        
        //print(stocks)
        nowLoadingIndicator.isHidden = true
        
        currentStocks = stocks
        emptyListLabel.isHidden = !currentStocks.isEmpty
        
        stocksTableView.reloadData()
    }
    
    // MARK: - Stocks images
    
    func fetchStocksImageIfNeeded(stocksIndex: Int) {
        stocksViewModel.fetchImageForStocks(for: currentStocks[stocksIndex].symbol, with: currentStocks[stocksIndex].logo)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
        }, receiveValue: { image in
            //print("\(self.currentStocks[stocksIndex].logo) \(stocksIndex)")
            
            self.currentStocks[stocksIndex].stocksImage = image
            
            //DispatchQueue.main.async {
            //self.stocksTableView.reloadRows(at: [IndexPath(row: stocksIndex, section: 0)], with: .fade)
            self.stocksTableView.reloadData()
            //}
            
            //self.updateStocks(stocks: stocks)
        }).store(in: &stocksViewModel.subscriptions)
        
        //stocksViewModel.fetchImageForStocks(for: currentStocks[stocksIndex].symbol, with: currentStocks[stocksIndex].logo)
    }
    
    // MARK: - Alerts
    
    
}

