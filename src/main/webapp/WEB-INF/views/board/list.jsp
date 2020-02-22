<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<style>
#btn {
	display: flex;
	justify-content: flex-end;
}

#inputbar {
	display: flex;
	justify-content: flex-start;
}

.pages {
	display: flex;
	justify-content: center;
}

#searchbtn {
	margin-left: 5px;
}

.actionbtn {
	margin-right: 5px;
}
.fimg{
	width: 20px;
	height:20px;
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
			<div class="table-responsive">
				<table class="table table-bordered" id="dataTable" width="100%"
					cellspacing="0">
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>날짜</th>
							<th>조회수</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="board" items="${list}">
							<tr>
								<td>${board.bno}</td>
								<td>
						<c:forEach items="${board.attachList}" var="file">
				    	<c:choose>
					    	<c:when test="${file.image}">
					    	<!-- encodeURIComponent( -->
					    	<img src='/board/viewFile?fileName=s_<c:out value="${file.uuid}" />' class="fimg">
					    	</c:when>
					    	<c:otherwise>

					    	</c:otherwise>
				    	</c:choose>
				    </c:forEach>
								<a href="${board.bno}" class="bnolink">
								${board.title}
								[<c:out value="${board.replyCnt }"></c:out>]
								</a>
						</td>
								<td>${board.writer}</td>
								<td>${board.regdate }</td>
								<td>0</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="pages">
				<ul class="pagination">
					<c:if test="${pm.prev}">
						<li class="page-item"><a class="page-link"
							href="${pm.start-1}" tabindex="-1">Previous</a></li>
					</c:if>
					<c:forEach begin="${pm.start}" end="${pm.end}" var="num">
						<li class='page-item ${num == pm.dto.page ? "active" : ""}'><a
							class="page-link" href="${num}">${num}</a></li>
					</c:forEach>
					<c:if test="${pm.next}">
						<li class="page-item"><a class="page-link" href="${pm.end+1}">Next</a></li>
					</c:if>
				</ul>
			</div>
			<div class="row">
				<div class="col-lg-6" id="inputbar">
					<div class="input-group">
						<div class="input-group-btn">
							<div class="form-group">
								<select
									class="form-control" id="stype" >
									<option value="T" ${pm.dto.type == "T"?"selected":"" }>제목</option>
									<option value="C" ${pm.dto.type == "C"?"selected":"" }>내용</option>
									<option value="W" ${pm.dto.type == "W"?"selected":"" }>작성자</option>
									<option value="TC" ${pm.dto.type == "TC"?"selected":"" }>제목+내용</option>
									<option value="TW" ${pm.dto.type == "TW"?"selected":"" }>제목+작성자</option>
									<option value="CW" ${pm.dto.type == "CW"?"selected":"" }>내용+작성자</option>
									<option value="TCW" ${pm.dto.type == "TCW"?"selected":"" }>제목+내용+작성자</option>
								</select>
							</div>
						</div>
						<!-- /btn-group -->
						<input type="text" class="form-control" aria-label="..." id="skeyword" value="${pm.dto.keyword}">
						<button class="btn btn-primary" id="searchbtn" style="height: 40px">검색</button>
					</div>
					<!-- /input-group -->
				</div>
				<div class="col-lg-6" id="btn">
					<button class="btn btn-primary" id="listbtn" style="height:40px">글쓰기</button>
				</div>
			</div>
		</div>
	</div>
	<form id="f1" method="get">
		<input type="hidden" name="page" value="${pm.dto.page}" />
		<input type="hidden" name="amount" value="${pm.dto.amount}" />
		<input type="hidden" name="type" value="${pm.dto.type}" />
		<input type="hidden" name="keyword" value="${pm.dto.keyword}" />
	</form>
</div>
<!-- /.container-fluid -->

</div>
<!-- End of Main Content -->
<%@include file="../includes/footer.jsp"%>
<script>
	$(document).ready(function() {
		var f1 = $('#f1');

		$('#searchbtn').on('click',function(){
			$('input[name="page"]').val(1);


			var stype = $('#stype').val();

			$('input[name="type"]').val(stype);

			var skeyword = $('#skeyword').val();

			$('input[name="keyword"]').val(skeyword);

			f1.submit();

		});

		$('#listbtn').on('click', function() {
			f1.attr('action', '/board/register');
			f1.submit();
		});

		$('.bnolink').on('click', function(e) {
			e.preventDefault();
			var bno = $(this).attr('href');
			console.log(bno);

			f1.append('<input type="hidden" name="bno" value="'+bno+'">');
			f1.attr('action', '/board/read');
			f1.submit();

		});

		$('.pagination a').on('click', function(e) {
			e.preventDefault();
			var bno = $(this).attr('href');
			console.log(bno);
			$('input[name="page"]').val(bno);
			f1.submit();
		})

	});
</script>