<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.google.gson.GsonBuilder"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="com.google.gson.JsonArray"%>
<%@ page import="com.google.gson.JsonElement"%>
<%@ page import="java.lang.Math" %>



<%@ include file = "./include/utils.jsp" %>
<%@ include file = "./include/config.jsp" %>
<%@ include file = "./include/global.jsp" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
		<meta charset="UTF-8"> 
		<meta name="viewport" content="width=device-width,initial-scale=1" /> 
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
		<title>통합검색 예제</title>

		<!--[if lt IE 9]>
		<script src="./resources/js/html5shiv.min.js" type="text/javascript"></script>
		<![endif]-->

		<link rel="stylesheet" href="./resources/css/flatpickr.min.css" type="text/css" />
		<link rel="stylesheet" href="./resources/css/flatpickr_airbnb.css" type="text/css" />
		<link rel="stylesheet" href="./resources/css/search_common.css" type="text/css" />
		<link rel="stylesheet" href="./resources/css/search.css" type="text/css" />
		<link rel="stylesheet" href="./resources/css/search_responsive.css" type="text/css" />
		<link rel="stylesheet" href="./resources/fonts/font.css" type="text/css" />
		<link rel="stylesheet" href="./resources/css/fontawsome.css" type="text/css" />
		<!--[if lt IE 9]>
		<link rel="stylesheet" href="./resources/css/ie8.css" type="text/css" />
		<![endif]-->
		<!--[if lt IE 8]>
		<link rel="stylesheet" href="./resources/css/ie7.css" type="text/css" />
		<![endif]-->

		<script src="./resources/js/placeholders.min.js" type="text/javascript"></script>
		<script src="./resources/js/flatpickr.js" type="text/javascript"></script>
		<script src="./resources/js/flatpickr_ko.js" type="text/javascript"></script>
		<script src="./resources/js/jquery-1.12.4.min.js" type="text/javascript"></script>
		<script src="./resources/js/search.js" type="text/javascript"></script>
		<!--[if lt IE 9]>
		<script src="./resources/js/ie8.js"></script>
		<script src="./resources/js/respond.min.js"></script>
		<![endif]-->

	</head>
	<body>

		<div class="wrap">
			<form name="param" action="./" method="post">
				<!-- 검색관련 파라미터 설정 -->
				<input type="hidden" class="param" name="sort" value="<%=sort%>"/>
				<input type="hidden" class="param" name="qy" value="<%=qy%>"/>
				<input type="hidden" class="param" name="target" value="<%=target%>"/>
				<input type="hidden" class="param" name="pagemax" value="<%=pagemax%>"/>
				<input type="hidden" class="param" name="pagenum" value="<%=pagenum%>"/>
				<input type="hidden" class="param" name="reSrh" />
				<input type="hidden" class="param" name="preQuery" value="<%=preQuery%>"/>
				<input type="hidden" class="param" name="dateSrh" value="<%=dateSrh%>"/>
				<input type="hidden" name="accor" value="<%=accor%>"/>
				<input type="hidden" class="param" name="allFieldFilter" value="<%=allFieldFilter%>"/>
				<input type="hidden" class="param" name="fieldFilter" value="<%=fieldFilter%>"/>
				<header>
					<h1><a href=" " title="로고"></a></h1>
					<div class="srh_bar ml15">
						<input type="text" name="query" id="qry" value="<%=query%>" autocomplete="off" placeholder="검색어를 입력해주십시오." ><!-- onclick="openSug();" /> -->
						<!-- 검색어자동완성 시작 -->
						<!-- TODO MIR-Suggester와 연동 필요 -->
						<%--<div class="suggester hidden">
							<ul>
								<li><b>전기</b></li>
								<li><b>전기</b>안전공사<b>전기</b>안전공사<b>전기</b>안전공사<b>전기</b>안전공사<b>전기</b>안전공사<b>전기</b>안전공사<b>전기</b>안전공사</li>
								<li><b>전기</b> 점검</li>
								<li><b>전기</b> 점검 시스템 표준화</li>
								<li><b>전기</b> 합선</li>
								<li>한국전력공사 <b>전기</b> 문의</li>
								<li><b>전기</b> 안전 수칙</li>
								<li>전력 발전 <b>전기</b></li>
								<li>저항과 <b>전기</b></li>
								<li><b>전기</b> 발전</li>
							</ul>
							<ul>
								<li class="closeSug" onclick="closeSug();">검색어 자동완성 끄기</li>
							</ul>
						</div>--%>
						<!-- 검색어자동완성 끝 -->
						<input type="button" value="" class="goSearch"/>
						<button type="button" class="help_btn">?</button>
						<p class="help_guide hidden">
							<b>고급 검색 방법</b><br /><br />
							<b>AND 검색</b><br />AND 연산자('<%=opAnd%>') 뒤에 오는 단어가 반드시 포함된 검색 결과를 출력합니다.<br />예시) 전기  안전 => '전기'와 '안전' 두 검색어가 반드시 포함된 검색 결과를 출력합니다.<br /><br />
							<b>OR 검색</b><br />OR 연산자('<%=opOr%>') 연산자 뒤에 오는 단어를 포함한 검색 결과를 출력합니다.<br />예시) 전기 +안전 => 검색어 '전기' 또는 '안전' 둘 중 하나라도 포함됐다면 검색 결과로 출력합니다.<br /><br />
							<b>NOT 검색</b><br />NOT 연산자('<%=opNot%>') 뒤에 오는 단어를 제외시킨 검색 결과를 출력합니다.<br />예시) 전기 -안전 => 검색어 '전기'를 검색 했을 때, '안전' 검색어가 제외된 결과만을 출력합니다.
						</p>

					</div>
					<p class="ml10"><input type="checkbox" class="param" id="reSrh" /><label for="reSrh">결과 내 재검색</label></p>
				</header>

				<!-- 카테고리 시작 -->
				<nav class="srh_ctg"> 
					<hr />
					<ul>
						<% for(int k=0; k<=tempCollList.length-1; k++){ %>
							<li class="menu <%if( k == target ){%> selected<%}%>"><a href="javascript:clickMenu(<%=k%>);"><%=targetNameList[k]%></a></li>
							
						<%} %>
					</ul>

				</nav>
				<!-- 카테고리 종료 -->
				<div class="contents_wrap">

					<!-- 상세검색 시작 -->
					<div class="dt_srh <%if(accor.equals("open")){ %>active<%}%>">
						<section class="best_word"><button class="active" type="button">인기검색어</button>
							<ul class="best_word_type">
								<li>
									<span><a href="javascript:changeBestword('Daily')" id="Daily" class="best_word_ty active">일일</a></span>
									<span><a href="javascript:changeBestword('weekly')" id="weekly" class="best_word_ty">주간</a></span>
									<span><a href="javascript:changeBestword('monthly')" id="monthly" class="best_word_ty">월간</a></span>
									
								</li>

							</ul>
							<ul class="best_word_wrap">
								<li>인기검색어 불러오는중 ..</li>
							</ul>
						</section>
						<%--<section class="best_word"><button class="active" type="button">연관검색어</button>-->
							<!-- TODO MIR-Pharos와 연동 필요 -->
						<ul>
								<li>연관단어 없음</li>
						</ul> 
						</section>
						<section class="best_word"><button class="active" type="button">내가찾은 검색어</button>
							<!-- TODO Cookie를 사용하여 내가찾은 검색어기능 추가 필요-->
							
							<ul>
								<li>내가찾은 검색어 없음</li>
							</ul>
						</section>
						<section class="dt_date"><button class="active" type="button">날짜 검색</button>
							<ul>
								<li><input type="radio" name="dtDate" id="dall" <%if( dateSrh.equals("dall")){ %>checked<%} %>/><label for="dall">전체</label></li>
								<li><input type="radio" name="dtDate" id="d1w" <%if( dateSrh.equals("d1w")){ %>checked<%} %>><label for="d1w">1주일</label></li>
								<li><input type="radio" name="dtDate" id="d1m" <%if( dateSrh.equals("d1m")){ %>checked<%}%>/><label for="d1m">1개월</label></li>
								<li><input type="radio" name="dtDate" id="d3m" <%if( dateSrh.equals("d3m")){ %>checked<%} %>/><label for="d3m">3개월</label></li>
								<li><input type="radio" name="dtDate" id="d1y" <%if( dateSrh.equals("d1y")){ %>checked<%} %>/><label for="d1y">1년</label></li>
								<li><input type="radio" name="dtDate" id="dcst" <%if( dateSrh.equals("dcst")){ %>checked<%} %>><label for="dcst">직접입력</label></li>
							</ul>
						</section>--%>
						<section class="dt_date_di"><button class="date-cst active" type="button">날짜 직접입력</button>
							<ul>
								<li><input type="text" class="dtSrh flatpickr1 flatpickr-input param" name="startDate" value="<%=startDate %>" readonly="readonly" date-id="datetime" value="<%=startDate %>"/><span>부터</span></li>
								<li><input type="text" class="dtSrh flatpickr2 flatpickr-input param" name="endDate" value="<%=endDate %>" readonly="readonly" date-id="datetime" value="<%=endDate%>" /><span>까지</span></li>
								<script>
									// 탐색 대상이  rms가 아닐 때만  flatpickr 를 사용
									// 날짜 직접입력 flatpickr 사용
									var flatpickr1 = document.querySelector(".flatpickr1");
									flatpickr1.flatpickr({
										locale: "ko",
										altInput: true,
										altFormat: "Y.m.d",
										dateFormat: "Y.m.d"
									});
									var flatpickr2 = document.querySelector(".flatpickr2");
									flatpickr2.flatpickr({
										locale: "ko",
										altInput: true,
										altFormat: "Y.m.d",
										dateFormat: "Y.m.d" 
									});
								</script>
							</ul>
						</section>
						<% if( colList.equals("news") || colList.equals("news2") || colList.equals("news3") || colList.equals("news4") || colList.equals("news5") || colList.equals("news6") || colList.equals("news7") || colList.equals("news8") || colList.equals("news9") || colList.equals("news10") || colList.equals("news11") || colList.equals("news12") || colList.equals("news13") || colList.equals("news14") || colList.equals("news15") || colList.equals("news16") || colList.equals("news17")){%>
							<!-- 선택된 컬렉션이 뉴스검색일 경우 -->
							<section class="dt_area"><button class="active" type="button">영역 별 검색</button> 
								<ul>
									<li><input type="checkbox" class="dtSrh-checkbox" id="allField" <%if(allFieldFilter){ %>checked<%} %> /><label for="allField">전체</label></li>
									<li><input type="checkbox" class="dtSrh-checkbox" name="field" id="title" <%if(fieldFilter.indexOf("title") >= 0 || allFieldFilter ){ %>checked<%} %>/><label for="title">제목</label></li>
									<li><input type="checkbox" class="dtSrh-checkbox" name="field" id="contents" <%if(fieldFilter.indexOf("contents") >= 0 || allFieldFilter ){ %>checked<%} %>/><label for="contents">내용</label></li>
								</ul>
							</section>
						<%-- <section class="dt_file"><button class="active" type="button">첨부파일 확장자</button>
							<ul>
								<li><input type="checkbox" class="dtSrh-checkbox" id="allFileExt" <%if(allFileExtFilter){ %>checked<%} %>/><label for="allFileExt">전체</label></li>
								<li><input type="checkbox" class="dtSrh-checkbox" name="fileField" id="pdf" <%if(fileExtFilter.indexOf("pdf") >= 0 || allFileExtFilter ){ %>checked<%} %>/><label for="pdf">pdf</label></li>
								<li><input type="checkbox" class="dtSrh-checkbox" name="fileField" id="xlsx" <%if(fileExtFilter.indexOf("xlsx") >= 0 || allFileExtFilter ){ %>checked<%} %>/><label for="xlsx">xlsx</label></li>
								<li><input type="checkbox" class="dtSrh-checkbox" name="fileField" id="doc" <%if(fileExtFilter.indexOf("doc") >= 0 || allFileExtFilter ){ %>checked<%} %>/><label for="doc">doc</label></li>
								<li><input type="checkbox" class="dtSrh-checkbox" name="fileField" id="hwp" <%if(fileExtFilter.indexOf("hwp") >= 0 || allFileExtFilter ){ %>checked<%} %>/><label for="hwp">hwp</label></li>
								<li><input type="checkbox" class="dtSrh-checkbox" name="fileField" id="pptx" <%if(fileExtFilter.indexOf("pptx") >= 0 || allFileExtFilter ){ %>checked<%} %>/><label for="pptx">pptx</label></li>
							</ul>
						</section> --%>
						
						<%}%>

						<section class="tc">
							<input type="button" id="detailSearchBtn" value="설정 조건으로 검색" class="goSearch" onclick="saveSearch()"/>
							<script>
							
							</script>
						</section>
						
					</div>
					<!-- 상세검색 종료 -->

					<!-- 검색 결과 시작 -->
					<div class="srh_ctn <%if(accor.equals("open")){ %>active<%}%>">
						<div class="srh_cmb_rst mb15">
							<p><%=targetNameList[target] %>에서 "<font color="#0e448e"><b><%=query %></b></font>"에 대한 검색 결과는 총 <font color="#e73233"><b class="total-count"><%=totalCount %></b></font>건 입니다.</p>
							<div class="srh_ctrl">
								<%if(target!=0){ // 1-S %>
								<select id="pagemax">
									<option value="5" <%if(pagemax.equals("5")) {%>selected<%} %>>5건씩 출력</option>
									<option value="10" <%if(pagemax.equals("10")) {%>selected<%} %>>10건씩 출력</option>
									<option value="20" <%if(pagemax.equals("20")) {%>selected<%} %>>20건씩 출력</option>
									<option value="30" <%if(pagemax.equals("30")) {%>selected<%} %>>30건씩 출력</option>
									<option value="50" <%if(pagemax.equals("50")) {%>selected<%} %>>50건씩 출력</option>
									<option value="100" <%if(pagemax.equals("100")) {%>selected<%} %>>100건씩 출력</option>
								</select>
								<%} // 1-E %>

								<select id="sort">
									<option value="regdate+desc" <%if(sort.equals("regdate+desc")) {%>selected<%} %>>최신순</option>
									<option value="regdate+asc" <%if(sort.equals("regdate+asc")) {%>selected<%} %>>오래된순</option>
									<option value="score+desc" <%if(sort.equals("score+desc")) {%>selected<%} %>>정확도순</option>
								</select>
							</div>
						</div>

						<% if( Code == 200 ) { // 2-S %>
							<%if( totalCount == 0 ){ // 3-S %>
								<!-- 검색 결과가 없을 경우 -->
								<div class="nosearch">
									<i class="fas fa-inbox"></i>
									<ul>
										<li>검색어 [ <font color="#e73233"><b><%=query%></b></font> ] 에 대한 결과가 없습니다.</li>
										<li>단어의 철자가 정확한지 확인해 주세요.</li>
										<li>보다 일반적인 단어로 검색해보세요.</li>
									</ul>
								</div>
							<%}else{%>
								<!-- 검색대상 컬렉션별로 검색결과를 가져온다. -->
								<%for( String colNm : colList.split(",")){ // 4-S %>
									<%
									JsonObject collection = searchResult.get(colNm).getAsJsonObject();
									int resultCount = collection.get("ResultCount").getAsInt();
									int i = Arrays.asList(tempCollList).indexOf(colNm);
									String colAlias = targetNameList[i];
									JsonArray results = collection.get("Results").getAsJsonArray();
									%>
									<%if(resultCount>0){ // 5-S %>

										<section class="result-wrap">
											<div class="<%=colNm %>-wrap">
												<p class="sec_tit"  <%if(target!=0) {%>style="display:none;"<%} %>><b class="cate-nm"><%=colAlias %></b>
													<span class="result-info">
														총 <b class="result-count"><%=resultCount%></b>건이 검색되었습니다.
														<%if(resultCount>Integer.parseInt(pagemax)){%>
															<!-- 통합검색이고 카테고리 결과건수가 pagemax 값보다 클 경우, 결과 더보기 출력 -->
															<a class="more" href="javascript:clickMenu(<%=i%>)">결과더보기</a>
														<%}%>
													</span>
												</p>

												<div class="<%=colNm%>-attach search-attach"></div>
											</div>
											<% for( JsonElement item : results ) { // 6-S %>
												<% JsonObject result = item.getAsJsonObject(); %>
												<%if( colNm.equals("news") || colNm.equals("news2") || colNm.equals("news3") || colNm.equals("news4") || colNm.equals("news5") || colNm.equals("news6") || colNm.equals("news7") || colNm.equals("news8") || colNm.equals("news9") || colNm.equals("news10") || colNm.equals("news11") || colNm.equals("news12") || colNm.equals("news13") || colNm.equals("news14") || colNm.equals("news15") || colNm.equals("news16") || colNm.equals("news17")){ // 7-S %>
													<%
														// 필요한 필드 가져오기
														String title = result.get("@title").getAsString();
														String tag = result.get("office_name").getAsString();
														String fileNm = result.get("@file_nm").getAsString();
														String[] fileNmList = isNotEmpty(fileNm)? fileNm.split("$") : null;
														String deptNm = result.get("sid1_name").getAsString();
														String deptNm2 = result.get("sid2_name").getAsString();
														String writer = result.get("@email_list").getAsString();
														String positionNm = result.get("position_nm").getAsString();
														String regdate = result.get("regdate").getAsString();
														String mirsummary = result.get("@_mirsummary").getAsString();
														String src = result.get("img_list").getAsString();	
														String nhnUrl = result.get("nhn_url").getAsString();
														String contents = result.get("@contents").getAsString();

														
													%>
													<article class="<%=colNm%>">

														<div class="result-text">
															<p class="atc_tit">
																<span class="tag"><%=tag%></span>
																<a class="link" href="javascript:window.open('<%=nhnUrl%>');"><%=title%></a>
															</p>
															<p class="atc_cts"><a class="link" href="javascript:window.open('<%=nhnUrl%>');"><%=mirsummary%></a></p>
															
															<%-- <% if( isNotEmpty(fileNm) ){%>
																<!-- 첨부파일이 있을 경우만 출력 -->
																<% for( String file : fileNmList ){ %>
																	<p class="atc_etc">
																		<a class="link" href="javascript:openPopup('<%=nhnUrl%>');"><i class="fas fa-folder" style="color:#2196f3;"></i><span class="etc-value folder-path"><%=file%></span></a>
																	</p>
																	
																<%}%>

															<%}%>--%>

															<%--<p class="atc_sum"><a class="link" href="javascript:window.open('<%=nhnUrl%>');"><%=mirsummary%></a></p>--%>
															<p class="atc_etc">
																<i class="fas fa-user"></i><span class="etc-name">부분</span><span class="etc-value draft-dept"><%=deptNm%></span>
																<i class="fas fa-user"></i><span class="etc-name">작성자</span><span class="etc-value draftname"><%=writer%> <%=positionNm%></span>
																<i class="fas fa-calendar-alt"></i><span class="etc-name">뉴스날짜</span><span class="etc-value regdate2"><%=regdate%></span>																
															</p>
 
															
														</div>
														<% if(isNotEmpty(src)){%>
														<div class="result-thumbnail hover-pointer" onclick="javascript:openPopup('<%=src%>');" style="background-image: url(<%=src%>)"></div>
														<%}%>
													</article>

												<%} // 7-E %>
												
												

												
												

											<%} // 6-E %>
										</section>
										<%
										
										
										%>					

										<% if( target != 0 && !colNm.equals("img") ){ // 8-S 페이징시작 %>
											<!-- 통합검색이 아니고, 이미지 검색이 아닐경우 페이징 버튼 출력(* 이미지는 무한스크롤 처리)-->
											<%
												int totalpage = 0 ;
												int resultcount = totalCount;
												int pagenum_int = Integer.parseInt(pagenum);
												int pagemax_int = Integer.parseInt(pagemax);

												if((resultcount%pagemax_int)==0){
													totalpage = resultcount/pagemax_int;
												} else {
													totalpage = (resultcount/pagemax_int)+1;
												}
												int middle = (((int) ((double)pagenum_int / 10 + 0.9)) - 1) * 10 + 1;
												int curpage_m = 1;
												int curpage_p = totalpage;

												curpage_m = pagenum_int - 10;
												if(curpage_m <= 0){
													curpage_m = 1;
												}
												curpage_p = pagenum_int + 10;
												if(curpage_p > totalpage){
													curpage_p = totalpage;
												}
												int pre_page=pagenum_int-1;
												int aft_page=pagenum_int+1;

												int total_floor=(int)(totalpage-(totalpage%10));		//마지막 페이지 내림값

												int cur_floor=(int)(pagenum_int-(pagenum_int%10));		//현재 페이지 내림값
												if((pagenum_int%10)==0){
													cur_floor-=1;				//현재 페이지가 1의 자리가 0일 경우는 현재 10단위의 페이징에서 가장 마지막 페이지라는 뜻이므로 1을 빼줌
												}
												int	cur_ceil=(int)(pagenum_int-(pagenum_int%10));		//현재 페이지 올림값
												cur_ceil+=10;

											%>
											<!-- 상세검색 페이지이면서 이미지 검색이 아닐경우 페이징 보이기 (*이미지는 무한스크롤 처리) -->
											<div class="paging">

												<% if(cur_ceil!=10 && pagenum_int!=10){ %>
													<!-- 첫 페이지 블럭이 아닐 경우 맨앞으로 버튼 출력 -->
													<ul class="paging-prev">
														<li class="prev"><a href="javascript:mvPg(1,<%=pagemax%>);"><i class="fas fa-angle-left"></i></a></li>
													</ul>
												<%}%>
												<%if(pagenum_int!=1){ %>
													<!-- 한 페이지 이전으로 버튼 -->
													<ul class="paging-prev">
														<li class="prev"><a href="javascript:mvPg('<%=pagenum_int-1%>',<%=pagemax%>);"><i class="fas fa-angle-left"></i></a></li>
													</ul>
												<%}%>

												<ul class="pg_num">
													<%for(int m=middle; m<=totalpage; m++) {%>
														<!-- 페이지 번호 버튼 출력-->
														<%if(m>=(pagemax_int+middle)){break;}%>
														<%if(pagenum_int==m) {%>
															<!-- 현재페이지 버튼일 경우 -->
															<li class="pg_num_dummy" style="background-color: rgb(14, 68, 142);"><a href="#none" style="color: rgb(241, 241, 241);"><%=m%></a></li>
														<%}else{%>
															<!-- 현재페이지 버튼이 아닐 경우 -->
															<li class="pg_num_dummy"><a href="javascript:mvPg('<%=m%>',<%=pagemax%>);"><%=m%></a></li>
														<%}%>
													<%}%>
												</ul>

												<%if(pagenum_int!=totalpage){ %>
													<!-- 한 페이지 다음으로 버튼 -->
													<ul class="paging-next">
														<li><a href="javascript:mvPg('<%=pagenum_int+1%>',<%=pagemax%>);"><i class="fas fa-angle-right"></i></a></li>
													</ul>
												<%}%>

												<%if(pagenum_int!=totalpage && total_floor!=cur_floor){%>
													<!-- 현재 페이지가 마지막 페이지 블럭이 아닐 경우 맨뒤로 버튼 출력-->
													<ul class="paging-next">
														<li><a href="javascript:mvPg('<%=totalpage%>',<%=pagemax%>);"><i class="fas fa-angle-right"></i></a></li>
													</ul>
												<%}%>
											</div>
										<%} // 8-E 페이징 끝 %>
									<%} // 5-E %>
								<%} // 4-E %>
							<%} // 3-E %>
						<%}else{%>
							<!-- 검색결과코드가 성공(200)코드가 아닐 경우 -->
							<div class="nosearch">
								<i class="fas fa-inbox"></i>
								<ul>
									<li>검색어 [ <font color="#e73233"><b><%=query%></b></font> ] 에 대한 결과가 없습니다.</li>
									<li>단어의 철자가 정확한지 확인해 주세요.</li>
									<li>보다 일반적인 단어로 검색해보세요.</li>
								</ul>
							</div>
							<script>
								// 오류 발생시, 화면에는 검색결과가 없다고 띄우고 개발자만 볼수 있도록 콘솔에 출력할것.
								console.error("[ 통합 검색 오류 ] <%=Message%>");
							</script>
						<%} // 2-E%>

					</div>
				</div>
			</form>
		</div>
	</body>
