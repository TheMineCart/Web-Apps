$(document).ready(function () {

    var updateHeader = function () {
        $('#player-name-header').html($('#username').val());
    };

    var getPlayerInfo = function () {
        $.ajax({
                url:'player_info',
                data:{
                    username:$('#username').val()
                },
                success:function (response) {
                    updateHeader();
                    $('#player-info-content').html(response);
                    $('#player-info-content').slideDown('slow');
                }
            }
        );
    }

    $('#submit').click(function () {
        $('#player-info-content').slideUp('slow', function () {
                getPlayerInfo();
            }
        );
    });
});