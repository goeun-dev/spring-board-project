<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
     <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    <%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@include file="../includes/header.jsp" %>
<style>
	.buttons{
		display: flex;
		justify-content: flex-end;
	}
	.clipImg {
		width: 50px;
	}
	
	.fileLI {
		display: inline-block;
		list-style: none;
		margin: 0;
	}
	
	
	.xImg {
		width: 10px;
	}
</style>
        <!-- Begin Page Content -->
        <div class="container-fluid">

          <!-- Page Heading -->
          <h1 class="h3 mb-2 text-gray-800">Tables</h1>
          <p class="mb-4">DataTables is a third party plugin that is used to generate the demo table below. For more information about DataTables, please visit the <a target="_blank" href="https://datatables.net">official DataTables documentation</a>.</p>

          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-header py-3">
              <h6 class="m-0 font-weight-bold text-primary">DataTables Example</h6>
            </div>
            <div class="card-body">
           		<form id="form1" enctype="multipart/form-data" method="post">
           		  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				  <div class="form-group">
				    <label for="exampleInputEmail1">Title</label>
				    <input type="text" class="form-control"  placeholder="Title" name="title" required="required"> 
				  </div>
				   <div class="form-group">
				    <label for="exampleFormControlTextarea1">Content</label>
				    <textarea class="form-control" rows="3" name="content" required="required"></textarea>
				  </div>
				  	 <div class="form-group">
				    <label for="exampleFormControlTextarea1">file</label>
				     <input type="file" class="form-control" name="uploadFile" multiple="multiple" >
				  </div>
				  <div id="result">
				  <!-- 파일업로드 결과 -->

				  </div>
				  <div class="form-group">
				    <label for="exampleInputPassword1">Writer</label>
				    <input type="text" class="form-control" placeholder="Writer" 
				    name="writer" required="required" value='<sec:authentication property="principal.username"/>' 
				    readonly="readonly">
				  </div>
				</form>
				<div class="row buttons">
				<div class="col-1">
				  <button class="btn btn-primary" id="submitbtn">Submit</button>
				</div>
				<div class="col-1">
				  <button class="btn btn-primary" id="cancel">cancel</button>
				</div>
				</div>
	<form id="f1" method="get">
		<input type="hidden" name="page" value="${dto.page}" /> 
		<input type="hidden" name="amount" value="${dto.amount}" />
		<input type="hidden" name="type" value="${dto.type}" />
		<input type="hidden" name="keyword" value="${dto.keyword}" />
	</form>
            </div>
          </div>

        </div>
        <!-- /.container-fluid -->
      </div>
      <!-- End of Main Content -->
      <%@include file="../includes/footer.jsp" %>
      <script>
	    	  
      	// 수정 요망 
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
				   console.log(result);
				   var str = "";
					for(var i =0; i<result.length;i++){
						console.log(result[i].uuid);
						str += "<li class='fileLI' id='fImg' data-path ='"+result[i].uploadPath
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
	
			var form1 = $('#form1');
			var f1 = $('#f1');
			
			
			
			$('input[name="uploadFile"]').change(function(e){
				view();
			});
			
		$('#submitbtn').on('click',function(){
			//반복문
			$('#result li').each(function(i,obj){ //each의 i는 배열의 인덱스 혹은 객체의 키, obj 해당 인덱스키가 가진 값
				var str = "";
				
				var jobj = $(obj);
				console.dir(jobj);
				str += "<input type='hidden' name='attachList["+i+"].fname' value='"+jobj.data("filename")+"'>";       
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";       
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";      
				str += "<input type='hidden' name='attachList["+i+"].image' value='"+ jobj.data("type")+"'>";
				
				form1.append(str);
				
			});
					form1.submit();
		});
			
		$('#cancel').on('click',function(){
			f1.attr('action','/board/list')
			f1.submit();
		}); 
		
		
		$('#result').on('click', 'i', function(){
			
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			var targetLi = $(this).closest("li");
						
			$.ajax({
				url: '/board/deleteFile',
				type : 'post',
				data : {fileName: targetFile, type:type},
				dataType : 'text',
				beforeSend: function(xhr) {
					   xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				success: function(result) {
					alert(result);
					targetLi.remove();
				}
				
			})
		})
			
			
		})
	
	</script>