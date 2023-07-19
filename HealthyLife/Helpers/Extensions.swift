//
//  Extensions.swift
//  HealthyLife
//
//  Created by Victor Melcon Diez on 20/5/22.
//

import SwiftUI

// MARK: - Navigation controller helpers
extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()

        // Recover appereance
        let appearance = UINavigationBarAppearance()
        // Change background color
        appearance.backgroundColor = UIColor(Color("TabViewColor"))
        // Remove bottom line
        appearance.shadowColor = .clear
        
        // Change text color
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor(.white)]
        
        // Set appereance
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
    }
}

// MARK: - Alert controller extension
extension UIAlertController {
    convenience init(alert: TextAlert) {
        self.init(title: alert.title, message: alert.message, preferredStyle: .alert)
        addTextField {
            $0.placeholder = alert.placeholder
            $0.keyboardType = alert.keyboardType
        }
        if let cancel = alert.cancel {
            addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
                alert.action(nil)
            })
        }
        if let secondaryActionTitle = alert.secondaryActionTitle {
            addAction(UIAlertAction(title: secondaryActionTitle, style: .default, handler: { _ in
                alert.secondaryAction?()
            }))
        }
        let textField = self.textFields?.first
        addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            alert.action(textField?.text)
        })
    }
}

// MARK: - View extension to add a custom alert
extension View {
  public func alert(isPresented: Binding<Bool>, _ alert: TextAlert) -> some View {
    AlertWrapper(isPresented: isPresented, alert: alert, content: self)
  }
}
