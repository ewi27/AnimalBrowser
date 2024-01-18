//
//  CharacteristicsViewSwiftUI.swift
//  AnimalBrowser
//
//  Created by Ewelina on 05/11/2023.
//

import SwiftUI

@available(iOS 17.0, *)
struct CharacteristicsViewSwiftUI: View {
    
    @StateObject var viewModelWrapper: CharacteristicsViewModelWrapper
    
    var body: some View {
        ZStack {
            Color(UIColor.lightGray).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    
                    ForEach(viewModelWrapper.items, id: \.self) { item in
                        Text(item)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 150)
                            .background(Color(UIColor.gray))
                            .minimumScaleFactor(0.3)
                        
                        Rectangle()
                            .fill(Color(UIColor.darkGray))
                            .frame(maxWidth: .infinity)
                            .frame(height: 0.3)
                    }
                }
                .cornerRadius(25)
            }
            .cornerRadius(25)
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .onAppear(perform: {
                viewModelWrapper.viewModel?.viewDidLoad()
            })
        }
    }
}

@available(iOS 17.0, *)
struct CharacteristicsViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        CharacteristicsViewSwiftUI(viewModelWrapper: previewVM)
    }
    
    static var previewVM: CharacteristicsViewModelWrapper = {
        var vM = CharacteristicsViewModelWrapper(viewModel: nil)
        vM.items = ["Item", "Item1","Item2"]
        return vM
    }()
}

final class CharacteristicsViewModelWrapper: ObservableObject {
    
    var viewModel: CharacteristicsViewModel?
    @Published var items: [String] = []
    
    init(viewModel: CharacteristicsViewModel?) {
        self.viewModel = viewModel
        viewModel?.loadData = { [weak self] items in
            self?.items = items
        }
    }
}
