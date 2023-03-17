Rails.application.routes.draw do

  # Landing page
  root to: 'site/home#index'

  # Devise routes
  devise_for :users,
    path: '',
    controllers: {
      sessions:      'admin/sessions',
      registrations: 'admin/registrations'
    },
    path_names: {
      sign_in:      '/admin/login',
      password:     '/admin/forgot',
      confirmation: '/admin/confirm',
      unlock:       '/admin/unblock',
      registration: '/admin/register',
      sign_up:      '/admin/new',
      sign_out:     '/admin/logout'
    }

  devise_for :customers,
    path: '',
    controllers: {
      sessions:      'site/sessions',
      registrations: 'site/registrations',
      passwords:     'site/passwords'
    },
    path_names: {
      sign_in:      '/login',
      password:     '/customer/forgot',
      confirmation: '/customer/confirm',
      unlock:       '/customer/unblock',
      registration: 'register',
      sign_up:      '/login',
      sign_out:     '/customer/logout'
    }

  as :user do
    delete 'admin/logout', to: 'admin/sessions#destroy'
  end

  as :customer do
    resource :my_account,     module: 'site', path: 'my-account'

    get    'order-history',   to: 'site/my_accounts#order_history'
    get    'register',        to: 'site/registrations#new'
    get    'login',           to: 'site/sessions#new'
    delete 'customer/logout', to: 'site/sessions#destroy'
  end
  # End Devise routes

  # Site routes
  namespace :site do
    resource :cart_items
    resource :messages
    resources :orders
    resource :product_reviews
    resource :newsletter_subscribers

    # Data retrieval through AJAX.
    scope '/json' do
      post 'filter_skus',  to: 'filter_skus#filter_skus'
      post 'shipping-fee', to: 'checkout#update_shipping'
      post 'retrieve_cities', to: 'cities#retrieve_cities'
    end
  end

  # Paynamics routes.
  scope '/paynamics/notification' do
    post 'sales', to: 'site/paynamics_responses#paynamics_sales_response'
  end

  get 'brands/:slug',         to: 'site/brands#show'
  get 'cart',                 to: 'site/cart#show'
  get 'checkout',             to: 'site/checkout#index'
  get 'checkout/payment',     to: 'site/checkout#payment'
  get 'company-details',      to: 'site/company_details#index'
  get 'contact-us',           to: 'site/contact_us#index'
  get 'faqs',                 to: 'site/faqs#index'
  get 'privacy-policy',       to: 'site/privacy_policy#index'
  get 'search',               to: 'site/search#index'
  get 'shipping',             to: 'site/shipping_details#index'
  get 'shop',                 to: 'site/shop#index'
  get 'shop/:slug',           to: 'site/shop#show'
  get 'terms-and-conditions', to: 'site/terms#index'
  # get 'vpc-checkout',         to: 'site/checkout#vpc_checkout'
  get 'paynamics-checkout',   to: 'site/checkout#paynamics_checkout'
  get 'verify-paynamics',     to: 'site/payments#paynamics_verification' 
  get 'thank-you',            to: 'site/payments#thank_you'
  
  # Mockup routes
  get 'mockups/cookie-policy', to: 'site/mockups#cookie_policy'
  # End mockup routes

  # End Site routes

  # Admin routes
  namespace :admin do
    # Redirect /admin to the dashboard page.
    root to: redirect('admin/dashboard')

    resources :advertisements
    resources :audittrails
    resources :brands
    resources :careers
    resources :dashboard
    resources :categories
    resources :faqs
    resources :inventories
    resources :messages
    resources :orders
    resources :profile
    resources :products
    resources :roles
    resources :subcategories
    resources :terms
    resources :users
    resources :product_reviews,       path: 'product-reviews' 
    resources :company_details,       path: 'company-details'
    resources :order_statuses,        path: 'order-statuses'
    resources :privacy_policies,      path: 'privacy-policy'
    resources :shipping_rates,        path: 'shipping-rates'
    resources :price_updates,         path: 'price-updates' do
      post 'get_sku_price', on: :collection
    end
    resources :dhl_shipper_accounts, path: 'dhl-shipper-settings'
    resources :dhl_products,         path: 'dhl-products'
    resources :dhl_package_types,    path: 'dhl-package-types'
    resources :sliders do
      post 'update_slider_status', on: :collection
    end
    resources :photos do
      collection do
        get 'load_more_photos'
        get 'refresh_photos_list'
      end
    end

    # Maintenance routes.
    scope '/maintenance' do
      resources :uom_labels, path: 'uom-labels'
      resources :uoms
    end

    # Data retrieval through AJAX.
    scope '/json' do
      post 'retrieve_sub_categories',   to: 'products#retrieve_sub_categories'
      post 'retrieve_order_details',    to: 'orders#retrieve_order_details'
      post 'retrieve_dhl_status',       to: 'dhl#tracking'
    end
    
    scope '/dhl' do
      post 'validate-shipment/:order_request_id', to: 'dhl#validate_shipment'
      post 'book-pickup/:order_request_id',       to: 'dhl#book_pickup'
      post 'modify-pickup/:order_request_id',     to: 'dhl#modify_pickup'
      post 'cancel-pickup/:order_request_id',     to: 'dhl#cancel_pickup'
      get  'label-image/:order_request_id',       to: 'dhl#label_image'
    end

    # DataTable retrieval routes.
    scope '/datatables' do
      post 'retrieve_advertisements',       to: 'advertisements#populate_datatables'
      post 'retrieve_audittrails',          to: 'audittrails#populate_datatables'
      post 'retrieve_brands',               to: 'brands#populate_datatables'
      post 'retrieve_careers',              to: 'careers#populate_datatables'
      post 'retrieve_categories',           to: 'categories#populate_datatables'
      post 'retrieve_faqs',                 to: 'faqs#populate_datatables'
      post 'retrieve_inventories',          to: 'inventories#populate_datatables'
      post 'retrieve_show_inventories',     to: 'inventories#populate_show_datatables'
      post 'retrieve_messages',             to: 'messages#populate_datatables'
      post 'retrieve_orders',               to: 'orders#populate_datatables'
      post 'retrieve_order_statuses',       to: 'order_statuses#populate_datatables'
      post 'retrieve_products',             to: 'products#populate_datatables'
      post 'retrieve_reviews',              to: 'product_reviews#populate_datatables'
      post 'retrieve_product_reviews',      to: 'product_reviews#populate_review_datatables'
      post 'retrieve_roles',                to: 'roles#populate_datatables'
      post 'retrieve_subcategories',        to: 'subcategories#populate_datatables'
      post 'retrieve_uom_labels',           to: 'uom_labels#populate_datatables'
      post 'retrieve_uoms',                 to: 'uoms#populate_datatables'
      post 'retrieve_users',                to: 'users#populate_datatables'
      post 'retreive_price_list',           to: 'price_updates#populate_datatables'
      post 'retreive_price_history',        to: 'price_updates#populate_history_datatables'
      post 'retreive_shipping_rates',       to: 'shipping_rates#populate_datatables'
      post 'retrieve_dhl_products',         to: 'dhl_products#populate_datatables'
      post 'retrieve_dhl_package_types',    to: 'dhl_package_types#populate_datatables'
    end
  end
  # End Admin routes
end