</html>
<script>
	$(document).ready(function(){
		// 인기검색어 불러오기
		setBestword();
	});
	function changeBestword(mode){
		$('.best_word_ty').removeClass('active');
		setBestword(mode);
		$("#"+mode).addClass('active');
	}
	function setBestword(mode){
		if(!mode) mode = "Daily";
		const target = $(".best_word_wrap");
		target.html($("<li>인기검색어 불러오는중 ..</li>"))
		$.ajax({
			url: "./include/bestword.jsp?target_bestword="+mode,
			type: "GET",
			dataType: "json",
			success: function (res) {
				target.html("")
				console.log(res);
				if (res && res.code === 200) {
					if (res.data.Code !== 0) {
						// 검색오류
						console.error("오류로 인하여 데이터를 불러올 수 없습니다." + res?.data?.message);
					} else {
						const KeywordList = res.data.KeywordList;

						if( KeywordList.length === 0 ){
							target.html($("<li>인기검색어 없음</li>"));
						}else{
							for (let i in KeywordList) {
								const bestword = KeywordList[i];
								if( i < 10 && bestword.Key !== "" ){
									const div = $("<li><a href=\"#none\"><span class=\"rank\">"+(i*1+1)+"</span><span class=\"word\">"+(bestword.Key?bestword.Key:"-")+"</span></a></li>")
									div.click(function () {
												goSearch(bestword.Key);
									});
									target.append(div);
								 }
								

							}
						}
					}

				} else {
					target.html($("<li>인기검색어 없음</li>"));
					console.error("오류로 인하여 데이터를 불러올 수 없습니다." + res?.message);
				}
			},
			error: function (err) {
				target.html($("<li>인기검색어 없음</li>"));
				console.error("오류로 인하여 데이터를 불러올 수 없습니다." + err?.message);
			}
		})
	}
