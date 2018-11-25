import Dip

func configurePosts(_ container: DependencyContainer) {
    unowned let container = container

    container.register() { (postIdentifiers: [PostIdentifier])
        -> (viewModel: PostsViewModel, viewController: PostsViewController) in
        let viewModel: PostsViewModel = try! container.resolve(arguments: postIdentifiers)
        let viewController: PostsViewController = try! container.resolve(arguments: viewModel)
        
        return (viewModel, viewController)
    }
    
    container.register() { (postIdentifiers: [PostIdentifier]) -> PostsViewModel in
        PostsViewModel(manager: try! container.resolve(),
                       postIdentifiers: postIdentifiers)
    }

    container.register {
        PostsCoordinator(router: $0)
    }

    container.register { (model: PostsViewModel) -> PostsViewController in
        let controller = PostsViewController()
        controller.bind(model)
        return controller
    }
}
