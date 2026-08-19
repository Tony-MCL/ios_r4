import SwiftUI
import UIKit

final class KeyboardViewController: UIInputViewController {
    private var keyboardHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootView = KeyboardRootView(
            insertText: { [weak self] text in
                self?.textDocumentProxy.insertText(text)
            },
            nextKeyboard: { [weak self] in
                self?.advanceToNextInputMode()
            }
        )

        let hostingController = UIHostingController(rootView: rootView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)

        let heightConstraint = view.heightAnchor.constraint(equalToConstant: desiredKeyboardHeight())
        heightConstraint.priority = .required
        heightConstraint.isActive = true
        keyboardHeightConstraint = heightConstraint
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHeightConstraint?.constant = desiredKeyboardHeight()
    }

    private func desiredKeyboardHeight() -> CGFloat {
        let messageCount = R4MessageStore.loadMessages().count
        let visibleRows = min(max(messageCount, 1), 3)

        // Header/padding + at most three message rows. From message four onward,
        // the SwiftUI ScrollView handles the additional content.
        return 58 + (CGFloat(visibleRows) * 64)
    }
}
