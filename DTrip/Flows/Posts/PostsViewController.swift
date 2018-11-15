import UIKit
import RxCocoa
import DifferenceKit

final class PostsViewController: UIViewController {

    var viewModel: PostsViewModel!
    private var postItems: [PostItem] = []
    
    // MARK: - UI properties
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        let screenWidth = UIScreen.main.bounds.width
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = Spaces.single
        return collectionViewFlowLayout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
        return collectionView
    }()
    
    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView(collectionView)
        setupConstraints()
        
        setupRx()
    }

    // MARK: - Setup

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func configureCollectionView(_ collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: Constants.postCellIdentifier)
        collectionView.register(PostCollectionViewLoadingCell.self, forCellWithReuseIdentifier: Constants.postCellLoadingIdentifier)
        collectionView.register(PostCollectionViewErrorCell.self, forCellWithReuseIdentifier: Constants.postCellErrorIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func setupRx() {
        viewModel.posts
            .drive(onNext: { [weak self] target in
                guard let strongSelf = self else { return }
                let diffs = StagedChangeset(source: strongSelf.postItems, target: target)
                strongSelf.collectionView.reload(using: diffs) { postItems in
                    strongSelf.postItems = postItems
                }
            })
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - UICollectionViewDataSource

extension PostsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard postItems.indices.contains(indexPath.row) else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.postCellErrorIdentifier,
                                                      for: indexPath)
        }
        let item = postItems[indexPath.row]
        
        switch item {
        case .postItem(post: let post):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.postCellIdentifier,
                                                          for: indexPath) as! PostCollectionViewCell
            cell.configure(post)
            return cell
        case .errorItem(title: _):
            return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.postCellErrorIdentifier,
                                                      for: indexPath)
        case .loadingItem(title: _, animate: _):
            return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.postCellLoadingIdentifier,
                                                      for: indexPath)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard postItems.indices.contains(indexPath.row) else {
            return CGSize.zero
        }
        let item = postItems[indexPath.row]
        
        let insets = collectionView.contentInset
        let width = UIScreen.main.bounds.width - (insets.left + insets.right)
        
        switch item {
        case .postItem(post: let model):
            let height = cellHeight(model: model, with: width)
            return CGSize(width: width, height: height)
        default:
            return CGSize(width: width, height: Spaces.octuple)
        }
    }
    
    func cellHeight(model: PostModel, with width: CGFloat) -> CGFloat {
        let bodyWidth = width - Spaces.octuple
        
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: bodyWidth, height: CGFloat.greatestFiniteMagnitude)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionLabel.text = model.description
        descriptionLabel.sizeToFit()
        
        let descriptionHeight = descriptionLabel.frame.height
        let titleHeight = model.title.height(withConstrainedWidth: bodyWidth,
                                             font: UIFont.preferredFont(forTextStyle: .subheadline))
        let footerHeight: CGFloat = Spaces.septuple
        let avatarHeight: CGFloat = Spaces.quintuple
        let imageHeight: CGFloat  = width * 0.6
        
        return avatarHeight +
            imageHeight +
            Spaces.double +
            titleHeight +
            Spaces.single +
            descriptionHeight +
            Spaces.double +
            footerHeight +
            Spaces.double
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
