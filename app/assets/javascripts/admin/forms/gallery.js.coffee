$ ->
  featured_product_url = $('.featured_product')
  texteditor = $('.note-editable')
  
  # Catch the closing event of the Gallery modal.
  $('#gallery_modal').on 'hidden.bs.modal', (e) ->
    button = $('.open_gallery').removeClass('active_gallery')
    return

  $(document).on 'click', '.photo', (e) ->
    e.preventDefault()
    $this = $(this)

    if ($('.insert-img').attr('data-type') == 'multiple')
      if $this.hasClass('chosen')
        $this.removeClass('chosen')
      else
        $this.addClass('chosen')
    else
      if $this.hasClass('chosen')
        $this.removeClass('chosen')
      else
        # For single photo selection only.
        $('.chosen').removeClass('chosen')
        $this.addClass('chosen')

    if ($('.insert-img').hasClass('disabled'))
      $('.insert-img').removeClass('disabled')
    return

  $(document).on 'click', '#load_more_btn', (e) ->
    e.preventDefault()
    page_count = $('#page_count')
    count = parseInt(page_count.val()) + 1
    page_count.val(count)
    $(this).addClass('disabled')
    $(this).find('span').html('Loading...')
    $('#load_more_form').submit()
    return

  $(document).on 'click', '.open_gallery', (e) ->
    e.preventDefault()
    button = $(this)
    data_id = button.data('id')
    element_id = button.data('element-id')

    button.addClass('active_gallery')

    if (data_id == 5)
      sku_id = button.parents('.nested-fields').data('sku-id')
      identifier = button.parents('.nested-fields').find('.form-control').first().attr('id')
      from = identifier.indexOf("_attributes_")+12
      to = identifier.indexOf("_code")

      if (sku_id == '') then sku_id = 0

      $('.insert-img').attr('data-sku-id', sku_id).attr('data-identifier', identifier.substring(from, to))

    $('.insert-img').attr('data-id', data_id).attr('data-element-id', element_id)
    $('#gallery_modal').modal('show')
    return

  $(document).on 'click', '.insert-img', (e) ->
    e.preventDefault()
    $this = $(this)

    $('.chosen').each (index, item) ->
      url = $(item).attr('data-id').replace(/\s+/g, '%20')
      data_id = $this.attr('data-id')
      element_id = $this.attr('data-element-id')

      if data_id == '1'
        if element_id == undefined || element_id == ''
          $('.thumbnail_url').val(url)
        else
          $('#'+element_id).val(url)
      else if data_id == '2'
        texteditor.append('<img src="' + url + '"/>')
      else if data_id == '3'
        td_input = '<input class="hidden" name="post_photos[]" value="'+url+'"/>'
        td_image = '<td><img src="'+url+'" class="thumbnail"/>'+td_input+'</td>'
        td_url = '<td>'+url+'</td>'
        td_remove = '<td class="action-s"><a class="btn btn-danger remove-photo" data-id="'+url+'">x</a></td>'
        $('.photo-tbody').prepend('<tr>'+td_image+td_url+td_remove+'</tr>')
      else if data_id == '4'
        id_to_assign = parseInt($('.photo-table').find('.col-md-4:last-child').attr('id'))+1
        input_tag = '<input class="hidden" name="post_photos[]" value="'+url+'"/>'
        remove_btn = '<a class="btn btn-success btn-remove-sm toggle-delete-photoslider-modal" data-type="photoslider" data-parentid="'+id_to_assign+'"><i class="an-cross-thin mr0"></i></a>'
        $('.photo-table').append(input_tag+'<div class="col-md-4" id="'+id_to_assign+'"><img class="thumbnail img-responsive" src="'+url+'"/>'+remove_btn+'</div>')
      else if data_id == '5'
        sku_id = $this.attr('data-sku-id')
        identifier = $this.attr('data-identifier')
        photo_table_id = if (sku_id == "0") then 'photo-table-'+identifier else 'photo-table-'+sku_id
        id_to_assign = parseInt($("#"+photo_table_id).find('.col-md-2:last-child').attr('id'))+1
        input_tag = '<input class="hidden" name="product[skus_attributes]['+identifier+'][photos][]" value="'+url+'"/>'

        if (isNaN(id_to_assign))
          id_to_assign = 0

        remove_btn = '<a class="btn btn-success btn-remove-sm toggle-delete-photoslider-modal" data-type="photoslider" data-parentid="'+id_to_assign+'" data-parent-table-id="'+photo_table_id+'" data-ref-id="'+data_id+'"><i class="an-cross-thin mr0"></i></a>'

        $("#"+photo_table_id).append('<div class="col-md-2" id="'+id_to_assign+'">'+input_tag+'<img class="thumbnail thumbnail-sm img-responsive" src="'+url+'"/>'+remove_btn+'</div>')
      else if data_id == '6'
        $('.mobile_thumbnail_url').val(url)

    $('#gallery_modal').modal('hide')
    return

  $(document).on 'click', '.remove-photo', (e) ->
    e.preventDefault()
    $this = $(this)
    $this.parents().eq(1).remove()
    return

  $('#gallery_modal').on 'hidden.bs.modal', (e) ->
    # Remove all the tagged chosen images.
    $('.photo.chosen').removeClass('chosen')
    # Disable the Add button.
    $('.insert-img').addClass('disabled')
    return
