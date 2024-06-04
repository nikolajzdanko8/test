import UIKit
import SnapKit

final class SettingsViewController: UIViewController {
    
    // MARK: Constants
    private let heightForRow: CGFloat = 75
    private let IdentifierCell = "cellId"
    private let alerControllerTitle = "About app"
    private let alerControllerMessage = "Creater - Zhdanko Nikolay"
    private let okActionTitle = "Ok"
    private let addTitle = "Add"
    
    // MARK: Private properties
    private var models = [Model(title: "About app")]
    
    // MARK: UI
    private lazy var tableview: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.white
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: IdentifierCell)
        return tableview
    }()

    // MARK: Lyfecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layout()
        setupBarButtonItem()
    }
}

// MARK: - Private methods
private extension SettingsViewController {
    
    func setupViews() {
        view.addSubview(tableview)
    }
    
    func layout() {
        tableview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func showAlertController() {
        let alertController = UIAlertController(title: alerControllerTitle, message: alerControllerMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    func setupBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
                    title: addTitle,
                    style: .plain,
                    target: self,
                    action: #selector(addButtonTapped)
                )
    }
}

// MARK: - Private action methods
private extension SettingsViewController {
    
    @objc func addButtonTapped() {
        let mockData = Model(title: alerControllerTitle)
        models.append(mockData)
        tableview.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { models.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: IdentifierCell, for: indexPath)
        let model = models[indexPath.row].title
        cell.textLabel?.text = model
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { showAlertController() }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { heightForRow }
}
