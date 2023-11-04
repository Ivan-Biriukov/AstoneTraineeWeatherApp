import Foundation

class Dynamic<T> {
    
    // MARK: -  Propertyes
    
    typealias Listener = (T) -> Void
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // MARK: - Methods
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    // MARK: - Init
    
    init(_ v: T) {
        value = v
    }
}
