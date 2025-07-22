//
//  StocksController.swift
//  LuxuryStocks
//
//  Created by johndoe on 7/19/25.
//

import UIKit

class StocksController: UIViewController {
    
    let stocksViewModel = StocksViewModel()
    
    var currentStocks: [StocksEntity] = []
    var filteredStocks: [StocksEntity] = []
    
    var searchText = ""
    
    // MARK: - View groups
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var stocksView: UIView!
    
    @IBOutlet weak var suggestingsView: UIView!
    
    // MARK: - Search bar
    
    @IBOutlet weak var searchField: SearchField!
    
    // MARK: - Stocks list
    
    @IBOutlet weak var stocksTableView: UITableView!
    
    @IBOutlet weak var emptyListLabel: UILabel!
    
    @IBOutlet weak var nowLoadingIndicator: UIActivityIndicatorView!
        
    // MARK: - Search suggestings
    
    @IBOutlet weak var suggestionsBox: SuggestionsBoxView!
    
    @IBOutlet weak var searchHistoryLabel: UILabel!
    
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
            self.updateStocks(stocks: stocks.0)
            
            if stocks.1 {
                self.presentNetworkErrorAlert()
            }
        }).store(in: &stocksViewModel.subscriptions)
    }
    
    private func updateStocks(stocks: [StocksEntity]) {
        //stocksViewModel.fetchImageForStocks(for: stocks[0].symbol, with: stocks[0].logo)
        
        //print(stocks)
        nowLoadingIndicator.isHidden = true
        
        currentStocks = stocks
        reloadListithFilter()
    }
    
    func reloadListithFilter() {
        filteredStocks = currentStocks.filter { self.searchText.isEmpty || ($0.symbol.lowercased().contains(self.searchText.lowercased()) || $0.name.lowercased().contains(self.searchText.lowercased())) }
        emptyListLabel.isHidden = !filteredStocks.isEmpty
        
        stocksTableView.reloadData()
    }
    
    // MARK: - Stocks images
    
    func fetchStocksImageIfNeeded(stocksIndex: Int) {
        stocksViewModel.fetchImageForStocks(for: filteredStocks[stocksIndex].symbol, with: filteredStocks[stocksIndex].logo)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
        }, receiveValue: { image in
            if stocksIndex < self.filteredStocks.count {
                self.filteredStocks[stocksIndex].stocksImage = image
                self.stocksTableView.reloadData()
            }
        }).store(in: &stocksViewModel.subscriptions)
    }
    
    // MARK: - Search history
    
    func fetchSearchHistory() {
        searchHistoryBox.removeAll()
        
        stocksViewModel.fetchSearchHistory()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
        }, receiveValue: { cachedSearches in
            self.searchHistoryLabel.isHidden = cachedSearches.isEmpty
            
            for search in cachedSearches {
                self.searchHistoryBox.appendSuggestion(text: search.search)
            }
        }).store(in: &stocksViewModel.subscriptions)
    }
    
    // MARK: - Alerts
    
    private func presentNetworkErrorAlert() {
        let alertController = UIAlertController(title: "Network Error", message: "Unable to fetch stocks list at this time. Please chack your internet connection", preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}

