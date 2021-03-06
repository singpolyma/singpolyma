function peekaboo_comments_author_display(id,authorurl) {
   if(id && authorurl.url) {
      var block = document.getElementById('author-' + id);
      var name = block.innerHTML;
      block.innerHTML = '<a href="' + authorurl.url + '">' + name + '<\/a>';
   }
}//end function peekaboo_comments_author_display

function peekaboo_comments_display(data) {

  data = data.feed;
  data.items = data.entry;

  if(!data.items) return;

  var template = '';

  function zeropad( n ){ return n>9 ? n : '0'+n; }
  data.items.reverse();
  for(i in data.items) {
      if(!data.items[i].link) continue;

      data.items[i].link = data.items[i].link[0].href;
      data.items[i].updated = data.items[i].updated['$t'];
      data.items[i].content = data.items[i].content['$t'];
      data.items[i].author.name = data.items[i].author[0].name['$t'];

      var tmp = data.items[i].link.split('#');
      data.items[i].link = tmp.join('#c');
      var dt = data.items[i].updated.match(/^(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)\.(\d+)([+-]\d+):(\d+)$/);
      if(!dt)
         dt = data.items[i].updated.match(/^(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)\.(\d+)(Z)$/);
      var time = 0;
      if(dt) {
         time = new Date(parseInt(dt[1],10), parseInt(dt[2],10)-1 /*since January==0 in Date lingo*/, parseInt(dt[3],10), parseInt(dt[4],10), parseInt(dt[5],10), parseInt(dt[6],10), parseInt(dt[7],10)).getTime();
         if(dt[8] == 'Z') dt[8] = 0;
         if(!dt[9]) dt[9] = 0;
         time = time + -(60*60*1000*parseInt(dt[8],10)) + -(60*1000*parseInt(dt[9],10));//adjust to GMT
      }//end if dt
      time = time - ((new Date()).getTimezoneOffset()*60*1000);
      var ftime = new Date(time);
      ftime = ftime.getFullYear() + '-' + zeropad(ftime.getMonth()+1) + '-' + zeropad(ftime.getDate()) + ' ' + zeropad(ftime.getHours()) + ':' + zeropad(ftime.getMinutes());

      var out = comment_form_template;
      out = out.replace(/\[\[PERMALINK\]\]/,data.items[i].link);
      out = out.replace(/\[\[DATE\]\]/,ftime);
      out = out.replace(/\[\[UTIME\]\]/,parseInt(time/1000));
      out = out.replace(/\[\[AUTHOR\]\]/,'<span id="author-' + tmp[1] + '">' + data.items[i].author.name + '<\/span>');
      out = out.replace(/\[\[BODY\]\]/,data.items[i].content);
      out = out.replace(/\[\[CID\]\]/,tmp[1]);
      document.writeln(out);

      document.writeln('<script type="text/javascript" src="http://singpolymaplay.ning.com/blogger/url4name.php?xn_auth=no&url=' + encodeURIComponent(tmp[0]) + '&name=' + encodeURIComponent(data.items[i].author.name) + '&callback=peekaboo_comments_author_display&parameter=' + encodeURIComponent('"' + tmp[1] + '"') + '"><\/script>');

  }//end for i in data

}//end if function peekaboo_comments_display