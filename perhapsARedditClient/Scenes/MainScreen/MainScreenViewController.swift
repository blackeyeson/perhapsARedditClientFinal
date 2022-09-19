import UIKit

protocol MainScreenDisplayLogic: AnyObject {
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
    func displayAddedPosts(viewModel: MainScreen.GetPosts.ViewModel)
    func refreshHiddenPosts(viewModel: MainScreen.refreshHiddenPost.ViewModel)
    func revealTable()
    func popupShareMenu(url: String)
    func popupCommentsView(permalink: String)
}

class MainScreenViewController: UIViewController, configable {
    // MARK: - Clean Components
    
    var interactor: MainScreenBusinessLogic?
    var router: (MainScreenRoutingLogic & MainScreenDataPassing)?
    
    // MARK: - Views
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var blueView: UIView!
    @IBOutlet var bottomColorBar: UIView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var filterStringFieldOutlet: UITextField!
    
    
    // MARK: - Fields
    
    private var dataSource = [PostForTable]()
    private var dataSourceFiltered = [PostForTable]()
    private var hiddenPosts = [String]()
    private var filterString = ""
    private var lastPostID = ""
    
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
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month", numberOfPosts: 10))
        setupView()
        addGlobalListener()
    }
    
    //MARK: - Setup
    
    private func setupView() {
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
            self.dataSourceFiltered = data.filter { $0.postTitle.uppercased().contains(filterString.uppercased()) }
        } else { self.dataSourceFiltered = data }
        self.hiddenPosts = hiddenPosts
        tableView.reloadData()
        guard let lastFetchedPost = data.last else { return }
        lastPostID = lastFetchedPost.id
    }
    
    private func addTableData(data: [PostForTable], hiddenPosts: [String]) {
        let pastLastRow = dataSourceFiltered.count - 1
        self.dataSource += data
        if filterString != "" {
            self.dataSourceFiltered = dataSource.filter { $0.postTitle.uppercased().contains(filterString.uppercased()) }
        } else { self.dataSourceFiltered = dataSource }
        self.hiddenPosts = hiddenPosts
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: pastLastRow, section: 0), at: .top, animated: true)
        guard let lastFetchedPost = dataSource.last else { return }
        lastPostID = lastFetchedPost.id
    }
    
    //MARK: - Actions
    
    @IBAction func tap3Lines(_ sender: Any) {
        router?.navigateToLeftSide()
    }
    @IBAction func swipe3Lines(_ sender: Any) {
        router?.navigateToLeftSide()
    }
    
    @IBAction func homeTap(_ sender: Any) {
        scrollToTop()
    }
    
    @IBAction func tapProfile(_ sender: Any) {
        router?.navigateToRightSide()
    }
    @IBAction func swipeProfile(_ sender: Any) {
        router?.navigateToRightSide()
    }
    
    @IBAction func filterStringFiled(_ sender: Any) {
        scrollToTop()
        filterString = filterStringFieldOutlet.text ?? ""
        dataSourceFiltered = dataSource.filter { $0.postTitle.uppercased().contains(filterString.uppercased()) }
    }
    
    @objc func reloadData(notification: Notification) {
        scrollToTop()
    }
    
    @objc func reloadDataWithoutRefresh(notification: Notification) {
        reloadTableVithoutAnimation()
    }
}

// MARK: - DisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    
    func popupShareMenu(url: String) {
        let vc = UIActivityViewController(activityItems: ["Check this out! \(url)"], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view

        self.present(vc, animated: true, completion: nil)
    }
    
    func popupCommentsView(permalink: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CommentsViewController") as! CommentsViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.commentUrlString = "https://www.reddit.com\(permalink).json"

        vc.config()
        present(vc, animated: true, completion: nil)
    }
    
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        setTableData(data: viewModel.tableData, hiddenPosts: viewModel.hiddenPosts)
    }
    
    func displayAddedPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        addTableData(data: viewModel.tableData, hiddenPosts: viewModel.hiddenPosts)
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
    
    func reloadTableVithoutAnimation() {
        interactor?.refreshHiddenPostData(request: MainScreen.refreshHiddenPost.Request())
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSourceFiltered.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < dataSourceFiltered.count {
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
                
                if let stringUrl = model.picture {
                    isImageType = stringUrl.contains(".png") || stringUrl.contains(".jpg") || stringUrl.contains(".gif")
                    isImageType = isImageType && !stringUrl.contains(".gifv")
                    
                    if isImageType {
                        let dimentions = interactor?.getUIimageDimentions(request: MainScreen.getDimentionsFromURL.Request(urlString: stringUrl)) ?? [200, 200]
                        cell.mode = 1
                        width = dimentions[0]
                        height = dimentions[1]
                    }
                }
                if let videoUrl = model.VideoUrlString {
                    if videoUrl.contains(".mp4") {
                        isVideoType = true
                        let dimentions = interactor?.getVideoResolution(request: MainScreen.getDimentionsFromURL.Request(urlString: videoUrl)) ?? [200, 200]
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
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeLoading", for: indexPath) as! TableViewCellTypeLoading
            cell.indicator.startAnimating()
            if dataSource.count > 98 { interactor?.getMorePosts(request: MainScreen.addPosts.Request(lastPost: lastPostID)) }
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
        tableView.register(UINib(nibName: "TableViewCellTypeLoading", bundle: nil), forCellReuseIdentifier: "TableViewCellTypeLoading")
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
        interactor?.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month", numberOfPosts: 10))
    }
}
