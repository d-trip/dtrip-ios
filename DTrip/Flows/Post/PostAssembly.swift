import Dip

func configurePost(_ container: DependencyContainer) {
    unowned let container = container

    container.register() { (postIdentifier: PostIdentifier)
        -> (viewModel: PostViewModel, viewController: PostViewController) in
        let viewModel: PostViewModel = try! container.resolve(arguments: postIdentifier)
        let viewController: PostViewController = try! container.resolve(arguments: viewModel)
        
        return (viewModel, viewController)
    }
    
    container.register() { (postIdentifier: PostIdentifier) -> PostViewModel in
        PostViewModel(manager: try! container.resolve(),
                      postIdentifier: postIdentifier)
    }

    container.register {
        PostCoordinator(router: $0)
    }

    container.register { (model: PostViewModel) -> PostViewController in
        let controller = PostViewController()
        controller.bind(model)
        return controller
    }
}
