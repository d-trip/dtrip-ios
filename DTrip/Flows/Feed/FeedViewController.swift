//
//  FeedViewController.swift
//  DTrip
//
//  Created by Artem Semavin on 20/10/2018.
//  Copyright © 2018 Semavin Artem. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DifferenceKit

final class FeedViewController: UIViewController {
    
    //MARK: - Private properties
    
    private(set) var viewModel: FeedViewModel!
    private let disposeBag = DisposeBag()
    private var postItems: [PostModel] = []
    
    // MARK: - UI properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = footerLoadingAnimation
        tableView.contentInset.bottom = Spaces.duodecuple
        return tableView
    }()
    
    private lazy var footerLoadingAnimation: LoadingView = {
        let view = LoadingView()
        view.sizeAnimation = CGSize(width: Spaces.quadruple, height: Spaces.quadruple)
        return view
    }()
    
    private lazy var loadingAnimation: LoadingView = {
        let view = LoadingView()
        return view
    }()
    
    // MARK: - Binding
    
    func bind(_ viewModel: FeedViewModel) {
        self.viewModel = viewModel
        
        rx.viewDidLoad
            .map { FeedViewModel.Action.viewDidLoad }
            .bind(to: viewModel.action)
            .disposed(by: self.disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.setDataSource(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { FeedViewModel.Action.selectModel($0.row) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $0.indexPath }
            .withLatestFrom(viewModel.state) { $0.row == $1.postItems.count - 1 }
            .filter { $0 }
            .map { _ in FeedViewModel.Action.scrollToBottom }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.postItems }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] postItems in
                guard let self = self else { return }
                let diffs = StagedChangeset(source: self.postItems, target: postItems)
                self.tableView.reload(using: diffs, with: .none) { postItems in
                    self.postItems = postItems
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.isLoading }
            .delay(0.2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoading in
                self?.updateLoadingView(show: isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Lifecycle
 
    override func loadView() {
        super.loadView()
        setupViews()
        setupConstraints()
    }

    // MARK: - Setup
    
    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViews() {
        setupTableView(tableView)
        view.backgroundColor = .white
        
        let loadingViewSize = CGSize(width: tableView.bounds.width, height: Spaces.duodecuple)
        loadingAnimation.frame = CGRect(origin: .zero, size: loadingViewSize)
    }
    
    private func setupTableView(_ tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Spaces.octuple
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.decelerationRate = .normal
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Spaces.quadruple, right: 0)
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.postCellIdentifier)
        
        view.addSubview(tableView)
    }

    private func updateLoadingView(show: Bool) {
        if show {
            loadingAnimation.startAnimation(for: view)
        } else {
            loadingAnimation.stopAnimation()
        }
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard postItems.indices.contains(indexPath.row) else { return UITableViewCell() }
        let item = postItems[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellIdentifier,
                                                    for: indexPath) as? PostTableViewCell {
            cell.configure(item)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - Constants

extension FeedViewController {
    private enum Constants {
        static let postCellIdentifier = "PostCollectionViewCell"
    }
}
