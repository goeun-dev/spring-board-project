<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<style>
.btns {
	display: flex;
	justify-content: flex-end;
}

.btns button {
	margin-left: 5px;
}
.delBtn{
	width:10px;
	height: 10px;
	margin-left: 5px;
}
.modBtn{
	width:20px;
	height:20px;
	margin-left: 5px;
}
.ReplyBtn{
	width:15px;
	height:15px;
	margin-left: 5px;
}
#reTa{
	width: 50vw;
	margin-left: 20px;
}
.rere{
	width:15px;
	height:15px;
}
</style>
<!-- Begin Page Content -->
<div class="container-fluid">

	<!-- Page Heading -->
	<h1 class="h3 mb-2 text-gray-800">Tables</h1>
	<p class="mb-4">
		DataTables is a third party plugin that is used to generate the demo
		table below. For more information about DataTables, please visit the <a
			target="_blank" href="https://datatables.net">official DataTables
			documentation</a>.
	</p>

	<!-- DataTales Example -->
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
		</div>
		<div class="card-body">
			<form>
				<div class="form-group">
					<label for="exampleInputEmail1">Title</label> <input type="text"
						class="form-control" aria-describedby="emailHelp"
						placeholder="Title" name="title" readonly="readonly"
						value="${board.title}">
				</div>
				<div class="form-group">
					<label for="exampleFormControlTextarea1">Content</label>
					<textarea class="form-control" rows="3" name="content"
						readonly="readonly">${board.content}</textarea>
				</div>
				<div class="form-group">
					<label for="exampleFormControlTextarea1">File</label>
					<div>

						<c:forEach items="${board.attachList}" var="file">
							<br>
							<c:choose>
								<c:when test="${file.image}">
									<img
										src='/board/viewFile?fileName=s_<c:out value="${file.uuid}"/>'
										class="fimg">
								</c:when>
								<c:otherwise>
									<img src='/resources/img/paperclip.png'>
								</c:otherwise>
							</c:choose>
							<div class="fn">${file.fname}</div>
							<input type="hidden" name="fname" value="${file.fname}"
								data-file="${file.uuid}">
						</c:forEach>
					</div>
				</div>
				<div class="form-group">
					<label for="exampleInputPassword1">Writer</label> <input
						type="text" class="form-control" placeholder="Writer"
						name="writer" readonly="readonly" value="${board.writer}">
				</div>
			</form>
			<div class="btns">
				<button class="btn btn-primary" id="listbtn">목록</button>
				<sec:authentication property="principal" var="pinfo"/>
		        <sec:authorize access="isAuthenticated()">
		        <c:if test="${pinfo.username eq board.writer}">
				<button class="btn btn-primary" id="updatebtn">수정</button>
				<button class="btn btn-primary" id="deletebtn">삭제</button>
		        </c:if>
		        </sec:authorize>
			</div>

		</div>
	</div>
	<div class="card shadow mb-4">
		<div class="card-header py-3">
			<i class="fa fa-comments fa-fw"></i> Reply
		</div>
		<div class='row'>
			<div class="col-lg-12">
				<!-- /.panel -->
				<div class="panel panel-default">
					<div class="panel-heading"></div>
					<!-- /.panel-heading -->
					<div class="panel-body">
						<ul class="chat">
							<!-- 댓글 START -->

							<!-- end reply -->
						</ul>
						<!-- ./ end ul -->
					</div>
					<!-- /.panel .chat-panel -->
					<div class="panel-footer" style="display: flex; justify-content: center">

					</div>
				</div>
			</div>
			<!-- ./ end row -->
		</div>
		<div class="card-body">
	        <sec:authorize access="isAuthenticated()">
			<form>
				<div class="form-group">
					<label for="exampleFormControlTextarea1">writer</label>
					<input
						type="text" id="writer" name="writer" value='<sec:authentication property="principal.username"/>' class="form-control" readonly="readonly" placeholder='<sec:authentication property="principal.username"/>'>
					<div>
						<br>
					</div>
					<label for="exampleFormControlTextarea1">Content</label>
					<textarea class="form-control" rows="3" name="content" id="replyText"></textarea>
				</div>
			</form>
			<div class="btns">
				<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New
					Reply</button>
			</div>
        	</sec:authorize>

        	<!-- 권한X -->
	     	<sec:authorize access="isAnonymous()">
	     	<p>
	     	<a href="/customLogin"><strong>로그인</strong></a>
	     	하세요...</p>
	     	</sec:authorize>


		</div>
	</div>
</div>
<!-- /.container-fluid -->
<form id="f1" method="get">
	<input type="hidden" name="page" value="${dto.page}" /> <input
		type="hidden" name="amount" value="${dto.amount}" /> <input
		type="hidden" name="keyword" value="${dto.keyword}" /> <input
		type="hidden" name="type" value="${dto.type}" />
