import RxCocoa
import RxSwift
import UIKit

extension UIScrollView {
    public var rxReachedBottom: Observable<Void> {
        return rx.contentOffset
            .debounce(0.025, scheduler: MainScheduler.instance)
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let yPosition = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return yPosition > threshold ? Observable.just(()) : Observable.empty()
        }
        
    }
}
