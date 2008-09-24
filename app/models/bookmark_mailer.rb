class LinkMailer < TogMailer
  
  def admin_authorization(link, user, moderator, group)
    setup_email(user.email, moderator.email)
    @subject    += ' Link sugerido para la comunidad ' + group.name
    @body[:url]  = groups_pending_links_url(group)
    @body[:user] = user  
    @body[:link] = link 
    @body[:group] = group  
    @body[:moderator] = moderator
    
    message = Message.new(
      :from     => user,
      :to       => moderator,
      :subject  => 'Link sugerido para la comunidad ' + group.name,
      :content  => 'Hola '+moderator.name+'! El usuario de Myfamilypedia, <a href="'+profiles_show_url(user.profile)+'">'+ user.name + '</a>, ha sugerido la siguiente web:'+
           '<a target="_blank" href="'+link.url.url+'">'+link.url.url+ '</a> (compartida ' + link.url.links_count.to_s + ' veces) ' + 
           'para la comunidad ' + group.name + '<br/><br/>' +
           'Para decidir aceptarla o no, pulsa aquí:'+
           '<a href="' + @body[:url] + '">' + @body[:url] + '</a><br/><br/>' +
           '<a href="'+groups_accept_link_path(group, link)+'">Aceptar</a>&nbsp;' +
           '<a href="'+groups_reject_link_path(group, link)+'">Rechazar</a>'
    )
    message.dispatch!        
  end
  
  def father_authorization(link, user, father)

    setup_email(user.email, father.email)
    @subject    += ' Link pendiente de aprobación para el usuario ' + user.login
    @body[:user] = user  
    @body[:link] = link 
      
    message = Message.new(
      :from     => user,
      :to       => father,
      :subject  => ' Link pendiente de aprobación para el usuario ' + user.login,
      :content  => 'El menor ' + user.name + ' quiere que le dejes ver la URL ' +
        link.url.url + ' (compartida ' + link.url.links_count.to_s + ' veces) ' +'<br/><br/><br/> ' +
        '<a href="'+ilinks_accept_link_path(link.id, user.id)+'">Aceptar</a>&nbsp;' +
        '<a href="'+ilinks_reject_link_path(link.id, user.id)+'">Rechazar</a>'
      )
      message.dispatch!
  end
    
  protected

    def setup_email(from, to)
      @recipients  = "#{to}"
      @from        = "#{from}"
      @content_type = "text/html"
      @subject     = Tog::Config["system.mail.default_subject"]
      @sent_on     = Time.now
    end    

end
