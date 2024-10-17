//
//  CharacterListViewController.swift
//  Characters
//
//  Created by Mohamed Sayed on 14/10/2024.
//

import UIKit
import SwiftUI
import Combine

class CharacterListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let emptyStateLabel = UILabel()
    private var collectionView: UICollectionView!
    
    // MARK: - ViewModel and Data
    var viewModel = CharacterListViewModel()
    private var cancellables: Set<AnyCancellable> = []
    var coordinator: CharacterListCoordinator?
    
    // Collection View properties
    let filterOptions = ["Alive", "Dead", "Unknown"]
    private var selectedFilter: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchCharacters() 
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        title = "Characters"
        setupCollectionView()
        setupTableView()
        setupEmptyStateLabel()
    }
    
    // MARK: - Setup Collection View for Filters
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 40)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: Constants.filterCellReuseID)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Setup Table View
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.characterCellReuseID)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Empty State Label
    private func setupEmptyStateLabel() {
        emptyStateLabel.text = "No characters found."
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        emptyStateLabel.isHidden = true
        view.addSubview(emptyStateLabel)
        
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                self?.updateUI(characters: characters)
                self?.checkIfMoreDataIsNeeded()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    print("Loading characters...")
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showError(message: errorMessage)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Helper Methods
    private func checkIfMoreDataIsNeeded() {
        let contentHeight = tableView.contentSize.height
        let tableHeight = tableView.frame.size.height
        if contentHeight < tableHeight && !viewModel.isLoading {
            viewModel.fetchCharacters()  // Load more if there's empty space
        }
    }
    
    private func updateUI(characters: [Character]) {
        emptyStateLabel.isHidden = !characters.isEmpty
        collectionView.isHidden = characters.isEmpty
        tableView.reloadData()
    }
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.characterCellReuseID, for: indexPath)
        
        let character = viewModel.characters[indexPath.row]
        cell.selectionStyle = .none
        cell.contentConfiguration = UIHostingConfiguration {
            CharacterCellView(character: character)
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.characters[indexPath.row]
        coordinator?.showCharacterDetail(character: character)
    }
    
    // MARK: - ScrollView Delegate (Pagination)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let contentHeight = tableView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        
        if position > (contentHeight - 100 - scrollHeight) && !viewModel.isLoading {
            viewModel.fetchCharacters(by: selectedFilter)
        }
    }
    
    // MARK: - CollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.filterCellReuseID, for: indexPath) as? FilterCollectionViewCell else {
            fatalError("Unable to dequeue FilterCollectionViewCell")
        }
        let isSelected = (selectedFilter == filterOptions[indexPath.item].lowercased())
        cell.configure(with: filterOptions[indexPath.item], isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilter = filterOptions[indexPath.item].lowercased()
        viewModel.filterCharacters(by: selectedFilter)
        collectionView.reloadData()
    }
}
