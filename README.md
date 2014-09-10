[![Build Status](https://travis-ci.org/MichaelSp/smarter_listing.svg?branch=master)](https://travis-ci.org/MichaelSp/smarter_listing)

SmarterListing
================

The [smart listing](http://showcase.sology.eu/smart_listing) from the guys at Sology is a real productivity boost.
But it's too verbose to include it into your rails app. This gem makes smart listing even smarter. It drys your controller out.

Usage
-----

* Gemfile
  ```ruby
  gem 'smarter_listing'
  ```
then `bundle install`

* app/controllers/posts_controller.rb
  ```ruby
  class PostController < ApplicationController
    smarter_listing
    
    # Look ma, no controller actions needs to be defined
    
    private
      def resource_params
          params.require(:post).permit(:title, :body) if params[:post]
      end
  end
  ```

* app/views/posts/_form.html.haml
  ```ruby
  = bootstrap_form_for @post # this requires the fine gem 'bootstrap_form'. Check it out! 
    = f.text_field :title
    = f.text_area :body
    .pull-right
      = f.primary
      = link_to 'Cancel'. posts_path, class: 'btn btn-default'
  ```

* app/views/posts/_post.html.haml
  ```ruby
  %td= object.title.truncate(30)
  %td= object.body.truncate(80)
  %td.actions= smart_listing_item_actions [action_copy(object,copy_post_path(object)),action_edit(object,edit_post_path(object)),action_destroy(object,post_path(object))]
  ```

* app/views/posts/_table_header.html.haml
  ```ruby
  %table.table.table-striped
    %tr
      %th= smart_listing.sortable t("Created"), :created_at
      %th= smart_listing.sortable t("Title"), :title
      %th= smart_listing.sortable t("Body"), :body
      %th
    - smart_listing.collection.each do |post|
      %tr.editable{data: {id: post.id}}
        = smart_listing.render partial: 'posts/post', locals: {object: post}
  
    = smart_listing.item_new colspan: 11, link: new_post_path
  
  = smart_listing.paginate
  = smart_listing.pagination_per_page_links
  ```

* app/views/posts/index.html.haml
  ```ruby
  = smart_listing_controls_for(:posts, {class: "form-inline text-right"}) do
    .form-group.filter.input-append
      = text_field_tag :filter, '', class: "search form-control", placeholder: t("Search..."), autocomplete: :off
  
    %button.btn.btn-primary.disabled{type: :submit}
      =fa_icon 'search' # this requires gem 'font-awesome-rails'
  =smart_listing_render(:posts)
  
  ```