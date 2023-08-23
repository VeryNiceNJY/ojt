<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="com.google.gson.JsonObject"%>
<%@ page import="com.google.gson.JsonParser"%>
<%@ include file = "./utils.jsp" %>
<%@ include file = "./config.jsp" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setHeader("Cache-Control", "no-cache");
    response.setContentType("application/json");

    String paramName = "Mode";
    String target_bestword=interpret(request.getParameter("target_bestword"),"");
    String sUrl = "http://"+serverhost+":"+adminport+"/bestword";


    //인기검색어 모드
    //String target_bestword = "weekly";


    //시큐어 코딩: Null Pointer 역참조
    if(target_bestword == null) {
        target_bestword = "weekly";
    }
    target_bestword = target_bestword.trim();
    target_bestword = cleanXSS(target_bestword);

    String favorite = "";
    JsonObject result = new JsonObject();               //  결과 JSON
    JsonObject bestWord = null;
    try {
        String url = sUrl+"?"+paramName+"="+target_bestword;
        bestWord = parseStringToJson(getResponse(url,timeout,inCharset));

    }catch(Exception e){
        e.printStackTrace();
        if( Code == 200 ){
            // 오류 2 : 페이지 오류
            Code = 500;
            Message = "[ 인기검색어 오류 ] " + e.getMessage();
        }
    }finally{
        System.out.println("Code = " + Code + ", Message = " + Message );
        result.addProperty("code",Code);
        result.addProperty("message",Message);
        result.add("data",bestWord);
        out.println(result.toString());
    }
%>
<%=favorite %>