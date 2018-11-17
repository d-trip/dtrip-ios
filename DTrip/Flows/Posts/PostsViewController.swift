import UIKit
import RxCocoa
import DifferenceKit

final class PostsViewController: UIViewController {

    var viewModel: PostsViewModel!
    private var postItems: [PostItem] = []
    
    // MARK: - UI properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView(tableView)
        setupConstraints()
        
        setupRx()
    }

    // MARK: - Setup

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func configureTableView(_ tableView: UITableView) {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Spaces.octuple
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.postCellIdentifier)
        tableView.register(PostTableViewLoadingCell.self, forCellReuseIdentifier: Constants.postCellLoadingIdentifier)
        tableView.register(PostTableViewErrorCell.self, forCellReuseIdentifier: Constants.postCellErrorIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
    }
    
    private func setupRx() {
        viewModel.posts
            .drive(onNext: { [weak self] target in
                guard let strongSelf = self else { return }
                let diffs = StagedChangeset(source: strongSelf.postItems, target: target)
                strongSelf.tableView.reload(using: diffs, with: .bottom) { postItems in
                    strongSelf.postItems = postItems
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard postItems.indices.contains(indexPath.row) else {
            return tableView.dequeueReusableCell(withIdentifier: Constants.postCellErrorIdentifier,
                                                 for: indexPath)
        }
        let item = postItems[indexPath.row]
        
        switch item {
        case .postItem(post: let post):
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.postCellIdentifier,
                                                     for: indexPath) as! PostTableViewCell
            cell.configure(post)
            return cell
        case .errorItem(title: _):
            return tableView.dequeueReusableCell(withIdentifier: Constants.postCellErrorIdentifier,
                                                 for: indexPath)
        case .loadingItem(title: _, animate: _):
            return tableView.dequeueReusableCell(withIdentifier: Constants.postCellLoadingIdentifier,
                                                 for: indexPath)
        }
    }
}

// MARK: - Constants

extension PostsViewController {
    private enum Constants {
        static let postCellIdentifier = "PostCollectionViewCell"
        static let postCellLoadingIdentifier = "PostCollectionViewLoadingCell"
        static let postCellErrorIdentifier = "PostCollectionViewErrorCell"
    }
}
