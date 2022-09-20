import UIKit

protocol MainScreenDisplayLogic: AnyObject {
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
    func displayAddedPosts(viewModel: MainScreen.GetPosts.ViewModel)
    func refreshHiddenPosts(viewModel: MainScreen.refreshHiddenPost.ViewModel)
    func revealTable()
    func popupShareMenu(request: MainScreen.popupShareMenu.Request)
    func popupCommentsView(request: MainScreen.popupCommentsView.Request)
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
    private var tablesActiveDataSource = [PostForTable]()
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
        interactor?.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month"))
        setupView()
        addGlobalListener()
    }
    
    //MARK: - Setup
    
    private func setupView() {
        indicator.hidesWhenStopped = true
        tableConfiguration()
    }
    
    private func addGlobalListener() {
        // for reloading data while in other VCs
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("com.testCompany.Notification.reloadData"), object: nil)
        // for updating tableView cells on contract/lengthen action from cells
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataWithoutRefresh), name: Notification.Name("com.testCompany.Notification.reloadDataWithoutRefresh"), object: nil)
    }
    
    private func setTableData(data: [PostForTable], hiddenPosts: [String]) {
        self.dataSource = data
        
        if filterString == "" { self.dataSourceFiltered = data } // refiltering if needed
        else { self.dataSourceFiltered = data.filter { $0.postTitle.uppercased().contains(filterString.uppercased()) } }
        
        self.hiddenPosts = hiddenPosts
        tableView.reloadData() // updation view
        
        // seting id for loading more posts in future
        guard let lastFetchedPost = data.last else { return }
        lastPostID = lastFetchedPost.id
    }
    
    private func addTableData(data: [PostForTable], hiddenPosts: [String]) {
        let pastLastRow = dataSourceFiltered.count - 1 // saving scroll position
        self.dataSource += data
        
        if filterString == "" { self.dataSourceFiltered = dataSource } // refiltering if needed
        else {self.dataSourceFiltered = dataSource.filter { $0.postTitle.uppercased().contains(filterString.uppercased()) } }
        
        self.hiddenPosts = hiddenPosts
        tableView.reloadData() // updation view
        
        tableView.scrollToRow(at: IndexPath(row: pastLastRow, section: 0), at: .top, animated: true) // moving to past scroll position
        // seting id for loading more posts in future
        guard let lastFetchedPost = dataSource.last else { return }
        lastPostID = lastFetchedPost.id
    }
    
    //MARK: - Actions
    
    @IBAction func tap3Lines(_ sender: Any) { router?.navigateToLeftSide() }
    
    @IBAction func swipe3Lines(_ sender: Any) { router?.navigateToLeftSide() }
    
    @IBAction func homeTap(_ sender: Any) { scrollToTop() }
    
    @IBAction func tapProfile(_ sender: Any) { router?.navigateToRightSide() }
    
    @IBAction func swipeProfile(_ sender: Any) { router?.navigateToRightSide() }
    
    @IBAction func filterStringFiled(_ sender: Any) {
        filterString = filterStringFieldOutlet.text ?? ""
        dataSourceFiltered = dataSource.filter { $0.postTitle.uppercased().contains(filterString.uppercased()) }
        scrollToTop()
    }
    
    @objc func reloadData(notification: Notification) { scrollToTop() }
    
    @objc func reloadDataWithoutRefresh(notification: Notification) { reloadTableVithoutAnimation() }
}

// MARK: - DisplayLogic

extension MainScreenViewController: MainScreenDisplayLogic {
    
    func popupShareMenu(request: MainScreen.popupShareMenu.Request) {
        router?.popupShareMenu(urlString: request.urlString)
    }
    
