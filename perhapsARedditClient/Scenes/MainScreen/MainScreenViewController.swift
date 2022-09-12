import UIKit

protocol MainScreenDisplayLogic: AnyObject {
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
}

class MainScreenViewController: UIViewController, configable
{
    // MARK: - Clean Components
    
    var interactor: MainScreenBusinessLogic = MainScreenInteractor(presenter: MainScreenPresenter(), worker: MainScreenWorker(apiManager: APIManager()))
    var router: MainScreenRoutingLogic & MainScreenDataPassing = MainScreenRouter()
    
    // MARK: - Views
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueView: UIView!

    
    // MARK: - Fields
    
    private var dataSource = [PostForTable]()
    
    // MARK: - config
    
    func config() {
        let apiManager = APIManager()
        let worker = MainScreenWorker(apiManager: apiManager)
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor(presenter: presenter, worker: worker)
        let router = MainScreenRouter()
        self.interactor = interactor
        self.router = router
        router.viewController = self
        presenter.viewController = self
        router.viewController = self
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month", numberOfPosts: 10))
        setupView()
        addGlobalListener()
    }
    
    //MARK: - Setup
    
    private func setupView() { tableConfiguration() }
    
    private func addGlobalListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("com.testCompany.Notification.reloadData"), object: nil)
    }
    
    private func setTableData(data: [PostForTable]) {
        self.dataSource = data
        tableView.reloadData()
    }
    
    //MARK: - Actions
    
    @IBAction func tap3Lines(_ sender: Any) {
        router.navigateToLeftSide()
    }
    @IBAction func swipe3Lines(_ sender: Any) {
        router.navigateToLeftSide()
    }
    
    @IBAction func homeTap(_ sender: Any) {
        scrollToTop(duration: 0.35)
    }
    
    @IBAction func tapProfile(_ sender: Any) {
        router.navigateToRightSide()
    }
    @IBAction func swipeProfile(_ sender: Any) {
        router.navigateToRightSide()
    }
    
    @objc func reloadData(notification: Notification) {
        scrollToTop(duration: 0.35)
    }
}

// MARK: - DisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        setTableData(data: viewModel.tableData)
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        
        if let model = model as PostForTable? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeFull", for: indexPath) as! TableViewCellTypeFull
            cell.configure(with: model)
            return cell
        }
        
        return .init()
    }
    
    //MARK: - functions

    func tableConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TableViewCellTypeFull", bundle: nil), forCellReuseIdentifier: "TableViewCellTypeFull")
        tableView.register(UINib(nibName: "TableViewCellTypeShortened", bundle: nil), forCellReuseIdentifier: "TableViewCellTypeShortened")
        tableView.reloadData()
    }
    
    func scrollToTop(duration: Double) {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        tableView.layer.opacity = 0
        interactor.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month", numberOfPosts: 10))
        UIView.transition(
            with: tableView,
            duration: duration,
            options: .transitionCrossDissolve,
            animations:
                { () -> Void in
                    self.tableView.reloadData()
                    self.tableView.layer.opacity = 1
                },
            completion: nil
        )
    }
}

// MARK: - UITableViewDelegate

//extension MainScreenViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let model = dataSource[indexPath.row] as? CountryCellModel else { return }
//        interactor.didTapCountry(request: MainScreen.ShowCountryDetails.Request(coord: model.latlng))
//    }
//}

