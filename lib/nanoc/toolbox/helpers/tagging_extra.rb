module Nanoc::Toolbox::Helpers

  # NANOC Helper for added tagging functions
  #
  # This module contains functions for ...
  #
  # @see http://groups.google.com/group/nanoc/browse_thread/thread/caefcab791fd3c4b
  module TaggingExtra
    include Nanoc::Helpers::Blogging

    # Returns all the tags present in a collection of items. The tags are 
    # only present once in the returned value. When called whithout 
    # parameters, all the site items are considered.
    #
    # @param [Array<Nanoc::Item>] items
    # @return [Array<String>] An array of tags
    def tag_set(items=nil) 
      items ||= @items
      items.map { |i| i[:tags] }.flatten.uniq.delete_if{|t| t.nil?}
    end

    # Return true if an item has a specified tag
    #
    # @param [Nanoc::Item] item
    # @param [String] tag
    # @return [Boolean] true if the item contains the specified tag
    def has_tag?(item, tag)
      return false if item[:tags].nil?
      item[:tags].include? tag
    end

    # Finds all the items having a specified tag. By default the method search 
    # in all the site items. Alternatively, an item collection can be passed as 
    # second (optional) parameter, to restrict the search in the collection.
    #
    # @param [Array<Nanoc::Item>] items
    # @param [String] tag
    # @param [Nanoc::Item] item
    def items_with_tag(tag, items=nil)
      items = sorted_articles if items.nil?
      items.select { |item| has_tag?( item, tag ) }
    end
  
    # Count the tags in a given collection of items. By default, the method 
    # counts tags in all the site items. The result is an hash such as: 
    # { tag => count }.
    #
    # @param [Array<Nanoc::Item>] items
    # @return [Hash] Hash indexed by tag name with the occurences as value
    def count_tags(items=nil)
      items ||= @items
      tags = items.map { |i| i[:tags] }.flatten.delete_if{|t| t.nil?}
      tags.inject(Hash.new(0)) {|h,i| h[i] += 1; h }
    end

    # Sort the tags of an item collection (defaults to all site items) in 'n' 
    # classes of rank. The rank 0 corresponds to the most frequent tags. 
    # The rank 'n-1' to the least frequents. The result is a hash such as: 
    # { tag => rank }
    #
    # @param [Integer] n number of rank
    # @param [Array<Nanoc::Item>] items
    def rank_tags(n, items=nil) 
      items = @items if items.nil?
      count = count_tags( items )

      max, min = 0, items.size
      count.keys.each do |t|
        max = count[t] if count[t] > max
        min = count[t] if count[t] < min
      end    
      divisor = ( ( max.to_f - min )  / n )    

      ranks = {}
      count.keys.each do |t|
        rank = n - 1 -  ( count[t] - min ) / divisor
        rank = 0 if rank < 0
        ranks[t] = rank.to_i
      end

      ranks
    end
  
    # Creates in-memory tag pages from partial: layouts/section.haml
    def create_tag_pages
      tag_set(items).each do |tag|
        items << Nanoc3::Item.new(
          "= render('section', :tag => '#{tag}')",      # use locals to pass data
          {:title => "#{tag}"},
          "/#{tag.downcase}/",                          # identifier
          :binary => false
        )
      end
    end
  end
end
