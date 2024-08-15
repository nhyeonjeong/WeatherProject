# WeatherProject

## ☔️스크린샷
![리드미 스크린샷 001](https://github.com/user-attachments/assets/8f312c87-1052-44ba-9a0d-9c4bc70952d3)


## ☔️프로젝트 소개
> 검색을 통한 일기예보 앱
- iOS 1인 개발
- 개발 기간
    - 24.07.26 ~ 24.08.09
- 개발 환경
    - 최소버전 13.0
    - 세로모드, 라이트모드만 지원
 
## ☔️핵심기능
- 현재 도시 날씨, 널씨설명, 최고/최저 날씨 표시
- 3시간 간격 이틀 날씨예보 표시
- 5일간 날씨예보 표시
- 도시 위치 map 표시
- 습도, 구름, 바람속도 평균 표시
- 도시 실시간 검색

## ☔️사용한 기술스택
- UIKit, CodeBaseUI, MVVM InputOutputPattern
- RxSwift, RxCocoa, Alamofire, Snapkit, Toast, SkeletonView, Network
- Singleton, DI, DTO, UserDefault, Access Control, Router Pattern
- UICompositionalLayout, MapView

## ☔️개발적 고려사항
### Search화면
#### `1. 대소문자 구분 없이 검색가능`
---
#### `2-1. 도시 TableView 스크롤시 Keyboard대응`
#### `2-2. 검색결과 없을 시 검색결과 없음 문구 표시`
<img width="30%" src="https://github.com/user-attachments/assets/657ea618-25d1-417d-a197-6db715129209">
<img width="30%" src="https://github.com/user-attachments/assets/74bf07b5-61a3-4164-a3c9-4acd893047a1">


### Main화면
#### `1. 첫화면 진입 시 SkeletonView 로딩뷰 구현`
   - 화면 표시 전 searchBar userInteractionEnabled = false
<img width="30%" src="https://github.com/user-attachments/assets/242fa5f2-2bc1-4b6a-be93-6ad850a491ef">

---

#### `2-1. Search화면 도시 선택 시 Main화면 스크롤 top처리`
#### `2-2. 검색 시 Toast를 통한 로딩뷰`
  - 화면 표시 전 searchBar userInteractionEnabled = false
#### `2-3. 현재 날씨에 따른 배경 이미지 지정`
#### `2-4. 도시검색시 도시 정보 UserDefualts저장`
   - 이후 앱 종료 후 진입 시 저장된 검색도시 정보 표시
<img width="30%" src="https://github.com/user-attachments/assets/2416c228-4b1c-4ce6-b61f-4d487e9436c3">
<img width="30%" src="https://github.com/user-attachments/assets/669ac654-42f4-41b3-b1c5-b22b690c7509">

---

#### `3. 네트워크 비연결시 Toast메세지 / 재연결시 API통신`
  - 네트워크 상황 중복 감지로 인한 API통신 중복 호출 -> rxSwift debounce


![스크린샷 2024-07-29 오후 11 44 10](https://github.com/user-attachments/assets/4348bf64-401d-4d94-bf44-a1bd740f29a6)


<img width="30%" src="https://github.com/user-attachments/assets/cc5e01d1-84e4-494c-9ded-c44c1e5ef84f">

---

#### `4. '5일간의 일기예보' 대표 날씨 기준 적립`
  - 우선순위 : 눈 > 번개 > 비 > 실 비 > 나머지중 많이 나온 날씨
<img width="30%" src="https://github.com/user-attachments/assets/690a2b1a-a774-4b7a-8f18-c7029424365f">
<img width="30%" src="https://github.com/user-attachments/assets/6eb0aec1-3a37-4173-a9a6-32594699da8b">

---

#### `5. .gitignore 통한 baseURL, APIKey관리`
#### `6. 중복되는 뷰 CustomView분리`
#### `7. 데이터 가공 뷰 맞춤 DTO 구현`
#### `8. 메모리 효율성을 위한 DataFormatManager싱글톤 생성 및 DateFormatter()객체 저장후 재사용`

## ☔️기술설명
- MVVM InputOutput패턴
  - ViewController과 ViewModel을 분리하고 RxSwift, RxCocoa 사용해 MVVM InputOutput패턴 작성
- Alamofire과 Generic을 사용한 네트워크통신 NetworkManager Singleton패턴 구성
  - Enum을 통한 statusCode관리, Error이벤트 전송 Observable객체 반환
  - rxSwift catch를 통한 statusCode에 따른 에러메세지 Toast
  - URLRequestConvertible을 통한 Router Pattern, Enum을 통한 QueryKey관리
- NWPathMonitorManager 싱글턴 구성 및 네트워크 상황 감지
  - 네트워크 비연결 / 재연결에 따른 클로저 실행
  - 네트워크 비연결시 Toast메세지 코드 최상위ViewController실행으로 모든 뷰 적용
- 외부에서 객체를 생성해 코드의 재사용성과 유연성을 높이기 위해 인스턴스 생성시 DI
- JSONEncoder, JSONDecoder 사용해 UserDefaults 도시 저장/패치
- 여러 부분에서 사용되는 UI를 customView로 분리
- 데이터 가공 뷰 맞춤 DTO 구현
  - API통신 후 정보 가공 후 DTO사용

## ☔️트러블슈팅
### `1. 네트워크 상태 감지 중복 대응 `

1-1) 문제

네트워크 상태 변경 시 이전 상태의 감지로 인해 네트워크 단절 Toast메세지가
네트워크 재연결시 띄워지는 문제

1-2) 해결

현재 네트워크 상태를 저장하는 변수를 통해 감지된 상태와 불일치 하는 경우에만 네트워크 대응코드 실행

<details>
<summary>NWPathMonitorManager.swift</summary>
<div markdown="1">
  
![스크린샷 2024-07-29 오후 8 46 19](https://github.com/user-attachments/assets/0f09b38d-b225-45cb-bc2d-5d0cc2129ca7)


![스크린샷 2024-07-29 오후 8 46 37](https://github.com/user-attachments/assets/341c86f6-2261-4821-b99c-e282c45d258a)

</div>
</details>

### `2. DateFormatter 한국 기준 시간`
2-1) 문제

DateFormatter객체 timeZone설정 오류로 인해 한국 시간 불일치

2-2) 해결

UTC 시간을 Data타입으로 변경한 후 다시 String타입으로 변경하는 과정에서 timeZone을 여전히 "UTC"로 설정


timeZone "Asia/Seoul"로 변경

<details>
<summary>DateFormatManager.swift</summary>
<div markdown="1">

![스크린샷 2024-07-29 오후 8 50 10](https://github.com/user-attachments/assets/602d897b-5ee1-4590-98fe-85e77d121539)

</div>
</details>

### `3. Search화면에서 네트워크 단절 시 Main화면 Toast`
3-1) 문제

Search화면 네트워크 단절 상황시 Toast메세지가 Main화면에 표시되는 문제

3-2) 해결

모든 ViewController가 상속받는 최상위 ViewController에 네트워크 단절시 대응 코드 작성
이후 네트워크 재연결시 실행되는 코드는 각 ViewController에 클로저로 전달

<details>
<summary>BaseViewController.swift</summary>
<div markdown="1">

![스크린샷 2024-07-29 오후 8 54 37](https://github.com/user-attachments/assets/1a35a947-e221-4116-b4f5-42465fcba658)
![스크린샷 2024-07-29 오후 8 55 09](https://github.com/user-attachments/assets/92f4dfaa-9e30-402d-b6ac-4cdd0034af42)

</div>
</details>

