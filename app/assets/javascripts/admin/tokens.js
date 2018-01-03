console.log('here!');

field = null
dap = null

function strip_excess_whitespace(field) {
  field.val( field.val().trim().replace("\n\n", "\n") );
}

function remove_value(field, value) {
  field.val( field.val().replace( value, '' ) );
  strip_excess_whitespace( field )
}
function add_value(field, value) {
  field.val( field.val() + "\n" + value );
  strip_excess_whitespace( field )
}
function contains_value(field, value) {
  return field.val().split("\n").includes(value);
}
function permission_regex(id) {
  key = id.replace('token_permissions_presets-', '');
  var val = document.all_permissions_flattened[key];
  return val;
}

document.all_permissions_flattened = {};

$.getJSON('/admin/tokens/permissions.json', null, function(data) {
  document.all_permissions_flattened = data;
  dap = data;
});

$('input[name="token[permissions_presets][]"]').on('change', function() {
  var $txt_area = $('#token_permissions');
  var regex = permission_regex($(this).attr('id'));
  var has_value = contains_value($txt_area, regex );

  console.log( $(this), $txt_area, regex, has_value );

  if( $(this)[0].checked ){
    if( !has_value ) {
      add_value( $txt_area, regex );
    }
  } else if( has_value ) {
    remove_value( $txt_area, regex );
  }
} );