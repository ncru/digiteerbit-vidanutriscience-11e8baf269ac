@is_required = (class_name, module_name) ->
  $this = $(class_name)
  flag = 0

  $this.each ->
    value = $(this).val().trim()
    if value == ""
      $(this).css "border", "1px solid #d43"
      flag = 1
    else
      $(this).val value
      $(this).css "border", "1px solid #ddd"

  if flag is 1
    $(".error-class").append module_name + " is required<Br/>"
    $(".alert-danger").removeClass "hidden"
    return 1

@is_form_field_not_blank = (class_name, containing_form) ->
  $this = containing_form.find(class_name)
  flag = 0
  element_with_error = undefined

  $this.each ->
    value = $(this).val().trim()
    tagName = $(this).prop('tagName')
    parentClass = $(this).parent().attr('class')

    # Catch if the component is an instance of summernote, if yes, check the summernote element's value instead.
    if ($(this).hasClass('summernote'))
      value = $(this).siblings('.note-editor').find('.note-editable').text()

    if (value == "" || value == "0") && tagName != 'DIV'
      if (parentClass == "input-group")
        $("."+parentClass).siblings('.error-msg').removeClass('hidden')
        $("."+parentClass).siblings('.error-msg').text('Required.')
      else
        $(this).siblings('.error-msg').removeClass('hidden')
        $(this).siblings('.error-msg').text('Required.')

      flag = 1

      if element_with_error == undefined
        element_with_error = $(this)
    else
      $(this).val value
      $(this).siblings('.error-msg').addClass('hidden')

  if flag == 1
    if element_with_error != undefined
      $('html, body').animate { scrollTop: $(element_with_error).first().offset().top - 81 }, 500
    return false
  else
    return true

@is_not_blank = (class_name) ->
  $this = $(class_name)
  flag = 0
  element_with_error = undefined

  $this.each ->
    _this = $(this)
    value = ""
    
    if _this.val() 
      # If the value is an array, don't trim it to avoid exceptions.
      if $.isArray(_this.val())
        value = _this.val() 
      else 
        value = _this.val().trim()
        
    tagName = _this.prop('tagName')
    parent = _this.parents('.input-group')
    
    # Catch if the component is an instance of chosen-select, if yes, check the select element's value instead.
    if (_this.hasClass('chosen-select'))
      value = _this[0].value
      element_with_error = _this.data('chosen').container[0]
    
    # Catch if the component is an instance of fileinput, if yes, check the fileinput element's value instead.
    if (_this.hasClass('fileinput-filename'))
      value = _this.text().trim()

    # Catch if the component is an instance of summernote, if yes, check the summernote element's value instead.
    if (_this.hasClass('summernote'))
      value = if _this.summernote('isEmpty') then "" else _this.summernote('code')  
    
    if (value == "" || value == "0") && tagName != 'DIV'
      if (parent.hasClass("input-group"))
        parent.siblings('.error-msg').removeClass('hidden')
        parent.siblings('.error-msg').text('Required.')
      else
        _this.siblings('.error-msg').removeClass('hidden')
        _this.siblings('.error-msg').text('Required.')
        _this.parent().addClass('field_with_errors')

      flag = 1

      if element_with_error == undefined
        element_with_error = _this
        
    else
      if (parent.hasClass("input-group"))
        _this.text(value)
        parent.siblings('.error-msg').addClass('hidden')
      else
        if !(_this.hasClass('chosen-select'))
          _this.val(value)
          _this.siblings('.error-msg').addClass('hidden')
          _this.parent().removeClass('field_with_errors')
    
    return

  if flag == 1
    if element_with_error != undefined
      $('html, body').animate { scrollTop: $(element_with_error).first().offset().top - 81 }, 500
    return false
  else
    return true
    
