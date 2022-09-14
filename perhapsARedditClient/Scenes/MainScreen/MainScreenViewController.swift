import UIKit

protocol MainScreenDisplayLogic: AnyObject {
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
    func revealTable()
}

class MainScreenViewController: UIViewController, configable
{
    // MARK: - Clean Components
    
    var interactor: MainScreenBusinessLogic = MainScreenInteractor(presenter: MainScreenPresenter(), worker: MainScreenWorker(apiManager: APIManager()))
    var router: MainScreenRoutingLogic & MainScreenDataPassing = MainScreenRouter()
    
    // MARK: - Views
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueView: UIView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var filterStringFieldOutlet: UITextField!
    
    
    // MARK: - Fields
    
    private var dataSource = [PostForTable]()
    private var hiddenPosts = [String]()
    private var filterString = ""
    
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
    
    private func setupView() {
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        tableConfiguration()
    }
    
    private func addGlobalListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("com.testCompany.Notification.reloadData"), object: nil)
    }
    
    private func setTableData(data: [PostForTable], hiddenPosts: [String]) {
        self.dataSource = data
        self.hiddenPosts = hiddenPosts
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
        scrollToTop()
    }
    
    @IBAction func tapProfile(_ sender: Any) {
        router.navigateToRightSide()
    }
    @IBAction func swipeProfile(_ sender: Any) {
        router.navigateToRightSide()
    }
    
    @IBAction func filterStringFiled(_ sender: Any) {
        filterString = filterStringFieldOutlet.text ?? ""
        scrollToTop()
    }
    
    @objc func reloadData(notification: Notification) {
        scrollToTop()
    }
}

// MARK: - DisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        setTableData(data: viewModel.tableData, hiddenPosts: viewModel.hiddenPosts)
    }
    
    func revealTable() {
        let duration = 0.35
        indicator.stopAnimating()
        UIView.transition(
            with: tableView,
            duration: duration,
            options: .transitionCrossDissolve,
            animations:
                { () -> Void in
                    self.tableView.layer.opacity = 1
                },
            completion: nil
        )
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterString != "" {
            return dataSource.filter { $0.postTitle.contains(filterString) }.count
        } else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = dataSource[indexPath.row]
        
        if filterString != "" {
            model = dataSource.filter { $0.postTitle.contains(filterString) }[indexPath.row]
        }
        
        if let model = model as PostForTable? {
            if !hiddenPosts.contains(model.id) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeFull", for: indexPath) as! TableViewCellTypeFull
                cell.configure(with: model)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeShortened", for: indexPath) as! TableViewCellTypeShortened
                cell.configure(with: model)
                return cell
            }
            
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
    
    func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.transition(
            with: tableView,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations:
                { () -> Void in
                    self.tableView.layer.opacity = 0
                },
            completion: nil
        )
        indicator.startAnimating()
        interactor.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month", numberOfPosts: 10))
    }
}

// MARK: - UITableViewDelegate

//extension MainScreenViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let model = dataSource[indexPath.row] as? CountryCellModel else { return }
//        interactor.didTapCountry(request: MainScreen.ShowCountryDetails.Request(coord: model.latlng))
//    }
//}

