import UIKit
import Kingfisher
import RxCocoa
import RxSwift

final class PostViewController: UIViewController {

    private(set) var viewModel: PostViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - UI properties

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.delegate = self
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
        statusLabel.textColor = .schoolBusYellow
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

    private lazy var navigationBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dismissButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.Common.whiteRoundCross, for: .normal)
        view.tintColor = .white
        return view
    }()

    private var navigationBarOffset: CGFloat {
        return scrollView.contentOffset.y + navigationBar.frame.maxY
    }

    // MARK: - Managing the Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navigationBarOffset > locationLabel.frame.minY {
            return .default
        } else {
            return .lightContent
        }
    }

    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavigationBar()
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

    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.addSubview(dismissButton)
        let constraints = [
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spaces.single),
            dismissButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: Spaces.triple),
            dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Setup content

    func bind(_ viewModel: PostViewModel) {
        self.viewModel = viewModel
        
        rx.viewDidLoad
            .map { PostViewModel.Action.viewDidLoad }
            .bind(to: viewModel.action)
            .disposed(by: self.disposeBag)
        
        dismissButton.rx.controlEvent(.touchUpInside)
            .map { PostViewModel.Action.close }
            .bind(to: viewModel.action)
            .disposed(by: self.disposeBag)
        
        viewModel.state
            .map { $0.postModel }
            .unwrap()
            .subscribe(onNext: { [weak self] postModel in
                self?.handlePostModel(postModel)
            })
            .disposed(by: disposeBag)
        
        viewModel.state
            .map { $0.isLoading }
            .subscribe(onNext: { [weak self] isLoading in
                self?.updateLoadingView(show: isLoading)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateLoadingView(show: Bool) {
        // ToDo: - Add loading view
    }

    private func handlePostModel(_ postModel: PostModel) {
        setupContentHeaderImageView(postModel)
        setupAvatarImageView(postModel)

        userNameLabel.text = postModel.author.name
        dateLabel.text = postModel.timeAgo()
        titleLabel.text = postModel.title
        descriptionLabel.text = postModel.bodyHTML
        locationLabel.text = postModel.location
        statusLabel.text = postModel.category.uppercased()
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
        
        view.kf.indicatorType = .custom(indicator: ImageLoadingIndicator())
        view.kf.setImage(with: imageURL)
    }
}

// MARK: - UIScrollViewDelegate

extension PostViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO: Fix in https://trello.com/c/TYHpkGOL/1-postviewcontroller-custom-navigation-bar
        if navigationBarOffset > locationLabel.frame.minY {
            UIView.animate(withDuration: 0.3) {
                self.navigationBar.backgroundColor = .white
                self.dismissButton.tintColor = .black
                self.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.navigationBar.backgroundColor = .clear
                self.dismissButton.tintColor = .white
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
}
