$(document).ready(function () {

    var updateHeader = function () {
        coordinate = '(' +
            $('#x').val() + ', ' +
            $('#y').val() + ', ' +
            $('#z').val() + ')';

        headerString = "History for " + coordinate + " in " + $('#world').val();

        $('#history-table-header').html(headerString);
    };

    var getBlockEventsTable = function () {
        $.ajax({
                url:'block_events',
                data:{
                    x:$('#x').val(),
                    y:$('#y').val(),
                    z:$('#z').val(),
                    world:$('#world').val()
                },
                success:function (response) {
                    updateHeader();
                    $('#history-table').html(response);
                    $('#history-table').slideDown('slow');
                }
            }
        );
    }

    $('#submit').click(function () {
        $('#history-table').slideUp('slow', function () {
                getBlockEventsTable();
            }
        );
    });
});