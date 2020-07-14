
import UIKit

class StepCounterViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StepTableViewCell.self, forCellReuseIdentifier: StepTableViewCell.id)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 32
        tableView.rowHeight = 32
        return tableView
    }()
    
    var directionIsUp: Bool = false {
        didSet {
            steps = steps.reversed()
        }
    }
    
    private var steps: [Step] = [] {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
        configureNavigation()
        setupHealthKit()
    }
    
    private func initTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func configureNavigation() {
        let item = UIBarButtonItem(image: #imageLiteral(resourceName: "reverse"), style: .done, target: self, action: #selector(reverseList(_:)))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc private func reverseList(_ sender: UIBarButtonItem) {
        directionIsUp = !directionIsUp
    }
    
    private func setupHealthKit() {
        HealthKitManager.default.getHealthKitPermission {[weak self] (response) in
            guard let self = self else {return}
            self.loadStepLast(days: 14)
        }
    }

    private func loadStepLast(days: TimeInterval) {
        HealthKitManager.default.getStepsLast(days: days) {[weak self] (steps) in
            self?.steps = steps
        }
    }
    
}


extension StepCounterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StepTableViewCell.id) as! StepTableViewCell
        let step = steps[indexPath.row]
        cell.setupData(by: step)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
