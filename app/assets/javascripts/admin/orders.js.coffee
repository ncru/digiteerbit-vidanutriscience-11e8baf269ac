# Add event listener for opening and closing details
$(document).on 'click', '.accordionTitle', (event) ->
  event.preventDefault()
  $this = $(this)
  tr = $this.closest('tr')
  row = $('table.display').DataTable().row(tr)

  if row.child.isShown()
    # This row is already open - close it
    $('div.datatable-slider', row.child()).slideUp ->
      row.child.hide()
      tr.removeClass 'shown'
      return
    $this.removeClass 'is-expanded'
  else
    # Open this row
    $.ajax
      url: '/admin/json/retrieve_order_details'
      type: 'POST'
      data: 'request_id': row.data().request_id
      success: (order) ->
        shipping_address = ""
        item_count = order.order_items.length
        identifier = if item_count > 1 then 'items' else 'item'
        shipping_address = order.shipping_address

        html = '<div class="datatable-slider">
                  <div class="customer-details-wrapper-sm pl0 col-lg-6 col-md-6 col-sm-6 col-xs-6">
                    <div class="content-sub-header">
                      <div><h1 class="text-uppercase">Customer Information</h1></div>
                    </div>
                    <div>
                      <div>
                        <ul class="profile" style="line-height: 0">
                          <li>
                            <h2>'+order.customer.first_name+' '+order.customer.last_name+'</h2>
                            <span class="info">
                              <em>
                                <i class="an an-mail"></i>
                                <strong>'+(if order.customer.email == null then "N/A" else order.customer.email)+'
                                </strong>
                              </em>
                              <em>
                                <i class="an an-iphone-portrait"></i>
                                <strong>'+order.data.mobile+'</strong>
                              </em>
                            </span>
                          </li>
                        </ul>
                      </div>
                    </div>
                    <div class="content-sub-header">
                      <div><h1 class="text-uppercase">Recipient Information</h1></div>
                    </div>
                    <div>
                      <div>
                        <ul class="profile" style="line-height: 0">
                          <li>
                            <h2>'+order.data.first_name+' '+order.data.last_name+'</h2>
                            <span class="info">
                              <em>
                                Shipping Address:
                                <strong>
                                  '+shipping_address+'
                                </strong>
                              </em>
                            </span>
                          </li>
                        </ul>
                      </div>
                    </div>
                  </div>
                  <div class="order-details-wrapper-sm pr0 col-lg-6 col-md-6 col-sm-6 col-xs-6">
                    <div class="content-sub-header mb5">
                      <div>
                        <h1>
                          Items Purchased <strong>('+item_count + ' ' + identifier + ')</strong>
                        </h1>
                      </div>
                    </div>
                    <div>
                      <ul class="item-profile"></ul>
                    </div>
                  </div>
                  <div class="clear"></div>
                </div>'

        items = ""
        # Build the list of Items purchased.
        $.each order.order_items, (i, v) ->
          items += '<li>
                      <span class="item-profile-img" style="background-image: url(\''+v.photo_url+'\');"></span>
                      <h2>'+v.product_name+'</h2>
                      <span class="info">
                        <em>
                          SKU: 
                          <strong>'+v.sku_name+'</strong>
                        </em>
                        <em>
                          UNIT PRICE: 
                          <strong>'+v.price+'</strong>
                        </em>
                        <em>
                          QTY: 
                          <strong>'+v.quantity+'</strong>
                        </em>
                      </span>
                    </li>'

        # Append the list of items to the original html.
        html = $(html)
        html.find('ul.item-profile').append(items)

        row.child(html, 'no-padding no-hover').show()
        tr.addClass 'shown'
        $this.addClass 'is-expanded'
        $('div.datatable-slider', row.child()).slideDown()

        $('.item-profile').slimScroll
          height: '150px'
          railVisible: true
      error: (jqXHR, textStatus, errorThrown) ->
        alert('Error encountered: ' + errorThrown)
  return
