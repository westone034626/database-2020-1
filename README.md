# 주제: 독서 습관 형성 프로그램

## 1. 설계 배경

평소 책을 많이 읽으려고 하지만 습관을 들이기 힘들어 고민이 많았다. 이에 습관을 들이는 데는 기록하는 것이 중요하다는 생각에 이르렀고, 체계적인 기록 프로그램이 있으면 좋을 것 같다는 생각을 하게 되었다.
책의 ISBN정보를 가지고 책의 전반적인 정보를 받아오고, 읽기 시작한 날짜와 다 읽은 날짜를 입력하여, 읽은 책들을 기록하고, 많이 읽는 책의 분야, 장르별 독서 추이 등 독서성향을 분석하여 책 읽는 습관에 도움을 줄 수 있는 프로그램을 개발하게 되었다.

## 2. 설계 목표
<사용자 별 주요기능>
- 관리자: 모든 테이블을 조회, 관리(추가, 삭제, 수정)할 수 있는 권한을 부여한다(회원, 책 테이블)
- 회원: 독서한 책을 자신의 데이터베이스에 저장할 수 있으며 책을 특정 정보로 분류해 원하는 결과를 조회할 수 있다.

<주요 설계 목표>
1. ISBN를 입력 받아 책 정보를 크롤링해와서 데이터베이스에 삽입하는 기능 구현
2. 사용자의 데이터베이스에서 정보를 가공하여 표로 만들어 주는 기능 구현


