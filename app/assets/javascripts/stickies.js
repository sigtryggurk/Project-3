function add_sticky(id,text){
  var template = $("#sticky-template").html();
  var sticky= $("<div class='sticky'></div>").html(template);
  sticky.children(".text").val(text);
  sticky.attr("id",id);
  sticky.appendTo("#sticky-container");
}

function new_sticky() {
    var count = parseInt(getCookie("counter")) || 0;
    setCookie("counter",count+1,1);
    var id="new"+count;
    $.ajax({
       type:"POST",
       url:'/create_sticky',
       data:'id=new'+count,
    });
    add_sticky(id,"");
}

function delete_sticky() {
    var id=$(this).parent().parent().attr('id');
    $(this).parents(".sticky").remove();
    $.ajax({
       type:"POST",
       url:'/delete_sticky',
       data:'id='+id,
    });
}

function update_sticky(){
  var id=$(this).parent().attr('id');
  var text=$(this).val();
  $.ajax({
     type:"POST",
     url:'/update_sticky',
     data:'id='+id+'&text='+text,

  }) 

}
