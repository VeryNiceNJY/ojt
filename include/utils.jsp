<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="javax.servlet.http.HttpServletRequest" %>
<%@page import="java.io.*" %>
<%@page import="java.net.*"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%!
    /**
     * 문자열 Null 처리
     * @param s 입력값
     * @param value 초기값
     * @return 문자열
     */
    public static String interpret (String s, String value) {
        try{
            if (s == null) return value;
            if(s.trim().equals("")) return value;
        }catch(Exception e){
            e.printStackTrace();
            s = value;
        }
        return s;
    }

    /**
     * XSS 파라미터 값 처리
     * @param value 입력값
     * @return value 처리된값
     * @throws Exception
     */
    public static String cleanXSS( String value ) throws Exception{

        value = value.replaceAll("script","");
        String[] puncts = {"!","#","$","%","&","\\(","\\)","\\{","\\}","@","`",":",";","\\.","<",">",",","\\^","~","\\|","'","\\[","\\]","\""};
        for( String i : puncts )value = value.replaceAll(i,"");

        return value;
    }

    /**
     * 검색 인자값으로 검색서버에 보낼 URI를 생성
     * @param serverhost 검색서버 IP
     * @param searchport 검색서버 PORT
     * @param query 검색어
     * @param qy 인기검색어
     * @param inCharset 입력 인코딩
     * @param parser 검색 Parser
     * @param colList 검색 대상 컬렉션명
     * @param pagenum 페이지 번호
     * @param pagemax 페이지당 데이터수
     * @param fieldList 검색결과에 출력할 필드목록(,로 분리)
     * @param sort 정렬항목과 정렬차순( 정렬항목과 정렬차순을 스페이스로 조합. 정렬항목 - score : 정확도|그외 layout.fld에서 sortmap=yes로 지정한 필드로 정렬 가능 / 정렬차순 - asc|desc )
     * @return
     * @throws Exception
     */
    public static String makeSearchURI(String serverhost,String searchport,String query,String qy,String inCharset,String parser,String colList,String pagenum,String pagemax,String fieldList,String sort) throws Exception{
        return String.format("http://%s:%s/search?Query=%s&QY=%s&Parser=%s&ColList=%s&PageNum=%s&PageMax=%s&FieldList=%s&SortOrder=%s&User=",
                serverhost,
                searchport,
                URLEncoder.encode( query , inCharset ),
                URLEncoder.encode( qy , inCharset ),
                parser,
                colList,
                pagenum,
                pagemax,
                fieldList,
                URLEncoder.encode(sort));
    }

    /**
     * 입력한 URI와 timeout값 그리고 출력 인코딩으로 URLConnection을 요청하여 결과값을 리턴한다.
     * @param URI
     * @param timeout
     * @param charset
     * @return
     * @throws Exception
     */
    public static String getResponse(String URI,int timeout,String charset)throws Exception{
        HttpURLConnection conn = null;
        BufferedReader br = null;
        URL url = null;
        StringBuilder sb = new StringBuilder();
        try{
            url = new URL(URI);
            conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(timeout);
            conn.setConnectTimeout(timeout);
            conn.setUseCaches(false);

            if ( conn.getResponseCode() == HttpURLConnection.HTTP_OK ) {
                br = new BufferedReader(new InputStreamReader(conn.getInputStream(),charset));
            }else{
                br = new BufferedReader(new InputStreamReader(conn.getErrorStream(),charset));
            }

            for (;;) {
                String line = br.readLine();
                if (line == null) break;
                sb.append(line);
            }
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }finally{
            if( br!=null ){br.close();}
            if( conn != null )conn.disconnect();
        }
        return sb.toString();

    }

    /**
     * 문자열을 JSON객체로 파싱
     * @param value 문자열
     * @return
     * @throws Exception
     */
    public static JsonObject parseStringToJson(String value)throws Exception{
        JsonParser parser = new JsonParser();
        return (JsonObject)parser.parse(value);
    }

    /**
     * 값이 공백(null)인지 여부를 판단하여 리턴
     * @param value 공백여부 체크 대상
     * @return 공백여부
     */
    public static boolean isEmpty(String value){
        try{
         if( value == null || value.equals("") ){
             return true;
         }else{
             return false;
         }
        }catch (Exception e){
            e.printStackTrace();
            return true;
        }
    }

    /**
     * 값이 공백(null)이 아닌지 여부를 판단하여 리턴
     * @param value 공백여부 체크 대상
     * @return 공백여부
     */
    public static boolean isNotEmpty(String value){
        try{
            if( value != null && !value.equals("") ){
                return true;
            }else{
                return false;
            }
        }catch (Exception e){
            e.printStackTrace();
            return true;
        }
    }

    /**
     * yyyyMMdd 형식의 날짜 데이터를 구분자로 분리하여 리턴
     * @param date 포맷할 날짜형식 데이터
     * @param delimiter 구분자
     * @return
     */
    public static String formatDate(String date, String delimiter){
        try{
            if( isNotEmpty(date) ){
                if( date.length() == 8 ){
                    SimpleDateFormat dtFormat = new SimpleDateFormat("yyyyMMdd");
                    SimpleDateFormat newDtFormat = new SimpleDateFormat("yyyy" + delimiter + "MM" + delimiter + "dd");
                    Date formatDate = dtFormat.parse(date);
                    // Date타입의 변수를 새롭게 지정한 포맷으로 변환
                    return newDtFormat.format(formatDate);

                }else{
                    return date;
                }
            }else{
                return date;
            }
        }catch(Exception e){
            e.printStackTrace();
            return date;
        }
    }

    /**
     * 구분자로 구분된 날짜형식을 YYYYMMDD 형태로 치환하여 리턴
     * @param date 날짜
     * @param delimiter 구분자
     * @return
     */
    public static String unFormatDate( String date, String delimiter ){
        try{
            if( delimiter.equals(".") ){
                return date.replaceAll("\\.","").replaceAll("-","").trim();
            }else{
                return date.replaceAll(delimiter,"").trim();
            }
        }catch(Exception e){
            return date;
        }
    }
%>