//
//  GetIntListViewController.swift
//  Brother Print SDK Demo
//
//  Created by matsuo yu on 2024/03/29.
//

import Foundation
import SwiftUI
import UIKit

class GetIntListViewController: UIViewController {
    var onReturnBlock: (([Int]) -> Void) = { (_: ([Int])) -> Void in /*nop*/ }
    var titleName: String = ""
    var decisionCaption: String = ""
    @Published var viewModel = GetIntListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let rootView = GetIntListView(viewModel: viewModel)
        let hostingVC = UIHostingController(rootView: rootView)
        addChild(hostingVC)
        hostingVC.didMove(toParent: self)
        hostingVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubViewFull(hostingVC.view)
        title = titleName
        self.navigationItem.rightBarButtonItem = BarButtonItemWithBlock(
            title: decisionCaption,
            style: UIBarButtonItem.Style.done,
            block: { _ in
            guard self.viewModel.number.isNumberListString() else {
                self.viewModel.isInputValid = false
                return
            }
            self.viewModel.isInputValid = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigationController?.popViewController(animated: true)
                self.onReturnBlock(self.viewModel.number.getNumberListString())
            })
        })
    }
    
    init(onReturnBlock: @escaping ([Int]) -> Void, titleName: String, decisionCaption: String,
         dataSource: TemplateKeyViewModel = TemplateKeyViewModel()) {
        super.init(nibName: nil, bundle: nil)
        self.onReturnBlock = onReturnBlock
        self.titleName = titleName
        self.decisionCaption = decisionCaption
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
class GetIntListViewModel: ObservableObject {
    @Published var number: String = ""
    @Published var isInputValid: Bool = true
}
struct GetIntListView: View {
    @ObservedObject var viewModel: GetIntListViewModel
    var body: some View {
        NavigationView(content: {
            VStack(alignment: .leading, content: {
                Text("input_numbers_with_seperated").font(.footnote)
                TextField("", text: $viewModel.number).textFieldStyle(.roundedBorder)
                if !viewModel.isInputValid {
                    Text("error_invalidate_input")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                Spacer()
            }).padding(.horizontal, 16).padding(.top, 8)
        })
    }

}
