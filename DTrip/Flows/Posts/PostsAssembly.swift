import Dip

func configurePosts(_ container: DependencyContainer) {
    unowned let container = container

    container.register() {
        PostsViewModelImp(manager: $0) as PostsViewModel
    }

    container.register {
        PostsCoordinator(router: $0, view: $1, postCoordinator: $2)
    }

    container.register { (model: PostsViewModel) -> PostsViewController in
        let controller = PostsViewController()
        controller.viewModel = model
        return controller
    }
}
