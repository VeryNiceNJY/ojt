<%@ page language="java" pageEncoding="UTF-8"%>
<%!
    String serverhost	= "1.214.210.85";       // 검색서버 IP
    String searchport 	= "4804";               // 검색서버 포트
    String adminport 	= "4803";               // 검색관리기 서버 포트
    String inCharset = "UTF-8";                 // 검색서버 요청 인코딩
    String outCharset = "UTF-8";                // 검색서버 출력 인코딩
    String parser = "type_one";                 // 검색 파서
    int timeout = 120000;                       // 검색 서버 연결 타임아웃 시간(msec단위)

    String opAnd = "*";                         // 검색 파서에 설정한 AND 연산자
    String opOr = "+";                         // 검색 파서에 설정한 OR 연산자
    String opNot = "-";                         // 검색 파서에 설정한 NOT 연산자


    String tempCollList[]={"news,news2,news3,news4,news5,news6,news7,news8,news9,news10,news11,news12,news13,news14,news15,news16,news17","news","news2","news3","news4","news5","news6","news7","news8","news9","news10","news11","news12","news13","news14","news15","news16","news17"};			// 검색 대상 컬렉션명
    String targetNameList[]={"통합검색","연합뉴스","프레시안","뉴시스","머니투데이","파이낸셜뉴스","한국경제","이데일리","동아일보","문화일보","세계일보","한겨레","경향신문","오마이뉴스","노컷뉴스","내일신문","스포츠경향","아시아경제"};           // 컬렉션 별칭 목록

    // 가져올 필드 목록
    // layout.fld에 선언한 필드명(alias값으로 접근가능).
    // @를 붙이면 하이라이팅 태그(search.ini에 설정한)가 붙어 출력됨
    // _mirsummary는 동적색인요약문, _doc_summary 정적색인요약문    
    String fieldList = "id,news_no,@title,@_mirsummary,@dept_nm,position_nm,@file_nm,regdate,office_name,@contents,sid1_name,sid2_name,img_list,nhn_url,@email_list";


    int Code = 200;              // 검색 페이지 결과 코드 ( 0 : 정상, 그외 : 실패 )
    String Message = "Ok";      // 검색 페이지 결과 메세지

%>