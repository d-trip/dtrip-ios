import Dip

func configurePost(_ container: DependencyContainer) {
    unowned let container = container

    container.register() {
        PostViewModelImp(manager: $0) as PostViewModel
    }

    container.register {
        PostCoordinator(router: $0, view: $1)
    }

    container.register { (model: PostViewModel) -> PostViewController in
        let controller = PostViewController()
        controller.viewModel = model
        return controller
    }
}
