xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title(I18n.t("tog_bookmarks.address.site.title"))
    xml.link bookmarks_addresses_url() 
    xml.description(I18n.t("tog_bookmarks.address.site.most_shared", :size=>@addresses.size.to_s))
      for a in @addresses    
          xml.item do
            xml.title(a.title + " (" + a.bookmarks.count.to_s + ")")
            xml.description(a.description)      
            xml.pubDate(a.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
            xml.author(a.user.login)  
            xml.link(bookmarks_address_url(a))               
            xml.guid(a.id)
          end
      end
  }
}
