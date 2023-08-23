$(document).ready(function() {
    // 도움말
    $(".help_btn").mouseover(function() {
        $(".help_guide").fadeIn(300);
    });
    $(".help_btn").mouseleave(function() {
        $(".help_guide").fadeOut(300);
    });
    
    // 카테고리, 페이징(페이지 번호) 선택
    $(".srh_ctg ul li, .paging .pg_num li").click(function() {
        $(this).siblings().removeClass("selected");
        $(this).addClass("selected");
    });
    
    // 상세검색 버튼
    $(".dt_btn").click(function() {
        if($(this).hasClass("active")) {
            $(this).removeClass("active");
            $(".dt_srh").removeClass("active");
            $(".srh_ctn").removeClass("active");
            $("input[name='accor']").val("fold");
        } else {
        	$("input[name='accor']").val("open");
            $(this).addClass("active");
            $(".dt_srh").addClass("active");
            $(".srh_ctn").addClass("active");
        }
    });
    
    
    // 상세검색 내부 버튼
    $(".contents_wrap .dt_srh section > button").click(function() {
        if($(this).hasClass("active")) {
            $(this).removeClass("active");
            $(this).siblings("ul").slideUp(600);

        } else {
            $(this).addClass("active");
			$(this).siblings("ul").slideDown(600);

        }
    });
    
    // 체크박스 '전체' 선택
    $("#allField, #allFileExt").click(function() {
    	$(this).parent().siblings().children("input").prop("checked", $(this).prop("checked"));
    	$("input[name='"+$(this).attr("id")+"Filter']").val($(this).prop("checked"));
    })

    
    // 검색어자동완성
    $(".srh_bar input[type='text']").focusin(function() {
        //$(".suggester").removeClass("hidden");
    });
	$(".srh_bar input[type='text']").keydown(function() {
		$(".suggester").removeClass("hidden");
	});
    $(".srh_bar input[type='text']").focusout(function() {
        $(".suggester").addClass("hidden");
    });
    
    // 검색어자동완성 끄기
    $(".closeSug").click(function() {
        $(this).parents(".suggester").addClass("hidden");
    });
    
	// 검색창 엔터키 이벤트
	$("input[name=query]").keyup(function(e){
		if(e.keyCode == 13){
			goSearch($(this).val());
		}
	});
	//RMS 기안자 검색창 엔터키 이벤트
	$("input[name=rmd_drftr_nm],input[name=rcvr_nm]").keyup(function(e){
		if(e.keyCode == 13){
			goSearch();
		}
	});
	// 결과 내 재검색 체크 이벤트
	$("#reSrh").change(function(){
		if($(this).prop("checked")){
			$("input[name=reSrh]").val("true");
		}else{
			$("input[name=reSrh]").val("false");
		}
	});
	
	// 정렬값 변경시 이벤트
	$("#sort").change(function(){
		$("input[name=sort]").val($(this).val());
		goSearch();
	});
	
	// 페이지당 출력 건수 변경시 이벤트
	$("#pagemax").change(function(){
		$("input[name=pagemax]").val($(this).val());
		goSearch();
	});
	
	// 날짜 상세 검색 변경 이벤트
	$("input[name='dtDate']").change(function(){

		// 시작날짜 종료 날짜 셋팅		
		var dtDate = $(this).attr("id");
		
		var startDateTarget = $(".flatpickr1");
		var endDateTarget = $(".flatpickr2");
		switch( dtDate ) {
			default :
				startDateTarget.val("");
				endDateTarget.val("");
			break;			
			case "dall" :
				// 전체기간
				startDateTarget.val("");
				endDateTarget.val("");
				$("#startDatePckr option:eq(0)").attr("selected","selected");
				$("#endDatePckr option:eq(0)" ).attr("selected","selected");
			break;
			case "d1w" :
				// 일주일
				var d = new Date();
				var p = new Date();
				p.setDate(p.getDate()-7);
				
				var tMonth = ( (d.getMonth()+1) < 10 ) ? "0"+( d.getMonth()+1 ) : ( d.getMonth()+1 );
				var tDate = ( d.getDate() < 10 ) ? "0"+d.getDate() : d.getDate();			
				var today = d.getFullYear() + "." + tMonth + "." + tDate;
				
				
				var pMonth = ( (p.getMonth()+1) < 10 ) ? "0"+( p.getMonth()+1 ) : ( p.getMonth()+1 );
				var pDate = ( p.getDate() < 10 ) ? "0"+p.getDate() : p.getDate();
				var past = p.getFullYear() + "." + pMonth + "." + pDate;
				
				
				startDateTarget.val(past);
				endDateTarget.val(today);
			break;
			case "d1m" :
				// 한달전
				var d = new Date();
				var p = new Date();
				p.setMonth(d.getMonth()-1);
				p.setDate(d.getDate());
					
				var tMonth = ( (d.getMonth()+1) < 10 ) ? "0"+( d.getMonth()+1 ) : ( d.getMonth()+1 );
				var tDate = ( d.getDate() < 10 ) ? "0"+d.getDate() : d.getDate();			
				var today = d.getFullYear() + "." + tMonth + "." + tDate;
				
				var pMonth = ( (p.getMonth()+1) < 10 ) ? "0"+( p.getMonth()+1 ) : ( p.getMonth()+1 );
				var pDate = ( p.getDate() < 10 ) ? "0"+p.getDate() : p.getDate();
				var past = p.getFullYear() + "." + pMonth + "." + pDate;
				
				startDateTarget.val(past);
				endDateTarget.val(today);
				break;
			case "d3m" :
				// 3개월전
				var d = new Date();
				var p = new Date();
				p.setMonth(d.getMonth()-3);
				p.setDate(d.getDate());
					
				var tMonth = ( (d.getMonth()+1) < 10 ) ? "0"+( d.getMonth()+1 ) : ( d.getMonth()+1 );
				var tDate = ( d.getDate() < 10 ) ? "0"+d.getDate() : d.getDate();			
				var today = d.getFullYear() + "." + tMonth + "." + tDate;
				
				var pMonth = ( (p.getMonth()+1) < 10 ) ? "0"+( p.getMonth()+1 ) : ( p.getMonth()+1 );
				var pDate = ( p.getDate() < 10 ) ? "0"+p.getDate() : p.getDate();
				var past = p.getFullYear() + "." + pMonth + "." + pDate;
				
				startDateTarget.val(past);
				endDateTarget.val(today);
				break;
			case "d1y":
				// 1년전
				var d = new Date();
				var p = new Date();
				p.setFullYear(d.getFullYear()-1);
					
				var tMonth = ( (d.getMonth()+1) < 10 ) ? "0"+( d.getMonth()+1 ) : ( d.getMonth()+1 );
				var tDate = ( d.getDate() < 10 ) ? "0"+d.getDate() : d.getDate();			
				var today = d.getFullYear() + "." + tMonth + "." + tDate;
				
				var pMonth = ( (p.getMonth()+1) < 10 ) ? "0"+( p.getMonth()+1 ) : ( p.getMonth()+1 );
				var pDate = ( p.getDate() < 10 ) ? "0"+p.getDate() : p.getDate();
				var past = p.getFullYear() + "." + pMonth + "." + pDate;
				
				startDateTarget.val(past);
				endDateTarget.val(today);
				
				break;
			case "dcst":
				// 전체기간
				startDateTarget.val("");
				endDateTarget.val("");
				break;
		} 
		
		if($(this).prop("checked")) $("input[name='dateSrh']").val($(this).attr("id"));
		
		
		if( $(this).attr("id") =="dcst"){ 
			// 직접입력이면 직접입력 칸 슬라이드 다운
			//$(".dt_date_di").removeClass("display-none");
			//setTimeout(function(){
				if( !$(".date-cst").hasClass("active") ){ 
					$(".date-cst").addClass("active");
					$(".date-cst").siblings("ul").slideDown();
				}
			//},500);

			
		}else{
			// 직접입력이 아니면 직접입력 칸 슬라이드 업
			if( $(".date-cst").hasClass("active") ){ 
				$(".date-cst").removeClass("active");
				//$(".date-cst").siblings("ul").slideUp();
			}
			//setTimeout(function(){
			//	$(".dt_date_di").addClass("display-none");
			//},500);
			
		}
		
	});

	// 검색 버튼 이벤트
	$(".goSearch").click(function(){
		goSearch();
	});
	
	// 직접 입력 값 입력시 날짜 검색 라디오 버튼 직접입력으로 변경
	$("input[name='startDate'],input[name='endDate']").change(function(){
		$("#dcst").prop("checked",true);
	});

	// rms 영역별검색 라디오 버튼 변경시 이벤트
	$("input[name='dtRmsField']").change(function(){
		var rmdField = "";
		if( $(this).attr("id") != "dall" ) $("input[name=rmsField]").val($(this).attr("id"));
	});
	
	// 검색창 포커싱
	// $("input[name=query]").focus();


	// 필드 리스트 변경 시 이벤트
	$("input[name='field']").change(function(){
		var fieldFilter = "";
		var flag = true;
		$("input[name='field']").each(function(idx,arr){
			
			if($(this).prop("checked")){
				fieldFilter += $(this).attr("id") + "," ;
			}else{
				flag = false;
			}
			
			if( (idx*1) == ($("input[name='field']").length-1) ){
				// for문을 다 돌았을 때
				if( fieldFilter != "" ) fieldFilter = fieldFilter.substr(0,fieldFilter.length-1);
				$("input[name='fieldFilter']").val(fieldFilter);
				
				// 하나의 필드라도 체크되어있지 않으면 전체 영역 검색 해제
				$("#allField").prop("checked",flag);
				$("input[name='allFieldFilter']").val(flag);
			}
			
		});

	});
 	// 필드 리스트 변경 시 이벤트
	// $("input[name='field']").change(function() {
	// 	var fieldFilter = [];
	// 	var allChecked = true;
	  
	// 	$("input[name='field']").each(function() {
	// 		// for문을 다 돌았을 때
	// 	  if ($(this).prop("checked")) {
	// 		fieldFilter.push($(this).attr("id"));
	// 	  } else {
	// 		allChecked = false;
	// 	  }
	// 	});
	  
	// 	var fieldFilterString = fieldFilter.join(",");
	// 	$("input[name='fieldFilter']").val(fieldFilterString);
	  
	// 	// 하나의 필드라도 체크되어있지 않으면 전체 영역 검색 해제
	// 	$("#allField").prop("checked", allChecked);
	// 	$("input[name='allFieldFilter']").val(allChecked);
	//   });

	
	
	// 파일 확장자 리스트 변경 시 이벤트
	$("input[name='fileField']").change(function(){
		var fieldFilter = "";
		var flag = true;
		$("input[name='fileField']").each(function(idx,arr){
			
			if($(this).prop("checked")){
				fieldFilter += $(this).attr("id") + "," ;
			}else{
				flag = false;
			}
			
			if( (idx*1) == ($("input[name='fileField']").length-1) ){
				// for문을 다 돌았을 때
				if( fieldFilter != "" ) fieldFilter = fieldFilter.substr(0,fieldFilter.length-1);
				$("input[name='fileExtFilter']").val(fieldFilter);
				
				// 하나의 필드라도 체크되어있지 않으면 전체 영역 검색 해제
				$("#allFileExt").prop("checked",flag);
				$("input[name='allFileExtFilter']").val(flag);
			}
			
		});

	});
	$("input[name='exctEnf']").change(function(){				// 사규 시행일/개정일 선택 이벤트
		if($(this).prop("checked"))$("input[name='sagyuRegdate']").val($(this).attr("id"));
	});
	
	// 검색창 클릭할 때 전체 선택
	$("input[name=query]").click(function(){$(this).select();});

	var target = $("input[name=target]").val();
	// 카테고리검색 시, 좌 우 키 클릭시 앞 혹은 뒤 페이지로 이동
	$(document).keydown(function(e){
		if( target != 0 ){
			var pageMax = $("input[name=pagemax]").val();
			var pagenum = $("input[name=pagenum]").val();
			var queryFocus =  $("input[name=query]").is(":focus");
			if( e.keyCode == 37 ){
				pagenum = (pagenum*1)-1;
				if( !$(".paging-prev").hasClass("display-none") && !queryFocus ){ mvPg(pagenum,pageMax);}
			}else if( e.keyCode == 39 ){
				pagenum = (pagenum*1)+1;
				if( !$(".paging-next").hasClass("display-none") && !queryFocus ){ mvPg(pagenum,pageMax);}
			}
		}
	});
});

