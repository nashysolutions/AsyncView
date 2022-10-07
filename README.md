# AsyncView

[![](https://img.shields.io/badge/Swift%20Compatibility-5.5%20|%205.6%20|%205.7-red?logo=swift)](https://www.swift.org/about/)
[![](https://img.shields.io/badge/Platform%20Compatibility-iOS%20|%20macOS%20|%20tvOS%20|%20watchOS-red?logo=swift)](https://developer.apple.com)

Handles asynchronous loading of content for those that must support iOS 14.

## Usage


```swift
struct CatView: View {
    
    @StateObject private var model = CatModel()
    
    var body: some View {
        AsyncView(model: model) {
            ProgressView()
        } errorView: { error in
            ErrorView(error: error)
        } contentView: { data in
            Image(uiImage: UIImage(data: data)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .onAppear {
            Task {
                await model.load()
            }
        }
    }
}

final class CatModel: AsyncModel, ObservableObject {
    
    @Published var result: AsyncResult<Data> = .empty
    
    var asyncOperationBlock: AsyncOperation {
        return { [unowned self] in
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1) // simulate loading
            return try Data(contentsOf: file)
        }
    }
    
    private var file: URL {
        Bundle.main.url(forResource: "Cat", withExtension: "png")!
    }
}

struct ErrorView: View {
    
    var error: Error
    
    var body: some View {
        Text(error.localizedDescription)
    }
}
```
