$(document).on('turbolinks:load', function () {

    $("#preview-button").click(function (event) {
        event.preventDefault();

        if ($('input[name="document[kind]"]:checked').val() == 'declaration') {
            $('#document_kind').html("declaração")
        } else {
            $('#document_kind').html("certificado")
        }

            user_documents()

        $('#myModal').modal('show');
    });


    function myFunction(val, tag) {
        return "<" + tag + " class='text-center text-capitalize'>" + val + "</" + tag + ">"
    }

    function user_documents() {
        var description = $('#document_description').val();
        var activity = $('#document_activity').val();

        $('#document_description_view').html(description.replace(/{assinatura_[0-9]}/g, ''));
        $('#document_activity_view').html(activity.replace(/{assinatura_[0-9]}/g, ''));
        var select = new Array;
        var input = new Array;
        var html = "";

        var a = activity.match(/{assinatura_[0-9]}/g);
        var d = description.match(/{assinatura_[0-9]}/g);

        if (d != null) {
            $("select option:selected").each(function (option) {
                select[option] = myFunction($(this).text(), "h4")
            });

            $('input[name*="[function]"]').each(function (val) {
                input[val] = myFunction($(this).val(), "h6")
            });
            html += "<div class='row'>"
            for (i = 0; i < input.length && i < d.length; i++) {
                html += "<div class='col-" + (12 / d.length) + " px-1 '> <div style='height: 100px'></div> "
                html += select[i] + input[i]
                html += "</div>"
            }
            html += "</div>"
            $('#document_users_description').html(html);


        } else {
            $('#document_users_description').html('');
        }


        if (a != null) {
            html= "";
            $("select option:selected").each(function (option) {
                select[option] = myFunction($(this).text(), "h4")
            });

            $('input[name*="[function]"]').each(function (val) {
                input[val] = myFunction($(this).val(), "h6")
            });
            html += "<div class='row'>"
            l = ((d == null) ? 0 : d.length);
            console.log(l);
            for (i = l;  i < a.length + l; i++) {
                console.log(i)
                html += "<div class='col-" + (12 / a.length) + " px-1 '><div style='height: 100px'></div>"
                html += select[i] + input[i]
                html += "</div>"
            }
            html += "</div>"
            $('#document_users_activity').html(html);

        } else {
            $('#document_users_activity').html('');
        }
    }

    if ($("select option:selected").length == 0) {
        $('a[data-associations="users_documents"]').trigger('click');
    }
});