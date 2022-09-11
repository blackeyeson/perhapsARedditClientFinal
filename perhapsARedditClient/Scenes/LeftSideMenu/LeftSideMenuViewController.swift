import UIKit

class LeftSideMenuViewController: UIViewController {
    
    // MARK: - Clean Components
    
//    private var interactor: LeftSideMenuBusinessLogic = LeftSideMenuInteractor()
//    private var router: LeftSideMenuRoutingLogic & LeftSideMenuDataPassing = LeftSideMenuRouter()
    
    var delegate: MainScreenViewController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - actions
    @IBAction func tap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func swipe(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func pics(_ sender: Any) {
        changeSub(sub: "pics")
    }
    @IBAction func photography(_ sender: Any) {
        changeSub(sub: "memes")
    }
    @IBAction func pixelart(_ sender: Any) {
        changeSub(sub: "PixelArt")
    }
    @IBAction func cat(_ sender: Any) {
        changeSub(sub: "cat")
    }

    @IBAction func day(_ sender: Any) {
        changeTimePeriod(period: "day")
    }
    @IBAction func month(_ sender: Any) {
        changeTimePeriod(period: "month")
    }
    @IBAction func year(_ sender: Any) {
        changeTimePeriod(period: "year")
    }
    @IBAction func week(_ sender: Any) {
        changeTimePeriod(period: "week")
    }
    @IBAction func all(_ sender: Any) {
        changeTimePeriod(period: "all")
    }

    //MARK: - functions
    
    func changeSub(sub: String) {
//        delegate?.redditData = nil
//        delegate?.subreddit = sub
//        delegate?.loadTableData()
//        delegate?.contractionStats = []
    }

    func changeTimePeriod(period: String) {
//        delegate?.redditData = nil
//        delegate?.timePeriod = period
//        delegate?.loadTableData()
//        delegate?.contractionStats = []
    }
    // MARK: - config
    
    func config() {
        let presenter = RightSideMenuPresenter()
        let interactor = RightSideMenuInteractor()
        let router = RightSideMenuRouter(username: "debug")
//        self.interactor = interactor
//        self.router = router
//        router.viewController = self
//        presenter.viewController = self
//        router.viewController = self
    }
    
}