## 3.	독서 습관 관리 프로그램 개념도
![1](https://drive.google.com/uc?export=view&id=1iXo9jFqwBQBhAbP_dAkoxcselFU3KBu_)

## 4. 정보관리 모듈 개념도
![2](https://drive.google.com/uc?export=view&id=15fn-yTOAKlLOjC5uuWfAWxMZJv2Myiak)
## 5. ERD(Entity Relationship Diagram)
![3](https://drive.google.com/uc?export=view&id=15rU_tLjPB9rP8LGLJlQjqKkoQSbo8RIo)

## 6. 관계 모델의 릴레이션
```
User(USER_ID, Email, Password, Name, Mentor_ID, Readvol, Menteenum, Favgenre, Favgenrevol)

Read(Book_ID, User_ID, Status, Start, Finish)

Book(Book_ID, ISBN, Page, Title, Author, Genre, Image_URL, Publisher, Reader)

```

## 7. 각 테이블 구조와 SQL 생성문

### User 테이블

#### 특징: USER_ID를 기본키로 가지며 MENTOR_ID는 user 테이블의 USER_ID를 참조하는 외래키입니다. 그 외 여러 애트리뷰트들은 default 값을 가집니다.

| 애트리뷰트 | 데이터 타입 | 비고 |
|:---:|:---:|:---:|
| `USER_ID` | NUMBER | 기본 키, NOT NULL, DEFAULT "" |
| `EMAIL` | VARCHAR | NOT NULL, DEFAULT "" |
| `PASSWORD` | VARCHAR | NOT NULL, DEFAULT "" |
| `NAME` | VARCHAR |  |
| `MENTOR_ID` | NUMBER | USER 테이블의 USER_ID를 외래키로 사용, 순환적 관계(자체조인) |
| `READVOL` | NUMBER | DEFAULT 0 |
| `MENTEENUM` | NUMBER | DEFAULT 0 |
| `FAVGENRE` | VARCHAR | DEFAULT "" |
| `FAVGENREVOL` | NUMBER | DEFAULT 0 |

```
//테이블 생성문
CREATE TABLE USER
(
    USER_ID NUMBER NOT NULL,
    EMAIL VARCHAR(30) NOT NULL DEFAULT “”,
    PASSWORD VARCHAR(15) NOT NULL DEFAULT “”,
    NAME VARCHAR(30),
    MENTOR_ID NUMBER,
    READVOL NUMBER DEFAULT 0,
    MENTEENUM NUMBER DEFAULT 0,
    FAVGENRE VARCHAR DEFAULT “”,
    FAVGENREVOL NUMBER DEFAULT 0,
    PRIMARY KEY(USER_ID),
    FOREIGN KEY (MENTOR_ID) 
    REFERENCES USER(USER_ID) ON DELETE SET  NULL
);
```

### Book 테이블

#### 특징: Book_ID를 기본키로 가집니다. ISBN은 13자리의 숫자여야만 합니다. READER를 제외한 모든 애트리뷰트는 크롤링 시 받아온 값으로 채워집니다.

| 애트리뷰트 | 데이터 타입 | 비고 |
|:---:|:---:|:---:|
| `BOOK_ID` | NUMBER | 기본 키, NOT NULL |
| `ISBN` | NUMBER(13) | NOT NULL |
| `PAGE` | NUMBER | |
| `TITLE` | VARCHAR |  |
| `AUTHOR` | VARCHAR |  |
| `GENRE` | VARCHAR |  |
| `IMAGE URL` | VARCHAR |  |
| `PUBLISHER` | VARCHAR |  |
| `READER` | NUMBER | DEFAULT 0 |

```
//테이블 생성문
CREATE TABLE BOOK
(
    BOOK_ID NUMBER NOT NULL,
    ISBN NUMBER(13) NOT NULL,
    PAGE NUMBER,
    TITLE VARCHAR(50),
    AUTHOR VARCHAR(30),
    GENRE VARCHAR(15),
    IMAGE_URL VARCHAR(1000),
    PUBLISHER VARCHAR(50),
    READER NUMBER DEFAULT 0,
    PRIMARY KEY(BOOK_ID)
);
```

### Read 테이블

#### 특징: Read 테이블의 USER_ID는 user 테이블의 USER_ID를 참조하는 외래키입니다. Read 테이블의 BOOK_ID는 book 테이블의 BOOK_ID를 참조하는 외래키입니다. 두 외래키는 복합키가 되어 Read 테이블의 기본키의 자격을 가집니다. 참조되는 테이블에서 튜플이 사라지면 이 튜플에 연결되어 있는 Read 테이블의 튜플들은 삭제됩니다.

| 애트리뷰트 | 데이터 타입 | 비고 |
|:---:|:---:|:---:|
| `BOOK_ID` | NUMBER | book 테이블의 BOOK_ID를 참조하는 외래 키, USER_ID와 함께 기본 키 |
| `USER_ID` | NUMBER | user 테이블의 USER_ID를 참조하는 외래 키, BOOK_ID와 함께 기본 키 |
| `STATUS` | BOOLEAN | DEFAULE FALSE |
| `START` | DATE |  |
| `FINISH` | DATE |  |

```
//테이블 생성문
CREATE TABLE READ
(
    USER_ID NUMBER NOT NULL,
    BOOK_ID NUMBER NOT NULL,
    STATUS BOOLEAN DEFAULT FALSE,
    START DATE,
    FINISH DATE,
    PRIMARY KEY(USER_ID, BOOK_ID),
    FOREIGN KEY (USER_ID) 
    REFERENCES USER ON DELETE CASCADE,
    FOREIGN KEY (BOOK_ID) 
    REFERENCES book ON DELETE CASCADE
);
```
### 각 테이블의 제약조건
| 테이블 명 | 엔티티 무결성 제약조건 | 참조 무결성 제약조건 |
|:---:|:---:|:---:|
| `User` | USER_ID (NOT NULL) | DELETE ON SET NULL(USER_ID에 대해서) |
| `Book` | BOOK_ID(NOT NULL) |  |
| `Read` | USER_ID, BOOK_ID(NOT NULL)| DELETE ON CASECADE(USER_ID, BOOK_ID에 대해서) |
<br>
    
## 8. 사용자 인터페이스와 기능 설명, 각 기능에 대한 SQL문

### 로그인 화면 (이메일 & 비밀번호 입력)

#### 특징: 입력받은 정보와 데이터베이스의 user table 정보를 비교합니다.
![4](https://drive.google.com/uc?export=view&id=1nqjJ_at8jIVDDQqgy89Y3sENzuIaxWsl)

---

### 회원가입 화면 (이메일 & 비밀번호 입력)

#### 특징: 회원 가입시 정보 입력
```
INSERT INTO user(“email”, “password”, “name”) VALUES (입력이메일, 입력패스워드, 입력이름);
```
![5](https://drive.google.com/uc?export=view&id=1A39M_itJSGo8YUMxF-JKKFftz7OIJuEx)

---

### 메인 화면 (로그인한 유저 정보 & 읽고 있는 책 리스트 확인 가능)

![6](https://drive.google.com/uc?export=view&id=1Uy6kGS5Ds0hFm8jvfdLVKtpZTpzlaqNg)

```
//사용자가 현재 읽고 있는 책: 현재 사용자가 독서 중인 책들을 불러옵니다.
SELECT b.id as id, b.title as title, b.author as author,
 b.genre as genre, b.page as page, r.start as start
 FROM book b, user u, read r
 WHERE u.id = '#{current_user.id}'
 AND u.id = r.user_id
 AND r.book_id = b.id
 AND r.status = false"
```
```
//책 읽기 시작 누를 시: 현재 날짜를 읽기 시작한 날짜로 기록합니다. 읽는 중 테이블에 시작 애트리뷰트 중 ‘O’ 표시를 누르면 됩니다.
UPDATE read SET start = Time.now 
WHERE book_id = book.id AND user_id = current_user.id
```
```
//책 읽기 중도 포기 시: 책 읽는 것을 포기하여 데이터베이스 상에서 독서 정보를 제거합니다. 읽는 중 테이블에 중도하차 애트리뷰트의 ‘X’ 표시를 누르면 됩니다.
DELETE FROM read 
WHERE book_id = params[:book_id] AND user_id = current_user.id
```
```
//책 완독 버튼 누를 시: 현재 날짜를 다 읽은 날짜로 기록합니다. 다 읽은 책에 따라 가장 좋아하는 장르와 가장 좋아하는 장르의 읽은 책 수, 책을 읽은 독자수를 갱신합니다. 읽는 중 테이블에 완독 애트리뷰트의 ‘Clear’ 표시를 누르면 됩니다.
UPDATE read SET finish = Time.now, status = true 
WHERE book_id = book.id AND user_id = current_user.id
```
```
// 책 완독 버튼 누른 후 갱신(현재 user 객체에 대해 Update 된 정보 기반으로 가장 좋아하는 장르와 가장 좋아하는 장르 읽은 책 정보 갱신)
SELECT b.favGenre as fv, MAX(b.favGenreVol) as fv_max
FROM (SELECT b.genre as favGenre, count(b.genre) as favGenreVol
        FROM user u, book b, read r
        WHERE u.id = '#{current_user.id}' AND u.id = r.user_id AND b.id = r.book_id 
UPDATE user SET readVol = readVol + 1 WHERE id = current_user.id
UPDATE user SET favGenre = favorite_genre[0].strip, favGenreVol = favorite_genre[1]
WHERE id = current_user.id AND r.status = true GROUP BY b.genre) AS b"
```
```
// 책 완독 버튼 누른 후 갱신(book 객체에 대해 책을 읽은 사람 수 증가)
UPDATE book SET reader = reader + 1 WHERE id = params[:book_id]
```

---

### 책 등록 (ISBN 입력, ISBN 토대로 크롤링)

#### step 1: 검색한 책이 데이터베이스 book table이 있는지 조회합니다. DB에 책이 있으면 그 책 정보를 step 2로 정보를 넘기고 만약 DB에 책 정보가 없으면 크롤링해와서 book 테이블에 추가한 후 step 2로 정보를 넘깁니다.

```
SELECT * FROM book WHERE ISBN = params[:ISBN]
```

![7](https://drive.google.com/uc?export=view&id=1ra4xq_aytFm371-LaKM4tqPKe-AZ_G9y)

#### step 2: step 1에서 불러온 책 정보를 가져옵니다. ‘추가’버튼을 누르면 현재 사용자가 이 책을 읽고 있는 것에 대한 정보를 Read 테이블에 추가합니다.

```
INSERT INTO book
("ISBN", "page", "genre", "title", "author", "imageURL", "publisher")
VALUES(book.ISBN, book.page, book.genre, book.title, book.author, book.imageURL, book.publisher)
```

![8](https://drive.google.com/uc?export=view&id=1v0cCNHsaKFehIbkeNTOuOmcwkcR6vVj5)

---

### 다 읽은 책 화면 (완독한 책 리스트 확인 가능)

#### 특징: 사용자가 완독한 책의 목록을 보여줍니다. 오른쪽 상단 ‘다 읽은 책’ 버튼을 통해 들어올 수 있습니다.

```
SELECT b.title as title, b.author as author, b.page as page, b.genre as genre, (r.finish - r.start) as ct
FROM user u, book b, read r
WHERE u.id = '#{current_user.id}'
AND u.id = r.user_id
AND b.id = r.book_id
AND r.status = true"
```

![9](https://drive.google.com/uc?export=view&id=10mG5b7HDTEIR_tTjzymn8pwE5_EBL7bD)

---

### 장르별 독서추이(장르별 읽은 책 수 확인 가능)

#### 특징: 다 읽는 책 화면에서 테이블에 있는 ‘장르별 독서량’ 버튼을 누르면 들어올 수 있습니다. 장르마다 읽은 책의 수를 내림차순으로 보여줍니다.

```
SELECT b.genre as bg, count(b.id) as sr, AVG(r.finish r.start) as af, SUM(b.page) as sp
FROM user u, read r, book b
WHERE u.id = r.user_id
AND r.book_id = b.id
AND r.status = true
AND u.id = '#{current_user.id}'
GROUP BY b.genre
ORDER BY count(b.id) DESC, b.genre ASC
```

![10](https://drive.google.com/uc?export=view&id=1m4yjwAITnjM72E8i9NQC0EKrFt4DYCdf)

---

### 유저목록 정렬 기능

#### 특징: 유저들을 멘티, 총 독서량, 장르별 독서량 기준으로 정렬한다.

![12](https://drive.google.com/uc?export=view&id=1zCCCQsuTrAw-U41XGJ9gyE0nYHlqL6__)

---

```
//멘티 수에 따른 유저 정렬 Query문
SELECT *
FROM user
WHERE id <> current_user.id
ORDER BY menteeNum DESC
```

```
//총 독서량에 따른 유저 정렬 Query문
SELECT *
FROM user
WHERE id <> current_user.id
ORDER BY readVol DESC
```

```
//장르별 독서량에 따른 유저 정렬 Query문
SELECT *
FROM user
WHERE id <> current_user.id
ORDER BY favGenre ASC, favGenreVol DESC
```

---

### 멘토 추가, 삭제

#### 멘토 추가: 유저 리스트 테이블에 멘토 신청 애트리뷰트의 사람 모양 아이콘을 누르면 해당 사용자와 멘토, 멘티 관계로 연결됩니다.

```
UPDATE user SET mentor_id = user 
WHERE id = current_user.id
UPDATE user SET menteeNum = menteeNum + 1 
WHERE id = params[:user_id]
```

#### 멘토 삭제: 로그인 정보 아래 네번째 줄에서 파란색으로 되어있는 멘토 이메일 옆에 취소버튼이 있습니다. 이 버튼을 누르면 멘토, 멘티 연결이 끊어집니다.

```
UPDATE user SET mentor_id = nil 
WHERE id = current_user.id
UPDATE user SET menteeNum = menteeNum - 1 
WHERE id = c_u.mentor.id
```

![11](https://drive.google.com/uc?export=view&id=1i8CeIOL_zIpngclurrsthF9LmHQGXERW)

---

### 도서별 독자수(각 책들을 몇 명이 읽었는지 보여줌)

#### 특징: 책들이 책을 완독한 사람 수의 내림차순으로 정렬 되어있습니다. 유저 리스트 테이블에서 ‘도서별 독자수’ 버튼을 누르면 들어올 수 있습니다.

```
SELECT sum(b.reader) as sr, b.genre as genre
FROM book b, read r
WHERE b.id = r.book_id
AND r.status = true
GROUP BY genre
ORDER BY sum(b.reader) DESC, b.genre ASC
```

![14](https://drive.google.com/uc?export=view&id=10UXjy8_EfGZOuhE5PHeVlffz6tN2RR6o)

---

### 장르별 읽힌 권수(사용자들 사이에서 가장 많이 읽힌 장르를 읽힌 권수의 내림차순으로 보여줍니다.)

#### 특징: 장르들이 읽힌 권수의 내림차순으로 정렬 되어있습니다. 유저 리스트 테이블에서 ‘장르별 읽힌 권수’ 버튼을 누르면 들어올 수 있습니다.

```
SELECT b.title as title, b.reader as reader
FROM book b, read r
WHERE b.id = r.book_id
AND r.status = true
ORDER BY reader DESC, title ASC
```

![15](https://drive.google.com/uc?export=view&id=1ZHbgiuN_pn7Do6y15hgQ3bpDfUvEaNIb)

---

### 멘티 정보(현재 사용자를 멘토로 삼은 멘티들의 목록)

#### 특징: 로그인 정보 하단 5번째 줄의 멘티에서 ‘X명’ 버튼을 누르면 들어올 수 있습니다. 

```
SELECT *
FROM user
WHERE mentor_id = '#{current_user.id}'
```

![16](https://drive.google.com/uc?export=view&id=10re0AhAEyzK1TLnuaMmvJ7POpdbeklHK)

---

### 멘토 정보 (현재 사용자의 멘토 정보)

#### 특징: 로그인 정보 하단 4번째 줄의 멘토에서 파랗게 되어있는 멘토의 이메일 버튼을 누르면 들어올 수 있습니다.

```
SELECT id, email, name, created_at, readVol, menteeNum, favGenre, favGenreVol 
FROM user
WHERE id = (SELECT mentor_id
            FROM user
            WHERE id = '#{current_user.id}')
```

![17](https://drive.google.com/uc?export=view&id=1k_P1pEKXQGHEpzY1yTj1R1lozq6TJWsO)

---

### 멘토 독서 정보 (현재 사용자의 멘토 독서 정보)

#### 특징: 상단 멘토 정보 보기 페이지에서 멘토 유저 정보 테이블의 애트리뷰트, 독서량의 값 버튼을 누르면 들어올 수 있습니다. 멘토가 다 읽은 책들을 보여줍니다.

```
SELECT b.title as title, b.author as author, b.page as page, b.genre as genre, (r.finish - r.start) as ct
FROM user u, book b, read r
WHERE u.id = r.user_id
AND r.book_id = b.id
AND r.status = true
AND u.id = '#{params[:user_id]}'
```

![18](https://drive.google.com/uc?export=view&id=1yejNcVW7t6STVJXVYOl16ooXlkcbak2z)

---

### 멘토의 멘티 정보 (현재 사용자의 멘토가 가지는 멘티 정보)

#### 특징: 상단 멘토 정보 보기 페이지에서 멘토 유저 정보 테이블의 애트리뷰트, 멘티 수의 값 버튼을 누르면 들어올 수 있습니다.현재 사용자가 자신의 멘티 정보를 보듯이 멘토의 멘티 정보를 볼 수 있습니다. 

```
SELECT *
FROM user
WHERE mentor_id = '#{params[:user_id]}'
```

![19](https://drive.google.com/uc?export=view&id=1bPnDA8dt_akTnVfvx0HqiEg-dtPMJdLE)

---

## 9. 설계 결과 및 후기
&nbsp;&nbsp;&nbsp;&nbsp;각 테이블에 레코드의 추가, 삭제, 갱신이 원활하게 이루어지며, 이를 기반으로 생성된 데이터베이스를 기능에 맞게 잘 조회하여 독서습관형성 서비스의 설계목적을 달성하였다고 본다. 처음 프로젝트 아이디어 구상 후에 응용프로그램의 요구에 맞는 테이블을 설계하는 과정에서 개념적으로 ERD작성하고 그것을 논리적 다이어그램으로 사상하는 과정을 통해 각 테이블이 어떤 관계를 갖으며 어떤 애트리뷰트를  갖게 될 지 잘 고민했고 설계한 결과 실제 SQL DB를 다루는 시점에서는 애트리뷰트를 추가하거나 애트리뷰트의 도메인을 수정하는 작업들을 하지 않을 수 있었다. <u><strong>특히 ERD에서 각 테이블의 관계에 대해 부분참여, 전체참여를 결정하는 단계와 테이블 설계 시 설정한 참조 무결성 제약조건은 Query문 작성 및 실행을 진행하는 동안 큰 문제없게 해준 주요 요인이었다고 생각한다.</strong></u>    <br/><br/>
&nbsp;&nbsp;&nbsp;&nbsp;Ruby on Rails를 이용하여 이번 프로젝트를 진행하였지만 DB에 대한 접근, 조작은 Ruby 코드가 아닌 SQL문을 직접 대입하여 조작하였고 그 과정에서 Rails와 SQL를 동시에 사용함으로써 데이터베이스의 활용측면에서 도움이 되는 시간이었다. 초기에 기획했던 대부분의 기능들은 구현을 완료했으나 시간이 촉박하여 몇몇 기능과 사용자 UI적인 설계 측면에서의 아쉬움이 남는다. 수치적으로 100% 목표 달성을 이루었다고 할 수는 없으나, 전체적으로 보았을 때 90% 이상의 목표를 달성하여 만족한다.  <br/><br/>
&nbsp;&nbsp;&nbsp;&nbsp;데이터베이스 수업을 듣기 전에도 웹개발을 해본 적이 있었다. 개념적 설계를 업신여기며 바로 명령어를 치면서 테이블 작성을 했던 그때와 비교해서 보고서 작성을 위해서라도 진행해야 했던 ERD, 논리적 schema작성은 구현단계에서 튼튼한 밑거름이 되어주었고 실제 구현단계에서 오히려 더 빠르게 진행할 수 있었다.  ‘학교 강의는 현업에서 응용될 성격이 아니지 않나’라는 내 마음 속 의문을 ‘탄탄한 기초가 응용을 소화해내는 것’이라는 결론으로 정리할 수 있었던 시간이다.