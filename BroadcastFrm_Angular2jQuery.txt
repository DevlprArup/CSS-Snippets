// Document as a parent of `$element` will receive this event. The following script will be in the HTML in a <script> tag
$(document).on('myCustomEvent', function(event, data) {
  console.log(data);
});
 
 
// In controller
$element.trigger('myCustomEvent', {myName: 'Steve Jobs'});