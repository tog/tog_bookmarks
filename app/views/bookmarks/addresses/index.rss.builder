xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("[MyFamilypedia] Mejores enlaces")
    xml.link addresses_index_url() 
    xml.description("Los "+@addresses.size.to_s+" enlace más compartidos")
    xml.language('es-es')
      for a in @addresses    
	        xml.item do
	          xml.title(a.title + " (" + a.links_count.to_s + ")")
	          xml.description(a.description)      
	          xml.pubDate(a.publish_date.strftime("%a, %d %b %Y %H:%M:%S %z"))
	          xml.author(a.author.name)  
	          xml.link(address_show_url(a))               
	          xml.guid(a.id)
	        end
      end
  }
}
