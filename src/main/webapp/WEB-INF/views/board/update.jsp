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

.fileLI {
	display: inline-block;
	list-style: none;
	margin: 0;
}

.fileDiv {
	overflow: auto;
	width: 100px;
}

.xImg {
	width: 10px;
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
			<form method="post" id="upd" enctype="multipart/form-data">
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<input type="hidden" name="bno" value="${board.bno}">
				<div class="form-group">
					<label for="exampleInputEmail1">Title</label> <input type="text"
						class="form-control" aria-describedby="emailHelp"
						placeholder="Title" name="title" value="${board.title}">
				</div>
				<div class="form-group">
					<label for="exampleFormControlTextarea1">Content</label>
					<textarea class="form-control" rows="3" name="content">${board.content}</textarea>
				</div>

				<div class="form-group">
					<label for="exampleFormControlTextarea1">file</label> <input
						type="file" class="form-control" name="uploadFile"
						multiple="multiple">
				</div>
				<div id="result">
					<!-- 파일업로드 결과 -->
					<c:forEach items="${board.attachList}" var="file">
						<li class="fileLI" data-uuid="${file.uuid}">
						<!-- register한 결과(이미 올린 것) -->
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

							<div class="fn">${file.fname}
								<i class='fas fa-trash' data-type='image'
								data-file='<c:out value="${file.uploadPath}"/>\<c:out value="${file.uuid}"/>'></i>
							</div>
						</li>
					</c:forEach>
				</div>
				<div class="form-group">
					<label for="exampleInputPassword1">Writer</label> <input
						type="text" class="form-control" placeholder="Writer"
						name="writer" readonly="readonly" value="${board.writer}">
				</div>
			</form>
			<sec:authentication property="principal" var="pinfo"/>
			<sec:authorize access="isAuthenticated()">
			  	<c:if test="${pinfo.username eq board.writer}">
			<div class="btns">
				<button class="btn btn-primary" id="ok">확인</button>
				<button class="btn btn-primary" id="cancel">취소</button>
			</div>
				</c:if>
			</sec:authorize>
		</div>
	</div>

</div>
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->

<%@include file="../includes/footer.jsp"%>
<script>
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		function view(){
			var formData = new FormData();
			var inputFile = $('input[name="uploadFile"]');

			var files = inputFile[0].files;

			//console.log(files);
			for(var i =0; i<files.length; i++){
				formData.append("uploadFile",files[i]);
			}

			$.ajax({
				url:"/board/upload"
			   ,processData : false
			   ,contentType: false
			   ,data : formData
			   ,type:"post"
			   ,dataType:'json'
			   ,beforeSend: function(xhr) {
				   xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			   }
			   ,success: function(result){
				   //내가 새로 올린 파일(새로 업로드)
				   console.log(result);
				   var str = "";
					for(var i =0; i<result.length;i++){
						console.log(result[i].uuid);
						str += "<li class='fileLI newUpload' id='fImg' data-path ='"+result[i].uploadPath
						+"'data-uuid='"+result[i].uuid+"' data-filename='"+result[i].fname+"' data-type='"+result[i].image+"'>"
						if(result[i].image){
							var fileCallPath = encodeURIComponent(result[i].uploadPath + "\\s_" + result[i].uuid);
							console.log("fileCallPath" + fileCallPath);
							str += "<img class='fileImg' src='/board/viewFile?fileName=s_"+result[i].uuid+"'/>";
							str +=
								"<div class='fileDiv'>"+result[i].fname
							+ "<i class='fas fa-trash' data-file='"+fileCallPath+"' data-type='image'></i>"
							+"</div>";

						}else{
							var fileCallPath = encodeURIComponent(result[i].uploadPath + "\\" + result[i].uuid);
							console.log("fileCallPath", fileCallPath);
							str += "<img class='clipImg' src='/resources/img/paperclip.png'/>";
							str += "<div>"+result[i].fname
							+ "<i class='fas fa-trash' data-file='"+fileCallPath+"' data-type='file'></i>"
							+"</div>";
						}

						str+="</li>"
					}
					$('#result').append(str);
			   },
			   error:function(error,status, xhr){
				   alert("status : "+status+"xhr : "+xhr);
			   }

			})
		}
      </script>
<script>
      $(document).ready(function(){
		$('input[name="uploadFile"]').change(function(e){
				view();
		});

    	  var upd = $('#upd');
    	$('#ok').on('click',function(){

    		$('#result .newUpload').each(function(i, obj){
    			var str = "";
				//업로드 된 파일(내가 새로 올린 파일)
    			var jobj = $(obj);
				console.dir(jobj);
				str += "<input type='hidden' name='attachList["+i+"].fname' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].image' value='"+ jobj.data("type")+"'>";

				upd.append(str);

    		})


      		upd.submit();
      	})


      	$('#cancel').on('click',function(){
      		location.href="/board/read?bno="+${board.bno};
      	})


      	$('#result').on('click','i',function(){
      		$(this).parents("li").remove();
      		var uuid = $(this).parents("li").data("uuid");

      		//삭제
      		var del = "";

      		del +="<input type='hidden' name='uuids'value='"+uuid+"'>"

      		upd.append(del);

      	})
      });
      </script>