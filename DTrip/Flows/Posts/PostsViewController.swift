import UIKit

final class PostsViewController: UIViewController {

    var viewModel: PostsViewModel!

    // MARK: - UI properties

    private lazy var collectionViewController: UICollectionViewController = {
        let collectionViewController = UICollectionViewController(collectionViewLayout: collectionViewFlowLayout)
        return collectionViewController
    }()

    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = Spaces.single
        return collectionViewFlowLayout
    }()

    private var collectionView: UICollectionView {
        return collectionViewController.collectionView
    }

    // MARK: - Data

    private var data: [PostViewModel] = [
        PostViewModel(avatarImage: UIImage.makeColoredImage(.red, size: CGSize(width: 15, height: 15))!,
                      userName: "Jennifer",
                      date: "2 hours ago",
                      postImage: UIImage.makeColoredImage(.red, size: CGSize(width: 171, height: 116))!,
                      location: "Starowiślna 93A, 31-052 Kraków, Poland",
                      status: "ON TRIP",
                      title: "DTrip 0.2 Alfa Update: AskSteem, SPA version, styles",
                      description: "/ipns/dtrip.app/ I am glad to present the next update of the application. Here is a list of changes in this version: Sort by created / trending / hot Search for publications by AskSteem Application tag is now optional first tag SPA version is available now Styles updates: (NavBar, comments, etc, avatars, editor) Sidebar to navigate the application."),
        PostViewModel(avatarImage: UIImage.makeColoredImage(.red, size: CGSize(width: 15, height: 15))!,
                      userName: "Jennifer",
                      date: "2 hours ago",
                      postImage: UIImage.makeColoredImage(.red, size: CGSize(width: 171, height: 116))!,
                      location: "Starowiślna 93A, 31-052 Kraków, Poland",
                      status: "ON TRIP",
                      title: "DTrip 0.2 Alfa Update: AskSteem, SPA version, styles",
                      description: "/ipns/dtrip.app/ I am glad to present the next update of the application. Here is a list of changes in this version: Sort by created / trending / hot Search for publications by AskSteem Application tag is now optional first tag SPA version is available now Styles updates: (NavBar, comments, etc, avatars, editor) Sidebar to navigate the application."),
        PostViewModel(avatarImage: UIImage.makeColoredImage(.red, size: CGSize(width: 15, height: 15))!,
                      userName: "Jennifer",
                      date: "2 hours ago",
                      postImage: UIImage.makeColoredImage(.red, size: CGSize(width: 171, height: 116))!,
                      location: "Starowiślna 93A, 31-052 Kraków, Poland",
                      status: "ON TRIP",
                      title: "DTrip 0.2 Alfa Update: AskSteem, SPA version, styles",
                      description: "/ipns/dtrip.app/ I am glad to present the next update of the application. Here is a list of changes in this version: Sort by created / trending / hot Search for publications by AskSteem Application tag is now optional first tag SPA version is available now Styles updates: (NavBar, comments, etc, avatars, editor) Sidebar to navigate the application."),
    ]

    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(collectionViewController)
        view.addSubview(collectionViewController.view)
        collectionViewController.didMove(toParent: self)

        setupConstraints()
        configureCollectionView(collectionView)
    }

    // MARK: - Setup

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            collectionViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func configureCollectionView(_ collectionView: UICollectionView) {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: Constants.postCellIdentifier)
    }

    // MARK: - Constants

    private enum Constants {
        static let postCellIdentifier = "PostCollectionViewCell"
    }
}

// MARK: - UICollectionViewDataSource

extension PostsViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.postCellIdentifier,
                                                      for: indexPath) as! PostCollectionViewCell
        let post = data[indexPath.row]
        cell.configure(post)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width,
                      height: view.bounds.width * 1.15)
    }
}
