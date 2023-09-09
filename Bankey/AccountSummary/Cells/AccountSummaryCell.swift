//
//  AccountSummaryCell.swift
//  Bankey
//
//  Created by Admin on 10/09/23.
//

import Foundation
import UIKit

class AccountSummaryViewCell: UITableViewCell {
    
    enum AccountType: String {
        case Banking
        case CreditCard
        case Investment
    }
    
    struct ViewModel {
        let accountType: AccountType
        let accountName: String
        let balance: Decimal
        
        var balanceAsAttributedString: NSAttributedString {
            return CurrencyFormatter().makeAttributedCurrency(balance)
        }
    }
    
    let viewModel: ViewModel? = nil
    
    let labelType = UILabel()
    let labelName = UILabel()
    let labelBalance = UILabel()
    let labelBalanceAmount = UILabel()
    let ivChevron = UIImageView()
    let svBalance = UIStackView()
    let underineView = UIView()
    
    static let reuseID = "AccountSummaryCell"
    static let rowHeight = CGFloat(111)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension AccountSummaryViewCell {
    
    private func setup() {
        labelType.translatesAutoresizingMaskIntoConstraints = false
        labelType.font = UIFont.preferredFont(forTextStyle: .caption1)
        labelType.adjustsFontForContentSizeCategory = true
        
        underineView.translatesAutoresizingMaskIntoConstraints = false
        underineView.backgroundColor = appColor
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.font = UIFont.preferredFont(forTextStyle: .body)
        
        svBalance.translatesAutoresizingMaskIntoConstraints = false
        svBalance.spacing = 0
        svBalance.axis = .vertical
        
        labelBalance.translatesAutoresizingMaskIntoConstraints = false
        labelBalance.font = UIFont.preferredFont(forTextStyle: .body)
        labelBalance.textAlignment = .right
        
        labelBalanceAmount.translatesAutoresizingMaskIntoConstraints = false
        labelBalance.textAlignment = .right
        
        ivChevron.translatesAutoresizingMaskIntoConstraints = false
        ivChevron.image = UIImage(systemName: "chevron.right")!
            .withTintColor(appColor, renderingMode: .alwaysOriginal)
    }
    
    private func layout() {
        contentView.addSubview(labelType) // important! to add contentView.
        contentView.addSubview(underineView)
        contentView.addSubview(labelName)
        
        svBalance.addArrangedSubview(labelBalance)
        svBalance.addArrangedSubview(labelBalanceAmount)
        contentView.addSubview(svBalance)
        
        contentView.addSubview(ivChevron)
        
        NSLayoutConstraint.activate([
            labelType.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            labelType.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            underineView.topAnchor.constraint(equalToSystemSpacingBelow: labelType.bottomAnchor, multiplier: 1),
            underineView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            underineView.widthAnchor.constraint(equalToConstant: 60),
            underineView.heightAnchor.constraint(equalToConstant: 4),
            
            labelName.topAnchor.constraint(equalToSystemSpacingBelow: underineView.bottomAnchor, multiplier: 2),
            labelName.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            
            svBalance.topAnchor.constraint(equalToSystemSpacingBelow: underineView.bottomAnchor, multiplier: 0),
            svBalance.leadingAnchor.constraint(equalToSystemSpacingAfter: labelName.trailingAnchor, multiplier: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: svBalance.trailingAnchor, multiplier: 4),
            
            ivChevron.topAnchor.constraint(equalToSystemSpacingBelow: underineView.bottomAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: ivChevron.trailingAnchor, multiplier: 1),
        ])
    }
    
}

extension AccountSummaryViewCell {
    
    func configure(with vm: ViewModel) {
        labelType.text = vm.accountType.rawValue
        labelName.text = vm.accountName
        labelBalanceAmount.attributedText = vm.balanceAsAttributedString
        
        func onBalance(underlineColor: UIColor, balance: String) {
            underineView.backgroundColor = underlineColor
            labelBalance.text = balance
        }
        
        switch vm.accountType {
        case .Banking:
            onBalance(underlineColor: appColor, balance: "Current balance")
        case .CreditCard:
            onBalance(underlineColor: .systemOrange, balance: "Current balance")
        case .Investment:
            onBalance(underlineColor: .systemPurple, balance: "Value")
        }
    }
    
}
