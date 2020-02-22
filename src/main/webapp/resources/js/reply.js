console.log("Reply Module..........");

var replyService = (function() {
	function add(reply, callback, error) {
		console.log("add reply................")

		$.ajax({
			type : 'post',
			url : '/reply/reply',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {

				if (callback) {
					alert('success');
					callback(result);

				}
			},
			error : function(xhr, status, er) {
				if (error) {
					alert('error!!');
					error(er);

				}

			}

		})

	}

	function getList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;

		$.getJSON("/reply/list/" + bno + "/" + page + ".json",
				function(data) {
					if (callback) {
						//callback(data);
						callback(data.replyCnt, data.list);
					}
				}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}
	
	function remove(rno, writer, callback, error) {
		$.ajax({
			type: 'delete',
			url: '/reply/' + rno,
			data : JSON.stringify({rno: rno, writer:writer}),
			contentType : "application/json; charset=utf-8",
			success: function(deleteResult, status, xhr){
				if(callback) {
					callback(deleteResult);
				}
			}, error: function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		})
	}
	
	function modify(reply, callback, error) {
		$.ajax({
			type: 'put',
			url:'/reply/'+reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success: function(updateResult, status, xhr){
				if(callback) {
					callback(updateResult);
					alert(callback);
				}
			}, error: function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		})
	}
	

	
	
	function displayTime(timeValue) {

		var today = new Date();

		var gap = today.getTime() - timeValue;

		var dateObj = new Date(timeValue);
		var str = "";

		if (gap < (1000 * 60 * 60 * 24)) {

			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();

			return [ (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ? '' : '0') + mi,
					':', (ss > 9 ? '' : '0') + ss ].join('');

		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
			var dd = dateObj.getDate();

			return [ yy, '/', (mm > 9 ? '' : '0') + mm, '/',
					(dd > 9 ? '' : '0') + dd ].join('');
		}
	}
	return { //add 속성의 add 함수 리턴(객체 리턴)
		add : add,
		getList : getList,
		displayTime : displayTime,
		remove : remove,
		modify : modify
	}
})();