@is_higher = (class_name) ->
  $this = $(class_name)
  flag = 0

  $this.each ->
    value = parseFloat($(this).val())
    tagName = $(this).prop('tagName')
    parentClass = $(this).parent().attr('class')
    regular_price = parseFloat($(this).parents('tr.nested-fields').find('.regular-price').val())
    if (regular_price < value ) && tagName != 'DIV'

      if (parentClass == "input-group")
        $("."+parentClass).siblings('.error-msg').removeClass('hidden')
        $("."+parentClass).siblings('.error-msg').text('Not Valid.')
      else
        $(this).siblings('.error-msg').removeClass('hidden')
        $(this).siblings('.error-msg').text('Not Valid.')

      flag = 1
    else
      $(this).val(value)
      $(this).siblings('.error-msg').addClass('hidden')

  if flag == 1
    return false
  else
    return true

@is_higher2 = (class_name) ->
  $this = $(class_name)
  flag = 0

  $this.each ->
    value = parseFloat($(this).val())
    tagName = $(this).prop('tagName')
    parentClass = $(this).parent().attr('class')
    total_stocks = parseFloat($(this).parents('tr.nested-fields').find('.total-stocks').val())
    action_id = parseInt($(this).parents('tr.nested-fields').find('#action-id').val())
    if (total_stocks < value && action_id == 2) && tagName != 'DIV'

      $(this).siblings('.error-msg').removeClass('hidden')
      $(this).siblings('.error-msg').text('Not Valid.')

      flag = 1
    else
      $(this).val value
      $(this).siblings('.error-msg').addClass('hidden')

  if flag == 1
    return false
  else
    return true

@is_the_same = (value1, value2) ->
  if value1.trim() == value2.trim()
    return 1
  else
    return 0

@check_length = (value, length)->
  if value.trim().length < 6
    return 0
  else
    return 1

@is_email_valid = (class_name) ->
  $this = $(class_name)
  flag = 0
  re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

  $this.each ->
    email = $(this).val().trim()

    if re.test email
      $(this).siblings('.error-msg').addClass('hidden')
    else
      $(this).siblings('.error-msg').removeClass('hidden')
      $(this).siblings('.error-msg').text('Invalid Email.')
      flag = 1

  if flag == 1
    $('html, body').animate { scrollTop: $this.first().offset().top - 81 }, 500
    return false
  else
    return true

@is_form_email_field_valid = (class_name, containing_form) ->
  $this = containing_form.find(class_name)
  flag = 0
  re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

  $this.each ->
    email = $(this).val().trim()

    if re.test email
      $(this).siblings('.error-msg').addClass('hidden')
    else
      $(this).siblings('.error-msg').removeClass('hidden')
      $(this).siblings('.error-msg').text('Invalid Email.')
      flag = 1

  if flag == 1
    return false
  else
    return true
    
@is_password_correct=(class_name,limit)->
  $('.error-class').html("")

  if $(class_name).length < 0
    return true
  else if $(class_name).eq(0).val().trim() == "" &&  $(class_name).eq(1).val().trim() == ""
    return true
  if $(class_name).eq(0).val().trim().length < limit || $(class_name).eq(1).val().trim().length < limit
    $(class_name).addClass('error')
    $('.alert-danger').removeClass("hidden")
    $('.error-class').append("Password must be more than 8 characters");
    return false   
  else if $(class_name).eq(0).val().trim() == $(class_name).eq(1).val().trim()
    $(class_name).removeClass('error')
    return true
  else
    $(class_name).addClass('error')
    $('.alert-danger').removeClass("hidden");
    $('.error-class').append("Password did not match");
    return false


@has_illegal_character=(class_name)->
  illegal_chars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?"; 
  $this = $(class_name)
  flag = 0

  $this.each ->
    value = $(this).val().trim()

    if  /[^A-Za-z\d]/.test(value) == true
      $(this).addClass("error")
      flag = 1
    else
      $(this).val value
      $(this).removeClass("error")

  if flag == 1
    return true
  else
    return false

escapeHtml = (text) ->
  text.replace(/&/g, "&amp;").
  replace(/</g, "&lt;").
  replace(/>/g, "&gt;").
  replace(/"/g, "&quot;").
  replace(/'/g, "&#039;").
  replace(/\./g, "")
