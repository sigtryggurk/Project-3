/*
*Adds a DOM element to the sticky container with classname sticky, id='id' and populates the
* text area with 'text'
*/
function add_sticky(id,attr){
  var attr = $.parseJSON(attr)
  var text=attr["text"];
  var position=attr["position"];
  var template = $("#sticky-template").html();
  var sticky= $("<div class='sticky'></div>").draggable({grid: [ 20, 20 ], containment: "document" }).html(template);
  sticky.children(".text").val(text);
  sticky.attr("id",id);
  sticky.appendTo("#sticky-container");
  sticky.offset(position);
  
}
/*
* Makes an asynchronous call to the server asking to add sticky to cookies
*/
function new_sticky() {
    var count = parseInt(getCookie("counter")) || 0;
    setCookie("counter",count+1,1);
    var id="new"+count;
    var attr={text:"",position:{top:200,left:50}};
    $.ajax({
       type:"POST",
       url:'/create_sticky',
       data:'id=new'+count,
    });
    add_sticky(id,JSON.stringify(attr));
}
/*
* Removes sticky from sticky container
* and makes an asynchronous call to the server asking to remove sticky from cookies
*/
function delete_sticky() {
    var id=$(this).parent().parent().attr('id');
    $(this).parents(".sticky").remove();
    $.ajax({
       type:"POST",
       url:'/delete_sticky',
       data:'id='+id,
    });
}

/*
*Makes an asynchronous call to the server asking to update the sticky with the specified id
*/
function update_sticky(){
  var id=$(this).attr('id');
  var position=$(this).offset();
  var text=$(this).children(".text").val();
  var attr={text:text,position:position};
  $.ajax({
     type:"POST",
     url:'/update_sticky',
     dataType: "json",
     data:'id='+id+'&attr='+JSON.stringify(attr),

  }) 

}
