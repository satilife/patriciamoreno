(function initializeDatepickerRails($) {
  var hiddenSelector = 'input[type=hidden]',
      pickerSelector = '.bootstrap-datepicker';

  function zeroPad(val) {
    return ('0' + val).slice(-2);
  }

  function onChangeDate(event) {
    var date      = event.date,
        railsDate = [date.getFullYear(), zeroPad(date.getMonth() + 1), zeroPad(date.getDate())];
    $(this).next('input[type=hidden]').val(railsDate.join('-'));
  }

  function onBlur() {
    var $element = $(this);

    if ($.trim($element.val()) === '') {
      $(this).next(hiddenSelector).val('');
    }
  }

  $(function setupDatepickerRails() {
    $(document)
      .on('changeDate', pickerSelector, onChangeDate)
      .on('blur',       pickerSelector, onBlur);
  });
}(jQuery));