/**
 * 페이지 이동 함수
 * @param page
 * @param pageSize
 * @returns
 */
function mvPg(page,pageSize){
	$("input[name=pagenum]").val(page*1);
	$("input[name=pagemax]").val(pageSize);
	goSearch($("input[name=query]").val(),true);
}

function goSearch(query,mvPage){
	if(!query) query = $("input[name=query]").val();
	// 유효성 체크
	// 원래는 검색어가 없을 경우 검색을 요청하지 않지만, 샘플 데이터가 적으므로 검색어가 없을 경우 전체 데이터가 보이도록 처리
	/*
	if( query == "" ){
		alert("검색어를 입력해주세요!");
		return false;    
	}

	
	if( query.length <= 1 ){
		alert("검색어는 한글자 이상 입력해주세요!");
		return false;
	}
	/*
	// 날짜 유효성 검사
	// 시작날짜와 종료날짜가 둘다 있을 경우 시작날짜가 종료날짜를 넘지 않도록 설정
	if( ($("input[name=startDate]").val() != "") && ($("input[name=endDate]").val() != "") ){
		var start = ( $("input[name=startDate]").val().replace(/\./gi,""))*1;
		var end = ( $("input[name=endDate]").val().replace(/\./gi,""))*1;

		if(start>end){
			alert("종료날짜가 시작날짜의 이전 일 수 없습니다!");
			$("input[name=startDate]").focus();
			return false;
		}		
	}

	 */
	// 페이지 이동이 아닐시 첫페이지로
	if(!mvPage) $("input[name=pagenum]").val("1");
	
	// 검색어 튜닝
	query = XSSCheck(query);
	$("input[name=query]").val(query);
	$("form[name=param]").submit();
}

