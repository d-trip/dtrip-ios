import UIKit
import Kingfisher
import RxCocoa
import RxSwift

final class PostViewController: UIViewController {

    var viewModel: PostViewModel!

    // MARK: - UI properties

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.contentInsetAdjustmentBehavior = .never
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var headerImageContainerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var headerImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "noPostImage")
        return view
    }()

    private lazy var bottomContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
        ]
        view.layer.cornerRadius = 30
        return view
    }()

    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 16
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "noAvatar")
        return view
    }()

    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.numberOfLines = 2
        let fontSize = UIFont.preferredFont(forTextStyle: .subheadline).pointSize
        locationLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        locationLabel.textColor = .white
        self.configureShadow(for: locationLabel)
        return locationLabel
    }()

    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.textColor = .white
        statusLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.configureShadow(for: statusLabel)
        return statusLabel
    }()


    private lazy var userNameLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.lineBreakMode = .byTruncatingTail
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return view
    }()

    private lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.preferredFont(forTextStyle: .footnote)
        view.textColor = .middleGray
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = UIFont.preferredFont(forTextStyle: .footnote)
        view.textColor = .boulder
        return view
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .alto
        return separatorView
    }()

    private lazy var likeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage.Feed.Post.likeButton, for: .normal)
        return view
    }()

    private lazy var shareButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage.Feed.Post.shareButton, for: .normal)
        return view
    }()

    // MARK: - Managing the Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()

        setupRx()
    }

    // MARK: - SetupView

    private func setupView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        [
            headerImageContainerView,
            bottomContentView,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [
            headerImageView,
            locationLabel,
            statusLabel,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerImageContainerView.addSubview($0)
        }

        [
            avatarImageView,
            userNameLabel,
            dateLabel,
            titleLabel,
            descriptionLabel,
            separatorView,
            likeButton,
            shareButton,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bottomContentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            headerImageContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerImageContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImageContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),

            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: headerImageContainerView.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: headerImageContainerView.trailingAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor),

            locationLabel.leadingAnchor.constraint(equalTo: headerImageContainerView.leadingAnchor, constant: Spaces.double),
            locationLabel.bottomAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor, constant: -Spaces.sextuple),
            locationLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -Spaces.double),

            statusLabel.trailingAnchor.constraint(equalTo: headerImageContainerView.trailingAnchor, constant: -Spaces.double),
            statusLabel.bottomAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor, constant: -Spaces.sextuple),

            bottomContentView.topAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor,
                                                   constant: -Spaces.quadruple),
            bottomContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarImageView.topAnchor.constraint(equalTo: bottomContentView.topAnchor,
                                                 constant: Spaces.quadruple),
            avatarImageView.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor,
                                                     constant: Spaces.quadruple),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),

            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Spaces.single),
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor, constant: -Spaces.quadruple),
            dateLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Spaces.triple),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor, constant: Spaces.quadruple),
            titleLabel.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor,
                                                 constant: -Spaces.quadruple),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spaces.double),
            descriptionLabel.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor,
                                                      constant: Spaces.quadruple),
            descriptionLabel.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor,
                                                       constant: -Spaces.quadruple),

            separatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spaces.double),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: -Spaces.septuple),
            separatorView.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor,
                                                   constant: Spaces.quadruple),
            separatorView.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor,
                                                    constant: -Spaces.quadruple),

            likeButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.double),
            likeButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: -Spaces.double),
            likeButton.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor, constant: Spaces.quadruple),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),

            shareButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.double),
            shareButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: -Spaces.double),
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: Spaces.double),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureShadow(for label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 2
    }

    // MARK: - Setup content

    private func setupRx() {
        viewModel.post
            .drive(onNext: { [weak self] item in
                guard let self = self else { return }
                self.setupPostItem(item)
            })
            .disposed(by: viewModel.disposeBag)
    }

    private func setupPostItem(_ postItem: PostItem) {
        switch postItem {
        case let .postItem(postModel):
            handlePostModel(postModel)
        case let .loadingItem(title, animate):
            print(#function)
        default:
            // TODO: Fix it
            fatalError()
        }
    }

    private func handlePostModel(_ postModel: PostModel) {
        setupContentHeaderImageView(postModel)
        setupAvatarImageView(postModel)

        userNameLabel.text = postModel.author.name
        dateLabel.text = postModel.timeAgo()
        titleLabel.text = postModel.title
        descriptionLabel.text = postModel.bodyHTML
        locationLabel.text = postModel.location
        statusLabel.text = postModel.category
    }

    private func setupContentHeaderImageView(_ postModel: PostModel) {
        setupImage(on: headerImageView, with: postModel.titleImage())
    }

    private func setupAvatarImageView(_ postModel: PostModel) {
        setupImage(on: avatarImageView, with: postModel.author.profileImage)
    }

    private func setupImage(on view: UIImageView, with urlString: String?) {
        guard let urlString = urlString else { return }
        let imageURL = URL(string: urlString)
        view.kf.setImage(with: imageURL) { (image, _, _, url) in
            guard url == imageURL else { return }
            if let image = image {
                view.image = image
            }
        }
    }
}
