$ ->
  $(document).on 'keyup change', '.search-input', ->
    # Get the current datatables instance.
    $('table.display').DataTable().columns(parseInt($(this).data('columntosearch'))).search(@value).draw()
    return

  $(document).on 'click', '.dropdown-selected-filter-item', (event) ->
    event.preventDefault()

    columns = $('table.display').DataTable().columns().eq(0)

    if ($(this).children('img').prop('tagName'))
      selectedItem = $(this).children('img').clone()
      title = $(this).data('search')
    else
      selectedItem = $(this).text()
      title = selectedItem

    # Get the current datatables instance.
    $('table.display').DataTable().columns(parseInt($(this).data('columntosearch'))).search($(this).data('search')).draw()

    # Set the text and title in the button for hover.
    $(this).parents('.btn-filter-wrapper').find('button > .dropdown-selected-filter').html selectedItem
    $(this).parents('.btn-filter-wrapper').find('button > .dropdown-selected-filter').attr 'title', title
    return

  $(document).on 'click', '.refresh-datatable', (event) ->
    event.preventDefault()

    # Get the current datatables instance and redraw the table using the current filters.
    $('table.display').DataTable().draw()
    return

  $(document).on 'click', '.edit-inventory', (event) ->
    event.preventDefault()

    updated_value = $(this).parents('td').siblings('.update-stocks').find('input.form-control').val()
    product_id = $(this).data('id')

    $.ajax
      url: '/admin/inventories/update_stocks'
      type: 'POST'
      data: "updated_value": updated_value, "product_id": product_id
      success: (data) ->
        $('table.display').DataTable().draw()
        return
      error: (jqXHR, textStatus, errorThrown) ->
        return
    return

  $(document).on 'change', '.switchery-btn', (event) ->
    event.preventDefault()
    _this = $(this)
    if _this.is(":checked")
      _this.siblings('input.switchery-status').val(1)
    else
      _this.siblings('input.switchery-status').val(0)
    _this.parent('form').eq(0).submit()
    return
  
  $(document).on 'change', '.table-js-switch', ->
    $this = $(this)
    if $this.is(':checked') then $this.siblings('input.status').val(1) else $this.siblings('input.status').val(0)
    $this.parent('form').eq(0).submit()
    return
    
###################################################################################################
# This function is responsible for the generation of a datatable instance given the required
# parameters. This is declared as a global method for it to be called inside HTML files javascript
# sections.
# @tableId = Table ID.
# @ajaxUrl = The AJAX Url containing the source of the datatable in JSON format.
# @columnDefs = The specific columns definitions per table.
# @defaultOrder = The column to order on initial load.
###################################################################################################
@generateDatatable = (tableId, ajaxUrl, columnDefs, defaultOrder) ->
  $(tableId).DataTable
    pagingType: 'full_numbers'
    processing: true
    serverSide: true
    ajax: {'url': ajaxUrl, 'type': 'POST'},
    drawCallback: (settings, json) ->
      # Call this to initialize the tooltip for the action buttons.
      $('[data-toggle="tooltip"]').tooltip()
      if tableId == '#orders-list'
        $('.to-be-checked-status').each ->
          $this = $(this)
          status_btn = $(this).find('.btn-datatable-select')
          $.ajax
            url: '/admin/json/retrieve_dhl_status'
            type: 'POST'
            data: 'order_request_id': $this.data('reference-id')
            dataType: 'json'
            success: (data) ->
              status_tooltip_title = data.tooltip_title
              dhl_status = data.dhl_status  
              
              $this.attr('data-original-title', status_tooltip_title)
              status_btn.find('.dropdown-selected-filter').text dhl_status
              status_btn.find('.status-spinner').addClass('hidden')
              status_btn.attr('disabled', data.is_disabled)
              return
            error: (jqXHR, textStatus, errorThrown) ->
              return
      
      # Call this to initialize switchery.
      # if $('.js-switch').length > 0
      #   elems = Array::slice.call(document.querySelectorAll('.js-switch'))
      #   elems.forEach (elem) ->
      #     switchery = new Switchery(elem, {secondaryColor: '#f0f1f1'})
      # Call this to initialize autonumeric.
      if $('input.numeric-zero-allowed-no-decimal').length > 0
        $('input.numeric-zero-allowed-no-decimal').autoNumeric 'init',
          aSep: ''
          mDec: ''
          lZero: 'allow'
          vMin: '0'
      # Call this to initialize switchery.
      if $('.table-js-switch').length > 0
        elems = $('.table-js-switch')
        $.each elems, (i, elem) ->
          switchery = new Switchery(elem, {secondaryColor: '#bd6363'})
      return
    fnRowCallback: (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
      $(nRow).attr('id', aData['id'])
      $(nRow).attr('data-orderlevel', aData['order_level'])
      return nRow
    columnDefs: columnDefs
    order: defaultOrder
    language:
      'processing': '<i class="fa fa-refresh fa-spin fa-2x fa-fw" aria-hidden="true"></i>'
      'zeroRecords': 'No matching records found.'
      'infoEmpty': 'No entries to show.'
      'paginate':
        'first': '<<'
        'previous': '<'
        'next': '>'
        'last': '>>'
  return

###################################################################################################
# This function is responsible for the generation of a reorderable datatable instance given the
# required parameters. This is declared as a global method for it to be called inside HTML files
# javascript sections.
# @tableId = Table ID.
# @ajaxUrl = The AJAX Url containing the source of the datatable in JSON format.
# @columnDefs = The specific columns definitions per table.
# @ajaxReorderURL = The AJAX Url call when reordering table rows.
###################################################################################################
@generateReorderableDatatable = (tableId, ajaxUrl, columnDefs, ajaxReorderURL) ->
  $(tableId).dataTable(
    pagingType: 'full_numbers'
    processing: true
    serverSide: true
    ajax: {'url': ajaxUrl, 'type': 'POST'},
    drawCallback: (settings, json) ->
      # Call this to initialize the tooltip for the action buttons.
      $('[data-toggle="tooltip"]').tooltip()
      # Call this to initialize autonumeric.
      # if $('.js-switch').length > 0
      #   elems = Array::slice.call(document.querySelectorAll('.js-switch'))
      #   elems.forEach (elem) ->
      #     switchery = new Switchery(elem, {secondaryColor: '#f0f1f1'})
      return
    fnRowCallback: (nRow, aData, iDisplayIndex, iDisplayIndexFull) ->
      $(nRow).attr('id', aData['id'])
      $(nRow).attr('data-position', aData['order_level'])
      return nRow
    columnDefs: columnDefs
    "bSort" : false
    language:
      'processing': '<i class="fa fa-refresh fa-spin fa-2x fa-fw" aria-hidden="true"></i>'
      'zeroRecords': 'No matching records found.'
      'infoEmpty': 'No entries to show.'
      'paginate':
        'first': '<<'
        'previous': '<'
        'next': '>'
        'last': '>>'
    ).rowReordering
      sURL: ajaxReorderURL
      sRequestType: 'POST'
  return
  
update_dhl_stataus = ->
  $('.to-be-checked-status').each ->
    status_btn = $(this).find('.btn-datatable-select')
    $.ajax
      url: '/admin/json/retrieve_dhl_status'
      type: 'POST'
      data: 'order_request_id': $(this).data('reference-id')
      dataType: 'json'
      success: (data) ->
        dhl_status = data.dhl_status
        status_btn.find('.dropdown-selected-filter').text dhl_status
        status_btn.find('.status-spinner').addClass('hidden')
        return
      error: (jqXHR, textStatus, errorThrown) ->
  
