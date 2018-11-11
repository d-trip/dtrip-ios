import UIKit

struct PostViewModel {
    let avatarImage: UIImage
    let userName: String
    let date: String
    let postImage: UIImage
    let location: String
    let status: String
    let title: String
    let description: String
}

final class PostView: UIView {

    // MARK: - UI properties

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        return avatarImageView
    }()

    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return userNameLabel
    }()

    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        dateLabel.textColor = .middleGray
        return dateLabel
    }()

    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        return postImageView
    }()

    private lazy var locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.numberOfLines = 2
        locationLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        locationLabel.textColor = .white
        self.configureShadow(for: locationLabel)
        return locationLabel
    }()

    private lazy var statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        statusLabel.setContentHuggingPriority(.required, for: .horizontal)
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.configureShadow(for: statusLabel)
        return statusLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return titleLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.textColor = .boulder
        return descriptionLabel
    }()

    private lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()

    private lazy var shadowView: UIView = {
        let shadowView = UIView()
        return shadowView
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .alto
        return separatorView
    }()

    private lazy var likeButton: UIButton = {
        let likeButton = UIButton(type: .custom)
        likeButton.setImage(UIImage.Feed.Post.likeButton, for: .normal)
        return likeButton
    }()

    private lazy var shareButton: UIButton = {
        let shareButton = UIButton(type: .custom)
        shareButton.setImage(UIImage.Feed.Post.shareButton, for: .normal)
        return shareButton
    }()

    // MARK: - Configure

    func configure(_ postViewModel: PostViewModel) {
        avatarImageView.image = postViewModel.avatarImage
        userNameLabel.text = postViewModel.userName
        dateLabel.text = postViewModel.date
        postImageView.image = postViewModel.postImage
        locationLabel.text = postViewModel.location
        statusLabel.text = postViewModel.status
        titleLabel.text = postViewModel.title
        descriptionLabel.text = postViewModel.description
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    // MARK: - Setup

    private func setupView() {
        setupSubviews()
        setupConstraints()
        setupImageViewRoundedCorners()
        setupShadowForFooterPost()
        setupAvatarShadow()
    }

    private func setupSubviews() {
        [
            postImageView,
            locationLabel,
            statusLabel,
            titleLabel,
            descriptionLabel,
            separatorView,
            likeButton,
            shareButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        [
            shadowView,
            contentView,
            avatarImageView,
            userNameLabel,
            dateLabel,

        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }

    private func setupShadowForFooterPost() {
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.backgroundColor = UIColor.white.cgColor
        shadowView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        shadowView.layer.cornerRadius = Constants.postCornerRadius

    }

    private func setupImageViewRoundedCorners() {
        contentView.layer.cornerRadius = Constants.postCornerRadius
        contentView.clipsToBounds = true
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func configureShadow(for label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.layer.shadowRadius = 2
    }

    private func setupAvatarShadow() {
        avatarImageView.layer.cornerRadius = Constants.avatarCornerRadius
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner,
        ]
    }

    private func setupConstraints() {
        let constraints = [
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),

            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Spaces.single),

            dateLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            contentView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Spaces.single),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),

            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            locationLabel.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: -Spaces.single),
            locationLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -Spaces.double),

            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            statusLabel.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Spaces.single),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.single),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spaces.single),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.nonuple),

            shadowView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            separatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spaces.double),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            likeButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.single),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            shareButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.single),
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: Spaces.double),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Constants

    private enum Constants {
        static let postCornerRadius: CGFloat = 8
        static let avatarCornerRadius: CGFloat = 15
    }
}
