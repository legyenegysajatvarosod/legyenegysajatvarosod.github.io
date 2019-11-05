$(document).ready(function() {
    $('.3d-button').on("click", function(){
        $("#3d-dialog").modal();
        $("#3d-dialog").attr('data-house', $(this).attr("data-house"));
    });
    
    $('#3d-dialog').on('shown.bs.modal', function (e) {
        var house = $(this).attr("data-house");
        $("#3d-image").attr("src", house+"/3D/"+house+"01.png");
        $("#3d-image").one("load",
            function() {
                $("#3d-image").attr("data-images", house+"/3D/"+house+"##.png|01..18");
                $("#3d-image").addClass("reel");
                var img = $("#3d-image");
                $('#3d-image-modal-body').empty();
                $('#3d-image-modal-body').append(img);
                $.reel.scan();
            }
        );
   });
});