</script>
<%if(target!=0&& tempCollList[target].equals("img") ){	// 10-S %>
<!-- 이미지 검색일 경우 무한스크롤 제공 -->
<script>
	let $pagenum = <%=pagenum%> + 1;
	let $noMoreResult = false;
	let $processing = false;

	$(window).scroll(function(){
		var scrT = $(window).scrollTop();
		if(scrT >= $(document).height() - $(window).height()){
			//스크롤이 끝에 도달했을때 실행될 이벤트
			if( !$noMoreResult && !$processing){
				$processing = true;
				searchImg();
			}
		}
	});



	function searchImg() {
		$.ajax({
			url: "./include/asyncSearch.jsp?query=<%=query%>&pagemax=<%=pagemax%>&pagenum="+$pagenum+"&target=<%=Arrays.asList(tempCollList).indexOf("img")%>",
			type: "GET",
			dataType: "json",
			success: function (res) {
				console.log(res);
				if (res && res.code === 200) {
					$pagenum += 1;
					if (res.data.Code !== 0) {
						// 검색오류 
						console.error("오류로 인하여 데이터를 불러올 수 없습니다." + res?.data?.message); 
					} else {
						const collection = res.data.img;
						const results = collection ? collection.Results : [];
						const target = $(".img-wrapper").last();
						if( results.length === 0 ){
							$noMoreResult = true;
						}
						for (let i in results) {
							const img = results[i];
							const div = $("<div class=\"img-wrapper\" onclick=\"javascript:openPopup('" + img.url + "')\" style=\"background-image: url(" + img.src + ")\"></div>")
							target.after(div)
						}
					}


				} else {
					console.error("오류로 인하여 데이터를 불러올 수 없습니다." + res?.message);
				}
			},
			error: function (err) {
				console.error("오류로 인하여 데이터를 불러올 수 없습니다." + err?.message);
			},
			done: function () {
				$processing = false;
			}
		})

	}
</script>
<%} // 10-E%>