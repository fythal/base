$(document).ready(function(){

   $('div').on('focus', '[data-autocomplete-for]', function(){
           var input = $(this);
input.autocomplete({
  source: function(request, response) {
    $.ajax({
      url: input.data('autocomplete-url'),
      dataType: 'json', data: { q: request.term },
      success: function(data) {
        response(
          $.map(data, function(item) {
            return { label:  item.name , item: item};
          })
        );
      },
    });
  },
  
  select: function(event, ui) {
  input.val(ui.item.label);
$(input.data('autocomplete-for')).val(ui.item.item.id);

  }
}).removeAttr('data-autocomplete-field'); });
});
