//
//  AccounSummaryHeaderView.swift
//  Bankey
//
//  Created by Admin on 09/09/23.
//

import Foundation
import UIKit

class AccountSummaryheaderView: UIView {
  
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var welcomeLable: UILabel!
  @IBOutlet weak var nameLable: UILabel!
  @IBOutlet weak var dateLable: UILabel!
  
  let shakeyBellView = ShakeyBellView()
  
  struct ViewModel {
    let welcomeMessage: String
    let name: String
    let date: Date
    
    var dateFormated: String {
      return date.monthDayYearString
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }
  
  override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: 146)
  }
  
  private func commonInit() {
    let bundle = Bundle(for: AccountSummaryheaderView.self)
    bundle.loadNibNamed("AccountSummaryheaderView", owner: self, options: nil)
    addSubview(contentView)
    contentView.backgroundColor = appColor
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
    setupShakeyBell()
  }
  
  private func setupShakeyBell() {
    shakeyBellView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(shakeyBellView)
    
    NSLayoutConstraint.activate([
      shakeyBellView.trailingAnchor.constraint(equalTo: trailingAnchor),
      shakeyBellView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func configure(viewModel: ViewModel) {
    welcomeLable.text = viewModel.welcomeMessage
    nameLable.text = viewModel.name
    dateLable.text = viewModel.dateFormated
  }
}
