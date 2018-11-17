import UIKit
import Kingfisher

final class PostView: UIView {

    // MARK: - UI properties

    private lazy var avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.kf.indicatorType = .custom(indicator: ImageLoadingIndicator())
        return avatarImageView
    }()

    private lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.numberOfLines = 1
        userNameLabel.lineBreakMode = .byTruncatingTail
        userNameLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return userNameLabel
    }()

    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        dateLabel.textColor = .middleGray
        return dateLabel
    }()

    private lazy var postImageView: UIImageView = {
        let postImageView = UIImageView()
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.kf.indicatorType = .custom(indicator: ImageLoadingIndicator())
        return postImageView
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

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return titleLabel
    }()

    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
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

    func configure(_ postViewModel: PostModel) {
        
        if let profileImage = postViewModel.author.profileImage {
            let profileImageUrl = URL(string: profileImage)
            avatarImageView.kf.setImage(with: profileImageUrl) { [weak self] (image, _, _, url) in
                guard url == profileImageUrl else { return }
                if let image = image {
                    self?.avatarImageView.image = image
                } else {
                    self?.avatarImageView.image = UIImage(named: "noAvatar")
                }
            }
        } else {
            avatarImageView.image = UIImage(named: "noAvatar")
        }
        
        if let postImage = postViewModel.titleImage() {
            let postImageUrl = URL(string: postImage)
            postImageView.kf.setImage(with: postImageUrl) { [weak self] (image, _, _, url) in
                guard url == postImageUrl else { return }
                if let image = image {
                    self?.postImageView.image = image
                } else {
                    self?.postImageView.image = UIImage(named: "noPostImage")
                }
            }
        } else {
            postImageView.image = UIImage(named: "noPostImage")
        }
        userNameLabel.text = postViewModel.author.name
        dateLabel.text = postViewModel.timeAgo()
        locationLabel.text = postViewModel.location
        statusLabel.text = postViewModel.category
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
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: Spaces.quintuple),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),

            shadowView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            shadowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shadowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -Spaces.single),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Spaces.single),
            userNameLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -Spaces.single),
            
            dateLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spaces.single),

            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            locationLabel.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: -Spaces.single),
            locationLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -Spaces.double),

            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            statusLabel.bottomAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: -Spaces.single),

            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: Spaces.double),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.single),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spaces.single),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),

            separatorView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Spaces.double),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spaces.septuple),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Spaces.double),
            
            likeButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.double),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spaces.double),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Spaces.double),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            
            shareButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.double),
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spaces.double),
            shareButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: Spaces.double),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Constants

    private enum Constants {
        static let postCornerRadius: CGFloat = 8
        static let avatarCornerRadius: CGFloat = 16
    }
}
