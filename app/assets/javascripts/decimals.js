$(function() {
  Inputmask.extendAliases({
    'customDecimal': {
      alias: 'decimal',
      digits: 2,
      digitsOptional: false,
      groupSeparator: '.',
      radixPoint: ',',
      auto***REMOVED***: true,
      allowPlus: false,
      allowMinus: false,
      positionCaretOnTab: true,
      rightAlign: false
    }
  });

  $('input.decimal').inputmask('customDecimal');
});
