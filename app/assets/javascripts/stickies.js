/*
*Adds a DOM element to the sticky container with classname sticky, id='id' and populates the
* text area with 'text'
*/
function add_sticky(id,text){
  var template = $("#sticky-template").html();
  var sticky= $("<div class='sticky'></div>").html(template);
  sticky.children(".text").val(text);
  sticky.attr("id",id);
  sticky.appendTo("#sticky-container");
}
/*
* Makes an asynchronous call to the server asking to add sticky to cookies
*/
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
  var id=$(this).parent().attr('id');
  var text=$(this).val();
  $.ajax({
     type:"POST",
     url:'/update_sticky',
     data:'id='+id+'&text='+text,

  }) 

}
