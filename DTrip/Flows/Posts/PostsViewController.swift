import UIKit
import UIKit.UIGestureRecognizerSubclass
import RxCocoa
import RxSwift
import DifferenceKit

enum PanDirection {
    case up, down
}

final class PostsViewController: UIViewController {

    var viewModel: PostsViewModel!
    private var postItems: [PostItem] = []

    private let panRecognizer = UIPanGestureRecognizer()
    private var animator = UIViewPropertyAnimator()

    private var isOpen = false
    private var animationProgress: CGFloat = 0
    private var closedTransform = CGAffineTransform.identity
    private var openTransform = CGAffineTransform.identity
    private var animatiorTrasform = CGAffineTransform.identity
    
    private var interactionInProgress: Bool = false
    private var initialScrollOffset: CGPoint = CGPoint.zero
    private let offsetThreshold: CGFloat = 5.0 // Optimal value from testing

    // MARK: - UI properties

    private lazy var momentumView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        return view
    }()

    private lazy var handleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 1.5
        return view
    }()

    private lazy var topShadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowOpacity = 0.1
        view.alpha = 0
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: - Managing the View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupRx()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showModule()
    }

    private func showModule() {
        guard !isOpen else { return }
        
        UIView.animate(withDuration: Constants.animationDurationBackground) { [unowned self] in
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            self.momentumView.transform = .identity
        }
    }

    private func closeModule() {
        dismiss(animated: false, completion: nil)
    }

    // MARK: - Setup

    private func setupConstraints() {
        let constraints: [NSLayoutConstraint] = [
            momentumView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            momentumView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            momentumView.heightAnchor.constraint(equalTo: view.heightAnchor),
            momentumView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                              constant: Spaces.duodecuple),
            
            topShadowView.leadingAnchor.constraint(equalTo: momentumView.leadingAnchor),
            topShadowView.trailingAnchor.constraint(equalTo: momentumView.trailingAnchor),
            topShadowView.topAnchor.constraint(equalTo: momentumView.topAnchor),
            topShadowView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            
            handleView.topAnchor.constraint(equalTo: momentumView.topAnchor, constant: Spaces.single),
            handleView.widthAnchor.constraint(equalToConstant: Spaces.sextuple),
            handleView.heightAnchor.constraint(equalToConstant: 3),
            handleView.centerXAnchor.constraint(equalTo: momentumView.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: Spaces.single),
            tableView.bottomAnchor.constraint(equalTo: momentumView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: momentumView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: momentumView.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func setupViews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = Spaces.octuple
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.decelerationRate = .normal
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Spaces.quadruple, right: 0)
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: Constants.postCellIdentifier)
        tableView.register(PostTableViewLoadingCell.self, forCellReuseIdentifier: Constants.postCellLoadingIdentifier)
        tableView.register(PostTableViewErrorCell.self, forCellReuseIdentifier: Constants.postCellErrorIdentifier)
        tableView.panGestureRecognizer.addTarget(self, action: #selector(panned))
        tableView.dataSource = self
        tableView.delegate = self

        openTransform = CGAffineTransform(translationX: 0, y: -Spaces.duodecuple)
        closedTransform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        momentumView.transform = closedTransform
        
        panRecognizer.addTarget(self, action: #selector(panned))
        momentumView.addGestureRecognizer(panRecognizer)
        panRecognizer.delegate = self

        view.addSubview(momentumView)
        momentumView.addSubview(tableView)
        momentumView.addSubview(topShadowView)
        momentumView.addSubview(handleView)
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

    // MARK: - Manage gesture recognizers

    @objc
    private func panned(recognizer: UIPanGestureRecognizer) {
        switch recognizer {
        case tableView.panGestureRecognizer:
            if tableView.isDecelerating == false,
                tableView.contentSize.height > tableView.bounds.height {
                tableView.bounces = (tableView.contentOffset.y > offsetThreshold)
            }

            if !isOpen || interactionInProgress {
                tableView.contentOffset.y = initialScrollOffset.y
            }
        case panRecognizer:
            let yVelocity = recognizer.velocity(in: momentumView).y
            let direction: PanDirection = yVelocity > 0 ? .down : .up

            guard shouldHandleTouch(tableView, direction: direction) else {
                return
            }
            switch recognizer.state {
            case .began:
                startInteractive(direction: direction)
            case .changed:
                if !interactionInProgress {
                    startInteractive(direction: direction)
                    recognizer.setTranslation(CGPoint.zero, in: momentumView)
                }
                var fraction = recognizer.translation(in: momentumView).y / animatiorTrasform.ty
                if animator.isReversed {
                    fraction *= -1
                }
                animator.fractionComplete = fraction + animationProgress
            case .ended, .cancelled:
                endInteractive()
                
                let shouldRevert: Bool
                switch animatiorTrasform {
                case closedTransform:
                    shouldRevert = direction == .up ||
                        animator.fractionComplete < 0.25
                case openTransform:
                    shouldRevert = direction == .down ||
                        animator.fractionComplete < 0.25
                default:
                    shouldRevert = animator.fractionComplete < 0.3
                }
                if shouldRevert != animator.isReversed {
                    animator.isReversed.toggle()
                }
                if yVelocity == 0 {
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    break
                }
                let fractionRemaining = 1 - animator.fractionComplete
                let distanceRemaining = min(fractionRemaining * animatiorTrasform.ty, 0)
                
                if distanceRemaining == 0 {
                    animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                    break
                }
                let relativeVelocity = min(abs(yVelocity) / distanceRemaining, 10)
                let initialVelocity = CGVector(dx: relativeVelocity, dy: relativeVelocity)

                let timingParameters = UISpringTimingParameters(dampingRatio: Constants.dampingRatio,
                                                                initialVelocity: initialVelocity)
                let preferredDuration = UIViewPropertyAnimator(duration: Constants.animationDuration,
                                                               timingParameters: timingParameters).duration
                let durationFactor = CGFloat(preferredDuration / animator.duration)
                animator.continueAnimation(withTimingParameters: timingParameters, durationFactor: durationFactor)
            default: break
            }
        default:
            return
        }
    }

    private func startAnimationIfNeeded(direction: PanDirection) {
        guard !animator.isRunning else { return }
        
        let timingParameters = UISpringTimingParameters(dampingRatio: Constants.dampingRatio)
        animator = UIViewPropertyAnimator(duration: Constants.animationDuration,
                                          timingParameters: timingParameters)
        switch direction {
        case .down:
            animatiorTrasform = closedTransform
            animator.addAnimations { [unowned self] in
                self.momentumView.transform = self.animatiorTrasform
                self.momentumView.layer.cornerRadius = 30
                self.view.backgroundColor = .clear
            }
        case .up:
            animatiorTrasform = openTransform
            animator.addAnimations { [unowned self] in
                self.momentumView.transform = self.animatiorTrasform
                self.momentumView.layer.cornerRadius = 0
            }
        }
        animator.addCompletion { [weak self] position in
            guard let strongSelf = self else { return }
            if position == .end {
                strongSelf.isOpen = strongSelf.animatiorTrasform == strongSelf.openTransform
                if strongSelf.momentumView.transform == strongSelf.closedTransform {
                    strongSelf.closeModule()
                }
            }
        }
        animator.startAnimation()
    }

    // MARK: - TableView handling

    private func lockTableView() {
        initialScrollOffset = tableView.contentOffset
        tableView.isDirectionalLockEnabled = true
        tableView.isScrollEnabled = false
        tableView.bounces = false
    }

    private func unlockTableView() {
        tableView.isDirectionalLockEnabled = false
        tableView.isScrollEnabled = true
        tableView.bounces = true
    }

    private func shouldHandleTouch(_ tableView: UITableView, direction: PanDirection) -> Bool {
        switch (interactionInProgress, isOpen) {
        case (true, _):
            return true
        case (_, true):
            let zeroContentOffset = CGFloat(0) - tableView.contentInset.top
            return direction == .down &&
                tableView.contentOffset.y <= zeroContentOffset
        default:
            return true
        }
    }

    private func startInteractive(direction: PanDirection) {
        interactionInProgress = true
        lockTableView()

        startAnimationIfNeeded(direction: direction)
        animator.pauseAnimation()
        animationProgress = animator.fractionComplete
    }

    private func endInteractive() {
        interactionInProgress = false
        unlockTableView()
    }
    
    private func updateTopShadow() {
        let zeroContentOffset = CGFloat(0) - tableView.contentInset.top
        let alpha: CGFloat = (tableView.contentOffset.y - Spaces.double) > zeroContentOffset ? 1 : 0
        
        if topShadowView.alpha != alpha {
            UIView.animate(withDuration: 0.2) {
                self.topShadowView.alpha = alpha
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTopShadow()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        guard postItems.indices.contains(indexPath.row) else { return }
        let item = postItems[indexPath.row]
        viewModel.didSelectPost.onNext([item])
    }
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

// MARK: - UIGestureRecognizerDelegate

extension PostsViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                  shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panRecognizer else { return false }
        return otherGestureRecognizer == tableView.panGestureRecognizer
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panRecognizer else { return false }
        if otherGestureRecognizer == tableView.panGestureRecognizer {
            return false
        } else {
            return true
        }
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == panRecognizer else { return false }
        if tableView.panGestureRecognizer == otherGestureRecognizer {
            return false
        }
        if tableView.gestureRecognizers?.contains(otherGestureRecognizer) ?? false {
            return false
        }

        switch otherGestureRecognizer {
        case is UIPanGestureRecognizer,
             is UISwipeGestureRecognizer,
             is UIRotationGestureRecognizer,
             is UIScreenEdgePanGestureRecognizer,
             is UIPinchGestureRecognizer:
            return true
        default:
            return false
        }
    }
}

// MARK: - Constants

extension PostsViewController {
    private enum Constants {
        static let dampingRatio: CGFloat = 0.8
        static let animationDuration: Double = 0.8
        static let animationDurationBackground: Double = 0.3
        static let postCellIdentifier = "PostCollectionViewCell"
        static let postCellLoadingIdentifier = "PostCollectionViewLoadingCell"
        static let postCellErrorIdentifier = "PostCollectionViewErrorCell"
    }
}
