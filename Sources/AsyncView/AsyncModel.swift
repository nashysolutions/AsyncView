import SwiftUI
import Cache

@MainActor
public protocol AsyncModel: ObservableObject {
    associatedtype Output: Identifiable
    typealias AsyncOperation = (Cache<Output>) async throws -> Output
    var asyncOperationBlock: AsyncOperation { get }
    var result: AsyncResult<Output> { get set }
    var cache: Cache<Output> { get }
    var cacheExpiry: Expiry { get }
}

public extension AsyncModel {
    var cacheExpiry: Expiry { .short }
}

public extension AsyncModel {
    
    func load() async {
        if case .inProgress = result {
            return
        }
        result = .inProgress

        do {
            let output = try await asyncOperationBlock(cache)
            cache.stash(output, duration: cacheExpiry)
            result = .success(output)
        } catch {
            result = .failure(error)
        }
    }

    // No need for this when .task(id: becomes available on SwiftUI views.
    func loadIfNeeded() async {
        switch result {
        case .empty, .failure:
            await load()
        case .inProgress, .success:
            break
        }
    }
}
