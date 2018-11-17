import UIKit

final class PostTableViewCell: UITableViewCell {

    private lazy var postView: PostView = {
        let postView = PostView()
        postView.translatesAutoresizingMaskIntoConstraints = false
        return postView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        contentView.directionalLayoutMargins
            = NSDirectionalEdgeInsets(top: Spaces.double,
                                      leading: Spaces.double,
                                      bottom: Spaces.double,
                                      trailing: Spaces.double)
        contentView.addSubview(postView)
        let constraints = [
            postView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            postView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            postView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            postView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configure(_ postViewModel: PostModel) {
        postView.configure(postViewModel)
    }
}
