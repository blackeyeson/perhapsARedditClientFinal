import UIKit

protocol MainScreenDisplayLogic: AnyObject
{
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
//    func displaySelectedCountry(viewModel: MainScreen.ShowCountryDetails.ViewModel)
}

class MainScreenViewController: UIViewController
{
    // MARK: - Clean Components
    
    var interactor: MainScreenBusinessLogic = MainScreenInteractor(presenter: MainScreenPresenter(), worker: MainScreenWorker(apiManager: APIManager()))
    var router: MainScreenRoutingLogic & MainScreenDataPassing = MainScreenRouter(username: "nil")
    
    // MARK: - Views
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueView: UIView!

    
    // MARK: - Fields
    
    private var dataSource = [PostForTable]()
    var username = "Guest"
    
//    // MARK: - Object lifecycle
//
//    init(interactor: MainScreenBusinessLogic, router: MainScreenRoutingLogic & MainScreenDataPassing) {
//        self.interactor = interactor
//        self.router = router
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    // MARK: - config
    
    func config(username: String?) {
        let apiManager = APIManager()
        let worker = MainScreenWorker(apiManager: apiManager)
        let presenter = MainScreenPresenter()
        let interactor = MainScreenInteractor(presenter: presenter, worker: worker)
        let router = MainScreenRouter(username: username ?? "Guest")
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
    }
    
    // MARK: Setup
    
    private func setupView() {
        tableView.register(TableViewCellTypeFull.self, forCellReuseIdentifier: TableViewCellTypeFull.identifier)
        tableView.register(TableViewCellTypeShortened.self, forCellReuseIdentifier: TableViewCellTypeShortened.identifier)
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
    
    //MARK: - functions
    
    func scrollToTop(duration: Double) {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.transition(with: tableView,
                          duration: duration,
                          options: .transitionCrossDissolve,
                          animations:
                            { () -> Void in
            self.tableView.reloadData()
        },
                          completion: nil);
    }
}

// MARK: - CountriesDisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
//    func displaySelectedCountry(viewModel: MainScreen.ShowCountryDetails.ViewModel) {
//        router.navigateToCountryDetails()
//    }
    
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        setTableData(data: viewModel.tableData)
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        
        if let model = model as PostForTable? {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellTypeFull.identifier, for: indexPath) as! TableViewCellTypeFull
            cell.configure(with: model)
            return cell
        }
        
        return .init()
    }
}

// MARK: - UITableViewDelegate

//extension MainScreenViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let model = dataSource[indexPath.row] as? CountryCellModel else { return }
//        interactor.didTapCountry(request: MainScreen.ShowCountryDetails.Request(coord: model.latlng))
//    }
//}

