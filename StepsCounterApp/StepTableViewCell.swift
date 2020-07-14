

import UIKit

class StepTableViewCell: UITableViewCell {
    
    static let id = "StepTableViewCell"
    
    private let stepCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initViews() {
        addSubview(stepCountLabel)
        stepCountLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        stepCountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(dateLabel)
        dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func setupData(by step: Step) {
        stepCountLabel.text =  "\(step.count)"
        dateLabel.text = step.date
    }
}