</form>
</div>
<!-- End of Main Content -->
<script src="/resources/js/reply.js" type="text/javascript"></script>
<%@include file="../includes/footer.jsp"%>
<script>

	$(document).ready(function() {


		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";



		console.log(replyService);

		$(document).ajaxSend(function(e, xhr, options) {
	        xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	     });

		//원댓글의 답글 등록버튼
		$('.chat').on('click','#intBtn', function(){
			var rnoValue = $(this).data('rno');
			var taValue = $(this).siblings('#reTa').val();
			var reply = {
					content : taValue,
					writer : writer,
					bno : bnoValue,
					groupno : rnoValue,
					depth : 1
				};
			replyService.add(reply , function (result) {
				  alert("RESULT:"  +result);

				  //showList(1);
				  showList(pageNum);

				 $('#replyText').val('');
				 $('#writer').val('');

		},function(err){
			alert(err);
		}

		);
		})

		$('#addReplyBtn').on('click',function(e){
			var reply = {
				content : $('#replyText').val(),
				writer : writer,
				bno : bnoValue

			};
			replyService.add(reply , function (result) {
					  alert("RESULT:"  +result);

					  //showList(1);
					  showList(-1);

					 $('#replyText').val('');
					 $('#writer').val('');

			},function(err){
				alert(err);
			}

			);
		});

		$('.chat').on('click','.delBtn', function(){
			var rno = $(this).data('rno');
			console.log("rno : "+rno);

			var originalwriter = $(this).data('writer');
			if(!writer){
		 		  alert("로그인 후 삭제가 가능합니다.");
		 		  return;
		 	}


	 	  	console.log("Original writer: " + originalwriter);

	 	  	if(writer != originalwriter){

	 		  alert("자신이 작성한 댓글만 삭제가 가능합니다.");
	 		  return;

	 	  	}


			replyService.remove(rno, originalwriter, function(count) {
				 console.log("count......."+count);

				 if (count === "success") {

					 alert("REMOVED");
					 showList(pageNum);
				 }
			 }, function(err) {
				 alert('ERROR.....');
			});
		})


         $('.chat').on('click','.modBtn',function(){ // 수정테이프

        	 var originalwriter = $(this).data('writer');
				if(!writer){
			 		  alert("로그인후 수정이 가능합니다.");
			 		  return;
			 	  }


			 	  console.log("Original writer: " + originalwriter);

			 	  if(writer != originalwriter){

			 		  alert("자신이 작성한 댓글만 수정이 가능합니다.");
			 		  return;

			 	  }

        	 	//전체 닫기
        	 	$('.chat #ta').attr('style','display:none;');
        	 	$('.chat #updbtn').attr('style','display:none;');
        	 	$('.chat #reTa').attr('style','display:none;'); // 답글 창 닫기
        	 	$('.chat .rere').attr('style','display:none;'); //포토샵 화살표
        	 	$('.chat #intBtn').attr('style','display:none;'); //원댓글의 답글 입력

				$(this).parent('.header').siblings('p').attr('style','display:none;');
				//누른 버튼에 ta 닫기
				$(this).parent('.header').siblings('#ta').attr('style','display:block;');
				$(this).parent('.header').siblings('#updbtn').attr('style','display:inline-block;margin-top:5px');

         })

         $('.chat').on('click','#updbtn', function(){ //수정버튼
				var rno = $(this).data('rno');

				var taValue = $(this).siblings('#ta').val();
				console.log("taValue........................"+taValue);

				var reply = {
						content : taValue,
						rno : rno
					};

				replyService.modify(reply, function(result) {
					 console.log("result......."+result);

					 if (result === "success") {

						 showList(pageNum);
					 }
				 }, function(err) {
					 alert('ERROR.....');
				 });

         });

		$('.chat').on('click','.ReplyBtn', function(){ //원댓의 답글 버튼
			//전체 닫기
			$('.chat #ta').attr('style','display:none;'); //댓글창 닫기
    	 	$('.chat #reTa').attr('style','display:none;'); // 답글 창 닫기
    	 	$('.chat #updbtn').attr('style','display:none;'); //버튼닫기
    	 	$('.chat #intBtn').attr('style','display:none;'); //버튼닫기
    	 	$(this).parent('.header').siblings('p').attr('style','display:visiblity;');
    	 	$('.chat .rere').attr('style','display:none;');
			//누른 버튼에 ta 닫기
			$(this).parent('.header').siblings('#reTa').attr('style','display:block;');
			$(this).parent('.header').siblings('#intBtn').attr('style','display:inline-block;margin-top:5px');
			$(this).parent('.header').siblings('.rere').attr('style','display:inline-block;margin-top:5px');


		});

		var pageNum = 1;
		var replyPageFooter = $('.panel-footer');
		function showReplyPage(replyCnt){
			var endNum = Math.ceil(pageNum/10.0)*10;
			var startNum = endNum - 9;
			var prev = startNum!=1;
			var next = false;

			if(endNum *10 >= replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}

			if(endNum * 10 < replyCnt){
				next = true;
			}

		      var str = "<ul class='pagination pull-right'>";

		      if(prev){
		        str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
		      }

		      for(var i = startNum ; i <= endNum; i++){

		        var active = pageNum == i? "active":"";

		        str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
		      }

		      if(next){
		        str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
		      }

		      str += "</ul></div>";

		      console.log(str);

		      replyPageFooter.html(str);
		    }

		    replyPageFooter.on("click","li a", function(e){
		       e.preventDefault();
		       console.log("page click");

		       var targetPageNum = $(this).attr("href");

		       console.log("targetPageNum: " + targetPageNum);

		       pageNum = targetPageNum;

		       showList(pageNum);
		   });



		var bnoValue = '<c:out value ="${board.bno}"/>';
		var replyUL = $('.chat');

		showList(1);

		function showList(page){
		//list 뿌리기
 		console.log("show list " + page);

	    replyService.getList({bno:bnoValue, page: pageNum|| 1 }, function(replyCnt, list) {

	    console.log("page : "+page);
	    console.log("replyCnt: "+ replyCnt );
	    console.log("list: " + list);
	    console.log(list);

	    if(page == -1){
	      pageNum = Math.ceil(replyCnt/10.0);
	      showList(pageNum);
	      return;
	    }

     var str="";
     if(list == null){
         return;
       }
			// reply테이블 내용 들어옴
			for (var i = 0, len = list.length || 0; i < len; i++) {
				console.log(list[i]);

			       if (list[i].delchk === 1 ){ // 삭제된 댓글
		    		   if(list[i].depth === 0){	// 원댓글
						str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				       str +="  <div class='parentsDiv'><div class='header'><strong class='primary-font'>["
				    	   +list[i].rno+"] "+list[i].writer+"</strong>";
				       str +="<small class='pull-right text-muted'>"
				           +replyService.displayTime(list[i].regdate)+"</small>";
			    	   str +="</div>" // header div close
			    	   		str+="<p>삭제된 댓글 입니다.....</p>";

					    }

			       	// 답댓일때는 아무것도X

			       } else { // 삭제X 댓글
			    	   str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
				       str +="  <div class='parentsDiv'><div class='header'><strong class='primary-font'>["
				    	   +list[i].rno+"] "+list[i].writer+"</strong>";
				       str +="<small class='pull-right text-muted'>"
				           +replyService.displayTime(list[i].regdate)+"</small>";
				       str +="<img class='delBtn' src='../resources/img/clear.png' data-rno='"+list[i].rno+"' data-writer='"+list[i].writer+"'>"

				       str +="<img class='modBtn' src='../resources/img/correction-pen.png' data-writer='"+list[i].writer+"'> "
				       str +="<img class='ReplyBtn' src='../resources/img/reply.png'>"
				       str +="</div>" // header div close

				       // 답댓(1)이면 들여쓰기 0이면 냅두기...
				       if(list[i].depth === 0){
				       str +="    <p>"+list[i].content+"</p>" //댓글 내용

				       }else {
				    	   str += "<img class='rere' style='display:visiblity;' src='../resources/img/rere.png'>"
				    	   str +="    <p>re: "+list[i].content+"</p>" //댓글 내용
				       }

				       str +="    <textarea id='ta' class='form-control' style='display:none; width:50vw;'>"+list[i].content+"</textarea>"
				       str += "<img class='rere' style='display:none;' src='../resources/img/rere.png'>"
				       str +="    <textarea id='reTa' class='form-control' style='display:none; width:50vw;'></textarea>"
				       str += "<button class='btn btn-primary' id='updbtn' style='display:none;margin-top:5px;' data-rno='"+list[i].rno+"'>수정</button>"
				       str += "<button class='btn btn-primary' id='intBtn' style='display:none;margin-top:5px;' data-rno='"+list[i].groupno+"' >등록</button>"

			       }
				       str+="</div></li>";
			}
			replyUL.html(str);

			showReplyPage(replyCnt);
		});
		}
		/*  replyService.add( {content:"JS Test", writer: "tester" , bno:bnoValue} ,

		 function (result) {
		  alert("RESULT:"  +result);
		}
		 ) */



		var f1 = $("#f1");
		$('#listbtn').on('click', function() {
			f1.attr("action", "/board/list");
			f1.submit();
		})

		$('#updatebtn').on('click', function() {
			location.href = "/board/update?bno=" + ${board.bno};


		});

		$('#deletebtn').on('click', function() {

			var result = confirm("정말 삭제하시겠습니까?");

			if (result) {
				$.ajax({
					type : "post",
					url : "/board/delete",
					data : {
						bno : '${board.bno}'
					},
					success : function(data) {
						f1.attr("action", "/board/list");
						f1.submit();
					},
					error : function(request, status, error) {
						alert("error");
					}
				});
			} else {

			}

		});

		var fname = $('input[name="fname"]').data("file");
		//alert("fname : "+fname);
		$('.fn').on('click', function() {
			location.href = "/board/download?fname=" + fname;
		})

		$('#replybtn').on('click', function() {

			var replyText = $('#replyText').val();

			$.ajax({
				type : 'post',
				url : '/board/reply',
				data : {
					bno : '${board.bno}',
					content : replyText,
					writer : writer
				},
				success : function(data) {
					alert(data);
					window.location.reload();
				}

			})
		});

		var writer = null;


	    <sec:authorize access="isAuthenticated()">

	    writer = '<sec:authentication property="principal.username"/>';

		</sec:authorize>




	});
</script>