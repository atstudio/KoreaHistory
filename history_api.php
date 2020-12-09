<?php
header('Access-Control-Allow-Origin:*');

$method = $_SERVER['REQUEST_METHOD'];
$request = explode('/', trim($_SERVER['PATH_INFO'],'/'));
$input = json_decode(file_get_contents('php://input'),true);

$table = preg_replace('/[^a-z0-9_]+/i','',array_shift($request));
$table2 = preg_replace('/[^a-z0-9가-힣()_ ]+/i','',array_shift($request));
$table3 = preg_replace('/[^a-z0-9가-힣()_ ]+/i','',array_shift($request));

$key = array_shift($request)+0;

function get_curl_data($post_url, $post_data, $curl_post = 1) {
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)");
	curl_setopt($ch, CURLOPT_URL, $post_url);
	curl_setopt($ch, CURLOPT_POST, $curl_post);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/x-www-form-urlencoded'));   
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true); 
	curl_setopt($ch, CURLOPT_TIMEOUT, 60);

	return curl_exec($ch);
}

function parse_list_data($parse_data) {
	$parse_data = preg_replace('/\r\n|\r|\n/','' , $parse_data); 
	$parse_data = preg_replace('/\t/','' , $parse_data);
	$parse_data = preg_replace('/ {2,}/','' , $parse_data);

	preg_match("/\<ul class=\"group lh_16\"\>(.+?)\<\/ul\>/i", $parse_data, $parse_data);
	preg_match_all("/\<br\>(.+?)\<\/p>/i", $parse_data[0], $matches[0]);
	preg_match_all("/fn_search\((.+?)\)\">/i", $parse_data[0], $matches[1]);
	
	return $matches;
}

