import UIKit
import Kingfisher
import RxCocoa
import RxSwift
import WebKit

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

    private lazy var descriptionWebView: WKWebView = {
        let webView = PostViewWebViewFactory.makeWebView()
        webView.navigationDelegate = self
        return webView
    }()

    private lazy var separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .alto
        return separatorView
    }()

    private lazy var shareButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage.Feed.Post.shareButton, for: .normal)
        return view
    }()

    private lazy var navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var dismissButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage.Common.whiteRoundCross, for: .normal)
        view.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        view.tintColor = .white
        return view
    }()

    private lazy var topGradientView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(.top)
        return view
    }()

    private lazy var bottomGradientView: GradientView = {
        let view = GradientView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.configure(.bottom)
        return view
    }()

    private lazy var loadingAnimation: LoadingView = {
        let view = LoadingView()
        view.backgroundColor = .clear
        view.sizeAnimation = CGSize(width: Spaces.quadruple, height: Spaces.quadruple)
        return view
    }()

    // MARK: - Animator

    private lazy var animator: UIViewPropertyAnimator = {
        let timingParameters = UICubicTimingParameters(animationCurve: .easeIn)
        let animator = UIViewPropertyAnimator(duration: 0.3,
                                              timingParameters: timingParameters)
        animator.addAnimations { [weak self] in
            guard let self = self else { return }
            self.navigationBar.backgroundColor = .white
            self.dismissButton.tintColor = .black
        }
        animator.startAnimation()
        animator.pauseAnimation()
        return animator
    }()

    // MARK: - NavigationBar interactions

    private var navigationBarAnimationProgress: CGFloat {
        let offset = scrollView.contentOffset.y - locationLabel.frame.minY
        let point = navigationBar.frame.maxY + Spaces.duodecuple
        return (offset + point) / 100.0
    }

    private var isNavigationBarShadowVisible = false

    private var navigationBarOffset: CGFloat {
        return scrollView.contentOffset.y + navigationBar.frame.maxY
    }

    private var navigationBarShadowOffset: CGFloat {
        return bottomContentView.frame.minY
    }

    // MARK: - Constraints

    private lazy var webViewHeightConstraint: NSLayoutConstraint = {
        return self.descriptionWebView.heightAnchor.constraint(equalToConstant: Spaces.octuple)
    }()

    // MARK: - Managing the Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if navigationBarAnimationProgress > 0.4 {
            return .default
        } else {
            return .lightContent
        }
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }

    private func updateStatusBarVisibility() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
    }

    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animator.stopAnimation(true)
    }

    // MARK: - Configuring the View’s Layout Behavior

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNavigationBarShadow()
        updateStatusBarVisibility()
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
            bottomGradientView,
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
            descriptionWebView,
            separatorView,
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

            locationLabel.leadingAnchor.constraint(equalTo: headerImageContainerView.leadingAnchor,
                                                   constant: Spaces.double),
            locationLabel.bottomAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor,
                                                  constant: -Spaces.sextuple),
            locationLabel.trailingAnchor.constraint(equalTo: statusLabel.leadingAnchor, constant: -Spaces.double),

            statusLabel.trailingAnchor.constraint(equalTo: headerImageContainerView.trailingAnchor,
                                                  constant: -Spaces.double),
            statusLabel.bottomAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor,
                                                constant: -Spaces.sextuple),

            bottomContentView.topAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor,
                                                   constant: -Spaces.quadruple),
            bottomContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarImageView.topAnchor.constraint(equalTo: bottomContentView.topAnchor,
                                                 constant: Spaces.quadruple),
            avatarImageView.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor,
                                                     constant: Spaces.double),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),

            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Spaces.single),
            userNameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            dateLabel.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor, constant: -Spaces.quadruple),
            dateLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),

            titleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Spaces.triple),
            titleLabel.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor, constant: Spaces.double),
            titleLabel.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor,
                                                 constant: -Spaces.double),

            descriptionWebView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spaces.double),
            descriptionWebView.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor,
                                                        constant: Spaces.double),
            descriptionWebView.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor,
                                                         constant: -Spaces.double),
            webViewHeightConstraint,

            separatorView.topAnchor.constraint(equalTo: descriptionWebView.bottomAnchor, constant: Spaces.double),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: -Spaces.septuple),
            separatorView.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor,
                                                   constant: Spaces.double),
            separatorView.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor,
                                                    constant: -Spaces.double),

            shareButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Spaces.double),
            shareButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor, constant: -Spaces.double),
            shareButton.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor, constant: Spaces.triple),
            shareButton.widthAnchor.constraint(equalTo: shareButton.heightAnchor),

            bottomGradientView.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -Spaces.triple),
            bottomGradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomGradientView.bottomAnchor.constraint(equalTo: headerImageContainerView.bottomAnchor),
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func configureShadow(for label: UILabel) {
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 0.6
        label.layer.shadowRadius = 1.5
    }

    private func setupNavigationBar() {
        view.addSubview(topGradientView)
        view.addSubview(navigationBar)
        navigationBar.addSubview(dismissButton)
        let constraints = [
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),

            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spaces.single),
            dismissButton.leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor, constant: Spaces.triple),
            dismissButton.widthAnchor.constraint(equalToConstant: Spaces.quadruple),
            dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor),

            topGradientView.topAnchor.constraint(equalTo: view.topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topGradientView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                    constant: Spaces.octuple),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupNavigationBarShadow() {
        let roundedRect = CGRect(x: (navigationBar.bounds.origin.x - (Spaces.double / 2)),
                                 y: navigationBar.bounds.origin.y,
                                 width: navigationBar.bounds.size.width + Spaces.double,
                                 height: navigationBar.bounds.size.height)
        let shadowPath = UIBezierPath(roundedRect: roundedRect,
                                      byRoundingCorners: [.bottomLeft, .bottomRight],
                                      cornerRadii: CGSize(width: 0, height: 3))
        navigationBar.layer.shadowPath = shadowPath.cgPath
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOpacity = 0
        navigationBar.layer.shadowRadius = 5
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
        print("\(#function) show \(show) bottomContentView.frame = \(bottomContentView.frame)")
        if show {
            loadingAnimation.startAnimation(for: bottomContentView)
        } else {
            loadingAnimation.stopAnimation(animate: false)
        }
    }

    private func handlePostModel(_ postModel: PostModel) {
        print("\(#function)")
        descriptionWebView.loadHTMLString(postModel.bodyHTML, baseURL: nil)
        setupContentHeaderImageView(postModel)
        setupAvatarImageView(postModel)

        userNameLabel.text = postModel.author.name
        dateLabel.text = postModel.timeAgo()
        titleLabel.text = postModel.title
        locationLabel.text = postModel.location
        statusLabel.text = postModel.category.uppercased()
    }

    private func setupContentHeaderImageView(_ postModel: PostModel) {
        let headerImage = postModel.titleImage() ?? ""
        let headerImageURL = URL(string: headerImage)
        headerImageView.kf.indicatorType = .custom(indicator: ImageLoadingIndicator())
        headerImageView.kf.setImage(with: headerImageURL,
                                    placeholder: UIImage.EmptyState.post)
    }

    private func setupAvatarImageView(_ postModel: PostModel) {
        let profileImage = postModel.author.profileImage ?? ""
        let profileImageUrl = URL(string: profileImage)
        avatarImageView.kf.setImage(with: profileImageUrl,
                                    placeholder: UIImage.EmptyState.avatar)
    }

    // MARK: - NavigationBar shadow configuring

    private func updateNavigationBarShadow() {
        let key = "shadowOpacity"

        if navigationBarOffset > navigationBarShadowOffset {
            if isNavigationBarShadowVisible == false {
                isNavigationBarShadowVisible = true
                let animation = CABasicAnimation(keyPath: key)
                animation.fromValue = 0.0
                animation.toValue = 0.5
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                animation.duration = 0.3
                navigationBar.layer.removeAnimation(forKey: key)
                navigationBar.layer.add(animation, forKey: key)
            }
        } else {
            if isNavigationBarShadowVisible {
                let animation = CABasicAnimation(keyPath: key)
                isNavigationBarShadowVisible = false
                animation.fromValue = 0.5
                animation.toValue = 0.0
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                animation.duration = 0.3
                navigationBar.layer.removeAnimation(forKey: key)
                navigationBar.layer.add(animation, forKey: key)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate

extension PostViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animator.fractionComplete = navigationBarAnimationProgress
        updateStatusBarVisibility()
        updateNavigationBarShadow()
    }
}

// MARK: - WKNavigationDelegate

extension PostViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        descriptionWebView.evaluateJavaScript(
            "document.readyState",
            completionHandler: { [weak self] (complete, error) in
                guard let self = self else { return }
                if complete != nil {
                    self.descriptionWebView.evaluateJavaScript(
                        "document.body.scrollHeight",
                        completionHandler: { (height, error) in
                            guard let height = height as? CGFloat else { return }
                            self.webViewHeightConstraint.constant = height
                        })
                }
            })
    }

    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType == .other || navigationAction.navigationType == .reload else {
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
