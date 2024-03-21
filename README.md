
# FlowTalk

### 실행화면
<p>
<!-- [1 온보딩화면] -->
<img src = "https://github.com/LEESANGNAM/FlowTalk/assets/61412496/128be5b3-8b24-4d62-8cf3-f5a45296308d" width="22%"/>  
<!-- [2 로그인모달]  -->
<img src = "https://github.com/LEESANGNAM/FlowTalk/assets/61412496/81b70c25-f51c-4c0f-b70b-8859d290f255" width="22%"/>  
<!-- [3 이메일로그인]  -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/1e20ad6d-675c-46e5-8bb4-4f398bececf6" width="22%"/>  
<!-- [5 회원가입중복체크]  -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/60335d05-acad-42da-b8bf-f2d3c44fbd2b" width="22%"/>   
</p>

<p>
<!-- [7 워크스페이스생성] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/eeee6219-f12b-4202-86a6-4f9ca674379e" width="22%"/>  
<!-- [8 채널추가_안읽은메세지] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/187211b4-8faa-44de-8f69-5a0a28fecf8e" width="22%"/>  
<!-- [6 워크스페이스홈_데이터없을때] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/7e9358de-8f09-486d-ae0c-d426f0e9bbcc" width="22%"/>  
</p>
 

<p>
<!-- [10 사이드메뉴_관리자] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/96802798-ec10-4b2a-89c7-37268a1464d1" width="22%"/>  
<!-- [10 사이드메뉴_나가기_관리자] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/82ca967c-664b-44c8-9081-84c6ada5cad0" width="22%"/>  
<!-- [10 사이드메뉴_나가기] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/b35a0623-8ec2-4d64-a3a8-5c8d0ffabbb0" width="22%"/>  
<!-- [9 사이드메뉴작동_변경,홈셀작동.gif] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/77427c8e-5cda-4b94-9765-bd1cd3d7930a" width="22%"/>  
</p>

<p>
<!-- [10 채널채팅_이미지레이아웃] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/35e26958-6b68-45ab-b0d3-4e419ef5d514" width="22%"/>  
<!-- [10 채널채팅_입력란사진만] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/b776cd5f-83a2-458f-a1fd-7fc0d195d27d" width="22%"/>  
<!-- [10 채널채팅_입력텍스트,사진] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/4fc3aaeb-5c0c-4e98-80c6-c1e0061bcce4" width="22%"/>  
<!-- [채널채팅수신받기.gif] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/c0fccdf4-30ff-4555-8333-39da32d65fa7" width="22%"/>  
</p>

<p>
<!-- [11 잠금화면푸시알림] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/c329d649-bdf2-4095-8cfb-2b8d048deb27" width="22%"/>  
<!-- [11 홈화면푸시알림] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/1975f007-dd87-4347-822d-c5043242d27c" width="22%"/>  
<!-- [12 새싹코인샵_결제] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/82d6e1e0-1e5a-43f6-83c6-f5e2139d286c" width="22%"/>  
<!-- [12 새싹코인샵_결제완료] -->
<img src = "https://github.com/LEESANGNAM/SeSacSlack/assets/61412496/65dbdf6d-1f86-4823-b48f-33fafe5eb948" width="22%"/>  
</p>


### 간단소개
같은 관심사를 가진 유저들끼리 소통할 수 있는 어플리케이션

## 개발기간
+ 개인프로젝트
+ 2024.1.3 ~ 2024.3.1 (9주)
## 최소타겟
+ iOS 16.0

## 기술스택
+ MVVM,RXSwift
+ UIKit,SnapKit, AutoLayout
+ Diffable DataSource, Compositional Layout
+ Kingfisher, Alamofire, Realm
+ Firebase Cloud Messaging, iamPort, KakaoOpenSDK,SoketIO

## 기능소개

### 회원가입,로그인
+ **RXKakaoSDK(카카오)** 와 **AuthenticationServices(애플)** 를 통해 SNS 로그인 제공
+ 이메일 유효성검사 api 를 통해 사용가능한 이메일인지 확인 후 회원가입 진행


### 워크스페이스
+ **DiffableDataSource** 를 활용한 **Expandable** 기능 구현
+ **UIViewControllerAnimatedTransitioning** 를 이용해 **SideMenu** 구현

### 채팅
+ **MultipartForm/Data** 을 이용해 여러장의 이미지 포함 채팅 업로드
+ **Realm** 을 활용해 과거 채팅내역을 저장하여 네트워크 통신 최소화
+ **SocketIO**를 활용해 양방향 실시간 채팅 기능
+ **Firebase Cloud Messaging(FCM)** 을 이용해 **Push Notification** 수신

### PG결제
+ **Iamport** 를 활용해 신용카드 결제 구현 및 영수증 검증


## 트러블슈팅

### 사이드 메뉴 구현
+ **UIViewControllerAnimatedTransitioning** 를 이용해 화면 전환 애니메이션을 커스텀 했다.
~~~ swift 
class SlideInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool = false
    // 동작시간
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    // 동작 정의
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else {
            return
        }

        let containerView = transitionContext.containerView

        if isPresenting {
            // Add the 'to' view controller's view to the container view
            let targetWidth = fromViewController.view.frame.width
            toViewController.view.frame = CGRect(x: targetWidth * -1, y: 0, width: targetWidth, height: fromViewController.view.frame.height)
                containerView.addSubview(toViewController.view)

            // Animate the 'to' view controller's view sliding in from left to right
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toViewController.view.frame.origin.x = 0
                toViewController.view.backgroundColor = toViewController.view.backgroundColor?.withAlphaComponent(0.5)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            // Animate the 'from' view controller's view sliding out from right to left
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromViewController.view.frame.origin.x = -containerView.frame.width
                fromViewController.view.backgroundColor = fromViewController.view.backgroundColor?.withAlphaComponent(0.0)
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
~~~

### 홈 화면에서의 네트워크 통신 비동기 
+ 홈화면에서 채널 목록 및 안읽은 메세지 요청을 했으나, 요청이 비동기로 동작해 완료 시점에 따라 데이터의 목록이 바뀌는 문제 발생
+ DispatchGroup 를 이용해 모든 작업이 완료되었을때 데이터를 넘겨주도록 구현

~~~ swift
 private func fetchUnreadCount(_ channelData: [SearchMyChannelsResponseDTO]) {
     var tempchannelArray: [homeDefaultListItem] = Array(repeating: homeDefaultListItem(), count: channelData.count)
      let group = DispatchGroup()

       for (index, item) in channelData.enumerated() {
            
            group.enter()
            let LastDate = channelChattingStorage?.checkChattingLastDate(channelId: item.channel_id)
            let model = UnreadChannelChattingRequestDTO(
                workspace_id: workID,
                channelName: item.name,
                after: LastDate ?? ""
            )
            channelUseCase.unreadCount(model: model)
                .subscribe(with: self) { owner, unreadChatting in
                    let homeModel = homeDefaultListItem(
                        title: item.name,unreadCount: unreadChatting.count
                    )
                    if index < tempchannelArray.count {
                        tempchannelArray[index] = homeModel
                    }
                    group.leave()
                }.disposed(by: disposeBag)
        }
        group.notify(queue: .main) {
            homeListArray.append(tempchannelArray)
            self.homeListData.accept(homeListArray)
        }
 }
~~~