switch ($method) {
	case 'GET':
		$category_code = array("jasoAll", "jasoPerson", "jasoEvent", "jasoOrg", "jasoRelic");
		$jaso_code = array("ㄱ", "ㄴ ㄷ", "ㄹ ㅁ ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ ㅌ ㅍ ㅎ", "1 2 3 4 5 6 7 8 9 0");

		if($table === "list") {

			$post_data = "searchJaso=".$jaso_code[(int)$table3];
			$post_url = "http://contents.koreanhistory.or.kr/".$category_code[(int)$table2].".do";

			$parse_data = get_curl_data($post_url, $post_data);
			
			$matches = parse_list_data($parse_data);
			
			for ($i=0; $i<count($matches[1][0]); $i++) {
				$data[$i] = array(
					"subject"=>preg_replace('/fn_search\(\'|\',(.+?)\"\>/','' , $matches[1][0][$i]),
					"su_code"=>preg_replace('/fn_search\(\'(.+?)\', \'|\'\)\"\>/','' , $matches[1][0][$i]),
					"description"=>preg_replace('/\<br\>|\<\/p>/', '', $matches[0][1][$i])
				);
			}
			header("Content-Type: application/json");
			echo json_encode($data);

		} else if ($table === "detail") {

			/* 상세정보 코드 따오기 */
			$post_data = "searchTerm=".$table2."&uri=".$table3;
			$post_url = "http://contents.koreanhistory.or.kr/searchResultName.do";

			$parse_data = get_curl_data($post_url, $post_data);

			preg_match("/detailInfo\(\'(.+?)\'\)/i", $parse_data, $matches);
			
			/* 따온 코드를 통해 상세정보 Read */
			$post_url = "http://contents.koreanhistory.or.kr/id/".$matches[1];
			$parse_data = get_curl_data($post_url, "", 0);

			// DOM 손질
			$parse_data = preg_replace('/\r\n|\r|\n/','' , $parse_data); 
			$parse_data = preg_replace('/\t/','' , $parse_data);
			$parse_data = preg_replace('/ {2,}/','' , $parse_data);

			preg_match("/\<div class=\"off_bg\"\>(.+?)\<\/body\>/i", $parse_data, $parse_data);

			$parse_data = preg_replace('/\<div class=\"topmenu mr_50\"\>(.+?)\<\/div\>|\<div class=\"panel_button\" style=\"display:visible;\"\>(.+?)\<\/div\>|\<div class=\"panel_button\" id=\"hide_button\" style=\"display:none;\"\>(.+?)\<\/div\>/','' , $parse_data[0]);
			$parse_data = preg_replace('/\.\.\/images|\/images/','http://contents.koreanhistory.or.kr/images', $parse_data);
			$parse_data = preg_replace('/a href=\"(?!#)(.+?)\"/','span ', $parse_data);
			$parse_data = preg_replace('/(?!\<\/a>\<\/li>)\<\/a\>/','</span>', $parse_data);
			$parse_data = preg_replace('/target=\"_blank\"/','', $parse_data);
			$parse_data = preg_replace('/<span/', ' <span', $parse_data);
			$parse_data = preg_replace('/<\/span>&nbsp;/', '</span>', $parse_data);
			$parse_data = preg_replace('/\<img src=\"http:\/\/contents.koreanhistory.or.kr\/images\/egovframework\/common\/btn_imagelink.png\" alt=\"상세정보\">/', '', $parse_data);
			

			
			$pre_data = '<html lang="ko"><head><meta charset="utf-8"><title>한국사 콘텐츠</title><meta name="title" content=""><meta name="keyword" content=""><meta http-equiv="X-UA-Compatible" content="IE=Edge"><meta name="apple-mobile-web-app-capable" content="yes"><meta name="format-detection" content="telephone=no"><meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, user-scalable=no"><link rel="stylesheet" href="http://contents.koreanhistory.or.kr/css/egovframework/style.css"><link rel="stylesheet" href="http://contents.koreanhistory.or.kr/css/egovframework/layout.css"><link rel="stylesheet" href="http://contents.koreanhistory.or.kr/css/egovframework/jquery-ui.css"><style>#content2 { padding-top: 0px; } #content2, #footer {min-width:initial;}#content2 .content {width:initial;}#over_tab_left {width:100%;.width:auto;}#over_tab_left.on {width:100%;}#footer img {width:100%} #footer span {display:none} .ml_50 {margin-left:20px !important;} .mr_50 {margin-right:20px !important;}</style><script>function imageOnError(e){e.remove();}</script></head><body><div id="wrap"><div id="content2"><div class="content"><div id="over_tab_left" class="on">';
			ob_start();
			echo $pre_data.$parse_data;
			$buffer = ob_get_contents();
			ob_end_clean();
			
			header("Content-Type: text/html");
			echo $buffer;

		} else if ($table === "quiz") {
			$cat = rand(0, 8);
			
			$post_data = "searchJaso=".$jaso_code[$cat];
			$post_url = "http://contents.koreanhistory.or.kr/".$category_code[0].".do";

			$parse_data = get_curl_data($post_url, $post_data);
						
			$matches = parse_list_data($parse_data);
			
			$answer_offset = rand(0, count($matches[1][0]) - 1);
						
			$answer_title = preg_replace('/fn_search\(\'|\',(.+?)\"\>/','' , $matches[1][0][$answer_offset]);
			$answer_hint = preg_replace('/\<br\>|\<\/p>/', '', $matches[0][1][$answer_offset]);
			
			$j = 0;
			$wrong_offset_arr = array();
			$wrong_data = array();
			
			for ($i=0; $i<count($matches[1][0]); $i++) {
				if($j > 3) break;
				$wrong_offset = rand(0, count($matches[1][0]) - 1);
				if($wrong_offset == $answer_offset) continue;

				if (in_array($wrong_offset, $wrong_offset_arr)) {
					continue; 
				} else {
					array_push($wrong_offset_arr, $wrong_offset);
					array_push($wrong_data, preg_replace('/fn_search\(\'|\',(.+?)\"\>/','' , $matches[1][0][$wrong_offset]));
					$j++;
				}
			}
			
			$answer_offset = rand(0, count($wrong_data) - 1);
			
			$wrong_data[$answer_offset] = $answer_title;
			
			$quiz_data = array(
				"quiz_title" => $answer_title,
				"quiz_hint" => $answer_hint,
				"quiz_data" => $wrong_data,
				"right_code" => $answer_offset
			);

			header("Content-Type: application/json");
			echo json_encode($quiz_data);

		} else {
			header("Content-Type: application/json");
			http_response_code(404);
		}
		
		break;
	default:
		header("Content-Type: application/json");
		http_response_code(404);
		break;
}