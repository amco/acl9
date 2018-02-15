Dummy::Application.routes.draw do
  resources :acl_arguments

  resources :acl_action_overrides do
    collection do
      get 'check_allow'
      get 'check_allow_with_foo'
    end
  end

  resources :acl_blocks

  resources :acl_boolean_methods

  resources :acl_helper_methods do
    collection do
      get 'allow'
    end
  end

  resources :acl_ivars, as: 'acl_ivar'

  resources :acl_methods
  resources :acl_method2s, as: 'acl_method2s'

  resources :acl_objects_hashes do
    collection do
      get 'allow'
    end
  end

  resources :acl_subject_methods
end
