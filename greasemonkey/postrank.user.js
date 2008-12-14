// ==UserScript==
// @name Postrank
// @author Stephen Paul Weber
// @namespace http://postrank.com/
// @version 0.1
// @description  Nothing to see here.
// @include http://*
// ==/UserScript==

function $x( xpath, root ) {
  var doc = root ? root.evaluate ? root : root.ownerDocument : document, next;
  var got = doc.evaluate( xpath, root||doc, null, 0, null ), result = [];
  switch (got.resultType) {
    case got.STRING_TYPE:
      return got.stringValue;
    case got.NUMBER_TYPE:
      return got.numberValue;
    case got.BOOLEAN_TYPE:
      return got.booleanValue;
    default:
      while (next = got.iterateNext())
	result.push( next );
      return result;
  }
}

function get_prs(feed_id) {

	var posts = {};
	var p = $x('//a[contains(concat(" ",normalize-space(@rel)," ")," bookmark ")]');
	var get = '';
	for(var i in p) {
		posts[p[i].href] = p[i];
		get += '&url[]=' + encodeURIComponent(p[i].href);
	}
	if(!get) return;

	GM_xmlhttpRequest({
		method: 'POST',
		url: 'http://api.postrank.com/v1/postrank?appkey=aiderss.com/testinggm&format=json',
		data: get,
		headers: {
			'User-agent': 'Mozilla/5.0 (compatible) Greasemonkey',
			'Accept': 'text/javascript',
			'Content-Type': 'application/x-www-form-urlencoded'
		},
		onload: function(r) {
			var prs = eval('('+r.responseText+')');
			if(prs['error']) return;
			for(var i in prs) {
				posts[i].insertBefore(document.createTextNode(' ['+prs[i].postrank+'] '), posts[i].firstChild);
			}
		}
	});


}
//		posts[i].insertBefore(document.createTextNode(' [PR] '), posts[i].firstChild);

GM_xmlhttpRequest({
	method: 'GET',
	url: 'http://api.postrank.com/v1/feed_id?appkey=aiderss.com/testinggm&format=json&url=' + encodeURIComponent(unsafeWindow.location.href),
	headers: {
		'User-agent': 'Mozilla/5.0 (compatible) Greasemonkey',
		'Accept': 'text/javascript',
	},
	onload: function(r) {
		get_prs(eval('(' + r.responseText + ')').feed_id);
	}
});
