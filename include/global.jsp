<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.JsonParser"%>
<%

    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");
    // 검색
    String query = interpret(request.getParameter("query"), "");                        // 검색어
    String qy = interpret(request.getParameter("qy"), "");                              // 인기검색어
    String sort = interpret(request.getParameter("sort"), "title+score+desc");                // 검색 정렬 차순
    int target = Integer.parseInt( interpret(request.getParameter("target"), "0") );    // 검색대상 컬렉션 인덱스. 0은 통합검색을 의미.

    // 결과내재검색
    boolean reSrh = Boolean.parseBoolean( interpret(request.getParameter("reSrh"), "false") );  // 결과내 재검색 여부
    String preQuery = interpret(request.getParameter("preQuery"), "");            // 이전검색어(결과 내 재검색시)

    // 날짜검색
    String dateFieldNm = "regdate";     // 날짜검색 필드명
    String startDate = interpret(request.getParameter("startDate"),"");							// 검색 결과 시작일자
    String endDate = interpret(request.getParameter("endDate"),"");								// 검색 결과 종료일자
    String dateSrh = interpret(request.getParameter("dateSrh"), "dall");						// 검색 결과 기간 - 기본 전체
    if(isNotEmpty(startDate) || isNotEmpty(endDate)) dateSrh = "dcst";

    // 페이징
    String pagenum = interpret(request.getParameter("pagenum"), "1");       // 페이지 번호
    String pagemax = interpret(request.getParameter("pagemax"), "10");      // 화면에 출력될 건수
    if( target == 0 ) pagemax = "3";                                        // 통합검색일 경우 결과 건수는 3건씩만 출력
    // if( tempCollList[target].equals("img") ) pagemax = "20";                // 이미지 컬렉션일 경우 20건씩가져오기

    // 상세검색
    String accor = interpret(request.getParameter("accor"),"open");									// 상세검색 오픈 여부 [ open | fold ]
    boolean allFieldFilter = Boolean.parseBoolean( interpret(request.getParameter("allFieldFilter"), "true") );	// 영역 필드 검색 - 전체 영역에서 검색 여부
    String fieldFilter = interpret(request.getParameter("fieldFilter"), "");									// 필드 검색

    String imageYn = interpret(request.getParameter("imageYn"),"any");      // 이미지 유무 검색

    // String fileExtFilter = interpret(request.getParameter("fileExtFilter"), "");				// 첨부파일 확장자 검색
    // boolean allFileExtFilter = Boolean.parseBoolean( interpret(request.getParameter("allFileExtFilter"), "true") );	// 영역 필드 검색 - 전체 영역에서 검색 여부

    String colList = tempCollList[target];              // 현재 선택된 카테고리(컬렉션)
    JsonObject searchResult = new JsonObject();         // 검색결과를 담을 JSON객체
    int totalCount = 0;                                 // 검색 결과 카운팅용 변수


    try{
        /*
        if( query.equals("") ){
            // 오류 1 : 검색어 없음
            Code = 400;
            Message = "검색어가 없습니다.";
            throw new Exception(Message);
        }
         */

        String tuningQuery = query.trim(); // 검색어 앞뒤 공백 제거
        if( !query.equals("") ){
            tuningQuery = cleanXSS(tuningQuery);		// 검색어 XSS 코딩 제거
            qy = query;                     // 인기검색어 설정 -> 관리기의 인기검색어 통계용도
        }



        // 필드 필터링 검색
        if( !allFieldFilter ){
            if( !fieldFilter.equals("") ){
                tuningQuery = String.format("((%s)<IN>%s)",tuningQuery,fieldFilter); // 전체 영역 검색이 아닐 시  필드 필터링 검색
                }else{
                tuningQuery = "(" + query + ")";
            }
        }else{
            tuningQuery = "(" + query + ")";
        }



        if( query.equals("") ){
            // 원래는 검색어가 없을 경우 검색을 요청하지 않지만, 샘플 데이터가 적으므로 검색어가 없을 경우 전체 데이터가 보이도록 처리
            tuningQuery = "_doc>=ㅣㅁ나우퍔ㅈ다기";
        }



        // 결과 내 재검색 및 이전 검색어 처리
        if( reSrh ){
            // 결과내재검색에 체크하였을 경우, 이전 검색어와 AND 연산자로 결합하여 검색 
            tuningQuery = preQuery + opAnd + tuningQuery;
        }
        // 다음 결과내재검색 체크를 할 경우를 위해 이전검색어를 설정
        preQuery = tuningQuery;



        // 날짜 검색 설정
        if( !startDate.equals("") || !endDate.equals("") ){
            String dateQuery = "";
            if( !startDate.equals("") ) dateQuery += String.format("(%s>=%s)",dateFieldNm,startDate);
            if( !startDate.equals("") && !endDate.equals("") ) dateQuery += opAnd;
            if( !endDate.equals("") ) dateQuery += String.format("(%s<=%s)",dateFieldNm,endDate);
            if( !startDate.equals("") && !endDate.equals("") ) dateQuery = "(" + dateQuery + ")";
            tuningQuery += opAnd + dateQuery;
        }


        String filter = "";
        // 이미지 유무 설정
        if(isNotEmpty(imageYn)){
            if(imageYn.equals("imageY") ) filter = "img_cnt>0";
            if(imageYn.equals("imageN") ) filter = "img_cnt=0";
        }



        // 파일 확장자 필터링 검색
        /*
        if( !allFileExtFilter ){
            if( !fileExtFilter.equals("") ){
                String filter = "";
                for( String ext : fileExtFilter.split(",")) filter += ext + opOr ;
                filter = filter.substring(0,filter.length()-1);
                tuningQuery += opAnd + String.format("((%s)<IN>%s)",filter,"EXT"); // 전체 영역 검색이 아닐 시  필드 필터링 검색
            }
        }
         */



        System.out.println("target=" + target + ", query = " + query + ",tuningQuery = " + tuningQuery + ", preQuery = " + preQuery );
        String searchURL = makeSearchURI(serverhost,searchport,tuningQuery,qy,inCharset,parser,colList,pagenum,pagemax,fieldList,sort);
        System.out.println("searchURL = " + searchURL );
        searchResult = parseStringToJson(getResponse(searchURL,timeout,outCharset));
        int searchCode = searchResult.get("Code").getAsInt();
        String searchMessage = searchResult.get("Message").getAsString();
        System.out.println("검색결과 코드 = " + searchCode + ", 검색결과 메세지 = " + searchMessage );
        if( searchCode != 0 ){
            Code = searchCode;
            Message = searchMessage;
            throw new Exception(Message);
        }

        //  총 검색결과 카운팅
        for( String colNm : colList.split(",")){
            JsonObject collection = searchResult.get(colNm).getAsJsonObject();
            totalCount += collection.get("ResultCount").getAsInt();
        }


    }catch(Exception e){
        e.printStackTrace();
        if( Code == 200 ){
            // 오류 2 : 페이지 오류
            Code = 500;
            Message = "[ 통합검색오류 ] " + e.getMessage();
        }
    }finally {
        System.out.println("Code = " + Code + ", Message = " + Message + ", totalCount = " + totalCount );
    }

%>