$ ->
  $(document).on 'click', '.toggle-delete-modal', (e) ->
    e.preventDefault()
    data_type = $(this).data('type')
    data_href = $(this).data('href')

    $('#'+data_type+'_delete_modal').modal('toggle')
    $('.delete-'+data_type).attr('href', data_href)
    return

  $(document).on 'click', '.toggle-delete-photoslider-modal', (e) ->
    e.preventDefault()
    data_type = $(this).data('type')
    data_parentidtodelete = $(this).data('parentid')
    photo_table_container_id = $(this).data('parent-table-id')
    reference_data_id = $(this).data('ref-id')

    $('.delete-'+data_type).attr('data-parentidtodelete', data_parentidtodelete)
    $('.delete-'+data_type).attr('data-phototablecontainerid', photo_table_container_id)
    $('.delete-'+data_type).attr('data-referenceid', reference_data_id)
    $('#'+data_type+'_delete_modal').modal('toggle')
    return

  $(document).on 'click', '.delete-photoslider', (e) ->
    e.preventDefault()
    data_type = $(this).data('type')
    data_parentidtodelete2 = $(this).attr('data-parentidtodelete')
    data_phototablecontainerid = $(this).attr('data-phototablecontainerid')
    data_referencedataid = $(this).attr('data-referenceid')

    $('#'+data_type+'_delete_modal').modal('toggle')
    if (data_referencedataid == '5')
      $('#'+data_phototablecontainerid).find('#'+data_parentidtodelete2).remove()
    else
      $('#'+data_parentidtodelete2).remove()
    return

  $(document).on 'click', '.toggle-slider-modal', (e) ->
    e.preventDefault()
    id = $(this).data('id')
    title = $(this).data('title')
    excerpt = $(this).data('excerpt')
    photo_url = $(this).data('photo_url')
    status = $(this).data('status')

    $('#slider_modal').modal('toggle')
    return
  
  # Handler for the Status change in Orders module.
  $(document).on 'click', '.toggle-status-modal', (e) ->
    e.preventDefault()    
    $this = $(this)
    order_status_id = $this.data('id')
    reference_id = $this.data('reference-id')
    current_status = $this.data('current-status')
    href = $this.data('href')
    $form = $('#order_status_modal').find('form')
    
    $('#order_status_modal').find('.reference-id').text(reference_id)
    $('#order_status_modal').find('.from-status').text(current_status)
    $('#order_status_modal').find('.to-status').text($this.text())
    $form.attr('action', href)
    $form.find('#order_status_id').val(order_status_id)
    $('#order_status_modal').modal('toggle')
    return
  
  # Handler for the DHL Status change in Orders module.
  $(document).on 'click', '.toggle-dhl-status-modal', (e) ->
    e.preventDefault()    
    $this = $(this)
    dhl_service_id = $this.data('service-id')
    reference_id = $this.data('reference-id')
    current_status = $this.data('current-status')
    href = $this.data('href')
    modal = $('#dhl-'+$this.data('type')+'-modal')
    $form = modal.find('form')
    
    modal.find('.reference-id').text(reference_id)
    modal.find('.from-status').text(current_status)
    $form.attr('action', href)
    $form.find('.dhl_service_id').val(dhl_service_id)
    modal.modal('toggle')
    return
  # For DHL status update submission
  $(document).on 'click', '.submit-dhl-modal-btn', (e) ->
    e.preventDefault()
    $this = $(this)
    $this.find('i').removeClass('hidden')
    $form = $this.closest('form')

    if is_not_blank($form.find('.required'))
      $form.submit()
    return 