    func popupCommentsView(request: MainScreen.popupCommentsView.Request) {
        router?.popupCommentsView(permalinkComponent: request.permalink)
    }
    
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        setTableData(data: viewModel.tableData, hiddenPosts: viewModel.hiddenPosts)
    }
    
    func displayAddedPosts(viewModel: MainScreen.GetPosts.ViewModel) {
        addTableData(data: viewModel.tableData, hiddenPosts: viewModel.hiddenPosts)
    }
    
    func refreshHiddenPosts(viewModel: MainScreen.refreshHiddenPost.ViewModel) { hiddenPosts = viewModel.posts }
    
    func revealTable() { revealTableView() }
    
    func reloadTableVithoutAnimation() { reloadTableViewVithoutAnimation() }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MainScreenViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tablesActiveDataSource = dataSourceFiltered // making sure table funcs have same data
        return tablesActiveDataSource.count + 1 // +1 is for loading loadingCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < tablesActiveDataSource.count { //checking if loadingCell is needed
            
            let model = tablesActiveDataSource[indexPath.row]
            if let model = model as PostForTable? {
                let isHiddenPost = hiddenPosts.contains(model.id)
                if isHiddenPost { return createShortenedPostCell(model: model, indexPath: indexPath) } //shortCell casr
                else { return createPostCell(model: model, indexPath: indexPath) } //fullCell case
            }
        } else { return createLoadingCell(indexPath: indexPath) } //loadingCell case
        return .init()
    }
    
    //MARK: - tableView specific functions
    
    private func createShortenedPostCell(model: PostForTable, indexPath: IndexPath) -> TableViewCellTypeShortened {
        //MARK: - creating shortened post cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeShortened", for: indexPath) as! TableViewCellTypeShortened
        cell.configure(with: model)
        return cell
    }
    
    private func createPostCell(model: PostForTable, indexPath: IndexPath) -> TableViewCellTypeFull {
        //MARK: - creating post cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeFull", for: indexPath) as! TableViewCellTypeFull
        cell.delegate = self
        //MARK: - fetching and setting media dimentions
        cell.trueWidth = UIScreen.main.bounds.width
        var width: CGFloat = 200
        var height: CGFloat = 200
        var isImageType = false
        var isVideoType = false
        // case UIImage type
        if let stringUrl = model.picture {
            isImageType = stringUrl.contains(".png") || stringUrl.contains(".jpg") || stringUrl.contains(".gif")
            isImageType = isImageType && !stringUrl.contains(".gifv") // blacklisting invalid url
            
            if isImageType {
                let dimentions = interactor?.getUIimageDimentions(request: MainScreen.getDimentionsFromURL.Request(urlString: stringUrl)) ?? [200, 200]
                cell.mode = 1
                width = dimentions[0]
                height = dimentions[1]
            }
        }
        // case video type
        if let videoUrl = model.VideoUrlString {
            if videoUrl.contains(".mp4") {
                isVideoType = true
                let dimentions = interactor?.getVideoResolution(request: MainScreen.getDimentionsFromURL.Request(urlString: videoUrl)) ?? [200, 200]
                cell.mode = 3
                width = dimentions[0]
                height = dimentions[1]
            }
        }
        // case text type
        if model.bodyText != ""  { cell.mode = 4 }
        // pre-set height if needed
        if isImageType || isVideoType { cell.setHeightFromAspect(contentWidth: width, contentHeight: height) }
        //MARK: - finished preCell WorlLoad . running cell config
        cell.configure(with: model)
        return cell
    }
    
    private func createLoadingCell(indexPath: IndexPath) -> TableViewCellTypeLoading {
        //MARK: - creating LastInRow Loading cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellTypeLoading", for: indexPath) as! TableViewCellTypeLoading
        // fetching and adding more posts if dataSource has posts
        if dataSource.count > 300 { cell.indicator.stopAnimating(); cell.label.text = "No posts found" }
        else {
            cell.indicator.startAnimating(); cell.label.text = "Loading Posts . . ."
            if dataSource.count > 20 { interactor?.getMorePosts(request: MainScreen.addPosts.Request(lastPost: lastPostID)) }
        }
        cell.configure()
        return cell
    }
    
    func tableConfiguration() {
        // delegation
        tableView.delegate = self
        tableView.dataSource = self
        // registration
        tableView.register(UINib(nibName: "TableViewCellTypeFull", bundle: nil), forCellReuseIdentifier: "TableViewCellTypeFull")
        tableView.register(UINib(nibName: "TableViewCellTypeShortened", bundle: nil), forCellReuseIdentifier: "TableViewCellTypeShortened")
        tableView.register(UINib(nibName: "TableViewCellTypeLoading", bundle: nil), forCellReuseIdentifier: "TableViewCellTypeLoading")
        // updating view
        tableView.reloadData()
    }
    
    func scrollToTop() {
        // avoiding crash while there aren't posts
        if dataSourceFiltered.count > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        // animation
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
        // reloading post data
        interactor?.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month"))
    }
    
    private func revealTableView() {
        let duration = 0.35
        indicator.stopAnimating()
        UIView.transition(
            with: tableView, duration: duration,options: .transitionCrossDissolve, animations:
                { () -> Void in
                    self.tableView.layer.opacity = 1
                }, completion: nil
        )
        tableView.reloadData()
    }
    
    private func reloadTableViewVithoutAnimation() {
        interactor?.refreshHiddenPostData(request: MainScreen.refreshHiddenPost.Request())
        tableView.reloadData()
    }
}