/**
 * 새팝업창을 여는 함수
 * @param url 새창에서 이동할 URL
 */
function openPopup(url,tab_title){
	if(!tab_title)tab_title="blank";
	if( !url ){ alert("잘못된 URL입니다!"); return false;}
	var option = "width = 1800, height = 1000, top = 100, left = 200, location = no, scrollbars = no, toolbars = no, status = no";
	window.open(url,tab_title,option);
	
}
function openTab(url,tab_title){
	if( !url ){ alert("잘못된 URL입니다!"); return false;}
	var win = window.open(url,'_blank');
	win.focus();
}
/**
 * 특수문자 필터링 필터링
 * @param str 필터링 할 값
 * @returns
 */
function XSSCheck(str){
	if( str ){
		if( str != "" ){
			return str = str.replace(/\<|\>|\@|\=|\?|\$|\^|\!|\%|_|\\|\"|\#|\'|\%|\;|\(|\`|\~|\/|\||\)|\:|\"|\&/g,"");
		}else{
			
		}
	}else{
		return "";
	}
}

/**
 * KESCOIN 원문보기 함수 - 직접 팝업창 생성
 * @param BBS_SN 필요 파라미터
 * @param NTT_SN 필요 파마리터
 */
function getKescoinCNT(NTT_SN,BBS_SN,FILE_DETAIL_SE,ATCHMNFL_GROUP_ID){
	if( !BBS_SN || !NTT_SN ){
		alert("잘못된 요청입니다!");
		return false;
	}
	
	$.ajax({
		url : "http://in.kesco.or.kr/board/smart/"+BBS_SN+"/getBbsNttList.do",
		dataType : "plain/text",
		contentsType : "application/json",
		data : {start: 0, length: 1, searchParam: {nttSn: NTT_SN, updateViewCounting: true}},
		type : "post",
		fail : function(e){console.error(e);}
	}).done(function(res){
		$(".kescoin-title").html(tmp_res.data[0].nttSj);
		$(".kescoin-writer").html(tmp_res.data[0].writerNm);
		$(".kescoin-contents").html(tmp_res.data[0].nttCn);
		$(".kescoin-regdate").html(tmp_res.data[0].frstRegistPnttm);
		$(".kescoin-dialog").fadeIn("fast");
	
		// 파일목록 가져오기
		$.ajax({
			url : "http://in.kesco.or.kr/com/cmm/getAtchmnflList.do",
			dataType : "plain/text",
			contentsType : "application/json",
			data : {fileDetailSe: FILE_DETAIL_SE, atchmnflGroupId: ATCHMNFL_GROUP_ID},
			type : "post",
			fail : function(e){console.error(e);}
		}).done(function(res){
			//var filehtml = $("kescoin-file").eq(0).clone();
			//filehtml.removeClass("display-none");
		}).error(function(request,error){
			alert("파일목록을 불러오는 데 실패하였습니다.");
			//console.log("code:"+request.status+"\nmessage:"+request.responseText+"\nerror:"+error);}
			return false;
		});
	}).error(function(request,error){
		alert("먼저 KESCO-IN 시스템에 로그인해주세요!");
	
		
		console.log("code:"+request.status+"\nmessage:"+request.responseText+"\nerror:"+error);
		return false;
	});

	/***
	// 로그인 권한이 있다는 가정하에 임시 결과값으로 개발 진행
	var tmp_res = {
				"draw":0,
				"recordsTotal":1,
				"recordsFiltered":1,
				"data":[
					{
						"registerNo":null,
						"registDt":null,
						"updusrNo":null,
						"updtDt":null,
						"m":null,
						"atchmnflGroupId":"20210114215129072474",
						"files":[],
						"frstRegistPnttm":"2021-01-14 21:51:46",
						"frstRegisterId":"940959",
						"lastUpdtPnttm":"2021-01-15 08:16:10",
						"lastUpdusrId":"940959",
						"nttSn":10639,
						"bbsSn":3,
						"firstNttSn":10639,
						"upperNttSn":0,
						"nttOrdr":0,
						"nttLevel":0,
						"noticeAt":"Y",
						"writerNm":"양정호",
						"writerDplctCode":"940959",
						"passwd":null,
						"nttSj":"[기술관리]전기안전점검 입력방법 알림",
						"rdcnt":734,
						"othbcAt":"Y",
						"writerIp":"192.10.14.23",
						"telno":null,
						"moblphon":null,
						"email":null,
						"hmpg":null,
						"zip":null,
						"adres":null,
						"detailAdres":null,
						"nttCn":"안녕하세요.<br />\n기술관리부 팀장 양정호 입니다.<br />\n1월 16일부터 전기안전점검 입력시스템이<br />\n기술관리로 이관에 따른 입력방법을 알리오니<br />\n참고 바랍니다.",
						"bgnde":"2021-01-14    ",
						"endde":"2021-06-30    ",
						"aditfield1":null,
						"aditfield2":null,
						"aditfield3":null,
						"aditfield4":null,
						"aditfield5":null,
						"aditfield6":null,
						"aditfield7":null,
						"aditfield8":null,
						"aditfield9":null,
						"aditfield10":null,
						"deptCode":null,
						"deptNm":null,
						"deleteAt":"N",
						"htmlUseAt":"N",
						"atchmnflCount":2,
						"nttSjWithAttcnt":"[기술관리]전기안전점검 입력방법 알림 (2)",
						"histIp":null,
						"file":0}
					],"error":null,"mapData":null};
	
	$(".kescoin-title").html(tmp_res.data[0].nttSj);
	$(".kescoin-writer").html(tmp_res.data[0].writerNm);
	$(".kescoin-contents").html(tmp_res.data[0].nttCn);
	$(".kescoin-regdate").html(tmp_res.data[0].frstRegistPnttm);
	$(".kescoin-dialog").fadeIn("fast");
	***/
	/*
	var filehtml = $("kescoin-file").eq(0).clone();
	filehtml.removeClass("display-none");
	*/
}
$(".popupClose").click(function(){
	$(".kescoin-dialog").fadeOut("fast");
});
/**
 * 숫자 타입 변수를 ###,# 형식으로 포맷하도록 설정
 */
Number.prototype.format = function(){
	var regexp = /\B(?=(\d{3})+(?!\d))/g;
	return this.toString().replace(regexp,',');
}

/**
 * yyyyMMdd 형태를 yyyy.mm.dd형태로 변환
 * @param regdate
 * @returns
 */
function regdateFormat(regdate){return regdate.substr(0,4) + "." + regdate.substr(4,2) + "." + regdate.substr(6,2);}

/**
 * 카테고리 탭 클릭시 이벤트
 * @param target
 * @returns
 */
function clickMenu(target){
	
	// $(".param").val("");
	if( target == 0 ){
		$("input[name=pagemax]").val(3);
		
	}else{
		$("input[name=pagemax]").val(10);

	}
	
	// 카테고리가 바뀔 시 page num을 로 셋팅
	if( ($("input[name=target]").val()*1) != target*1 ) $("input[name=pagenum]").val(1);

	// 카테고리 셋팅
	$("input[name=target]").val(target);

	goSearch();
}
/**
 * 새창을 여는 함수
 * @param url 새창에서 이동할 URL
 */
function openTab(url,tab_title){
	if( !url ){ alert("잘못된 URL입니다!"); return false;}
	var win = window.open(url,'_blank');
	win.focus();
}
/**
 * KESCOIN 게시판 구분 상세검색 파라미터 설정
 * @param obj
 * @returns
 */
function setApprApprovaltype(obj){
	$("input[name=apprApprovaltype]").val(obj.value);
}

/**
 * 전자결재 문서타입 상세검색 파라미터 설정
 * @param obj
 * @returns
 */
function setKescoinBBS(obj){
	$("input[name=kescoinBBS]").val(obj.value);
}
/**
 * 사규 현행여부 상세검색 파라미터 설정
 * @param obj
 * @returns
 */
function setSagyuIscurrent(obj){
	$("input[name=sagyuIscurrent]").val(obj.value);
}

/**
 * RMS 전자여부 상세검색 파라미터 설정
 * @param obj
 * @returns
 */
function setRmsE_DOC_FL(obj){
	$("input[name=e_doc_fl]").val(obj.value);
}

/**
 * RMS 등록구분 상세검색 파라미터 설정
 * @param obj
 * @returns
 */
function setRmsDoc_reg_type(obj){
	$("input[name=doc_reg_type]").val(obj.value);
}
setSagyuIscurrent
/**
 * 전자결재 원문 보기 - seq,col13(컬렉션 정의서 참고)
 * @param val1
 * @param val2
 * @returns
 */
function openAppr(val1,val2){
	var url = "http://newintra.kesco.or.kr/SSO/mir.jsp";
	$.ajax({
        url : url,
        type : "GET",
        /**
        crossOrigin : true,
        dataType : "jsonp",
        cache:false,
        jsonpCallback : "callback"
        ***/
        dataType:"json"
	}).done(function(res){
		try{
			if( res.Code == 200 ){
				var user_id = res.UserID;
				
				var url = "http://newintra.kesco.or.kr/bms/com/hs/gwweb/appr/hstCmdEx.act?USERID=" + user_id + "&APPRIDLIST="+val1+"&APPRDEPTID="+val2+"&APPRIDXID="+val1+"&CLTAPP=1&WORDTYPE=3";
				openPopup(url);

			}else{
				throw new Error(res.Message);
			}
		}catch(e){
			alert("세션이 만료되었습니다! 다시 로그인해주세요!");
			//openTab("http://newintra.kesco.or.kr/");
			console.error(e);
		}
	}).always(function(){
		$(".loading-wrap").fadeOut("fast");
	}).error(function(jqXHR){
		alert("세션이 만료되었습니다! 다시 로그인해주세요!");
		//openTab("http://newintra.kesco.or.kr/");
		console.error("status:"+jqXHR.status);
		console.error("statusText:"+jqXHR.statusText);
		console.error("responseText:"+jqXHR.responseText);
		console.error("readyState:"+jqXHR.readyState);
	});
	
}
/**
 * rms 년도 selectbox 변경시 이벤트
 * @param obj
 * @returns
 */
function setDate(obj){
	$(obj).siblings("input[type=hidden]").val(obj.value);
}
/**
 * url로 다이얼로그 팝업창을 여는 함수
 * @param url
 * @returns
 */
function showDialog(url){
	$("#ifr").attr("src",url);
	$(".dialog").fadeIn("fast");
	$("#ifr").load(function(){
		$("#ifr").contents().find("#search_txtbox").val($("input[name=query]").val());
		document.getElementById("ifr").contentWindow.searchLawText();
	})
}
/**
 * 다이얼로그를 숨기는 창
 * @returns
 */
function hideDialog(){
	$("#ifr").attr("src","");
	$(".dialog").fadeOut("fast");
}