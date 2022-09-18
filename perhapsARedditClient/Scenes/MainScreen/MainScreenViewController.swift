import UIKit

protocol MainScreenDisplayLogic: AnyObject {
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
    func refreshHiddenPosts(viewModel: MainScreen.refreshHiddenPost.ViewModel)
    func revealTable()
    func popupShareMenu(url: String)
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
    private var dataSourceFiltered = [PostForTable]()
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
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataWithoutRefresh), name: Notification.Name("com.testCompany.Notification.reloadDataWithoutRefresh"), object: nil)
    }

    private func setTableData(data: [PostForTable], hiddenPosts: [String]) {
        self.dataSource = data
        if filterString != "" {
            self.dataSourceFiltered = data.filter { $0.postTitle.contains(filterString) }
        } else { self.dataSourceFiltered = data }
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
        scrollToTop()
        filterString = filterStringFieldOutlet.text ?? ""
        dataSourceFiltered = dataSource.filter { $0.postTitle.contains(filterString) }
    }
    
    @objc func reloadData(notification: Notification) {
        scrollToTop()
    }
    
    @objc func reloadDataWithoutRefresh(notification: Notification) {
        interactor.refreshHiddenPostData(request: MainScreen.refreshHiddenPost.Request())
        tableView.reloadData()
    }
}

// MARK: - DisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    
    func popupShareMenu(url: String) {
        let vc = UIActivityViewController(activityItems: ["Check this out! \(url)"], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view

        self.present(vc, animated: true, completion: nil)
    }
    
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        setTableData(data: viewModel.tableData, hiddenPosts: viewModel.hiddenPosts)
    }
    
    func refreshHiddenPosts(viewModel: MainScreen.refreshHiddenPost.ViewModel) {
        hiddenPosts = viewModel.posts
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
        dataSourceFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSourceFiltered[indexPath.row]
        
        if let model = model as PostForTable? {
            if !hiddenPosts.contains(model.id) {
                // creation
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeFull", for: indexPath) as! TableViewCellTypeFull
                cell.delegate = self
                
                // fetching media dimentions
                var width: CGFloat = 200
                var height: CGFloat = 200
                cell.trueWidth = UIScreen.main.bounds.width
                var isImageType = false
                var isVideoType = false
                
                if let StringUrl = model.picture {
                    isImageType = StringUrl.contains(".png") || StringUrl.contains(".jpg") || StringUrl.contains(".gif")
                    isImageType = isImageType && !StringUrl.contains(".gifv")
                    
                    if isImageType {
                        let dimentions = interactor.getUIimageDimentions(urlString: StringUrl)
                        cell.mode = 1
                        width = dimentions[0]
                        height = dimentions[1]
                    }
                }
                if let videoUrl = model.VideoUrlString {
                    if videoUrl.contains(".mp4") {
                        isVideoType = true
                        let dimentions = interactor.getVideoResolution(url: videoUrl)
                        cell.mode = 3
                        width = dimentions[0]
                        height = dimentions[1]
                    }
                }
                if model.bodyText != ""  { cell.mode = 4 }
                
                if isImageType || isVideoType { cell.setHeightFromAspect(contentWidth: width, contentHeight: height) }
                else {
                    cell.mode = 2
                }
                
                // setting data
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
        if dataSourceFiltered.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
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

