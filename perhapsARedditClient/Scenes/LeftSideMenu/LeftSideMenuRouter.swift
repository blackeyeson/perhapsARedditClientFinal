import UIKit

protocol LeftSideMenuRoutingLogic {
    func dismissSelf()
}

protocol LeftSideMenuDataPassing { }

final class LeftSideMenuRouter: LeftSideMenuRoutingLogic, LeftSideMenuDataPassing {
    // MARK: - Clean Components
    
    weak var viewController: LeftSideMenuViewController?

    // MARK: - Routing
    
    func dismissSelf() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
