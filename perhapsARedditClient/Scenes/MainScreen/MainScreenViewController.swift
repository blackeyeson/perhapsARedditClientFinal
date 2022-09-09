import UIKit

protocol MainScreenDisplayLogic: AnyObject
{
    func displayPosts(viewModel: MainScreen.GetPosts.ViewModel)
//    func displaySelectedCountry(viewModel: MainScreen.ShowCountryDetails.ViewModel)
}

class MainScreenViewController: UIViewController
{
    // MARK: - Clean Components
    
    var interactor: MainScreenBusinessLogic
    var router: MainScreenRoutingLogic & MainScreenDataPassing
    
    // MARK: - View
    
    @IBOutlet var tableView: UITableView!

    
    // MARK: - Fields
    
    private var dataSource = [PostForTable]()
    
    // MARK: - Object lifecycle
    
    init(interactor: MainScreenBusinessLogic, router: MainScreenRoutingLogic & MainScreenDataPassing) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.getPosts(request: MainScreen.GetPosts.Request(subreddit: "pics", timePeriod: "month", numberOfPosts: 10))
        setupView()
    }
    
    // MARK: Setup
    
    private func setupView() {
        tableView.register(TableViewCellType1.self, forCellReuseIdentifier: TableViewCellType1.identifier)
        tableView.register(TableViewCellTypeShortened.self, forCellReuseIdentifier: TableViewCellTypeShortened.identifier)
    }
    
    private func setTableData(data: [PostForTable]) {
        self.dataSource = data
        tableView.reloadData()
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
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellType1.identifier) as! TableViewCellType1
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

