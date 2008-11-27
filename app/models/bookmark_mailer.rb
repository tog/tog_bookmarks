class BookmarkMailer < ActionMailer::Base
  
  def admin_authorization(link, user, moderator, group)
    setup_email(user.email, moderator.email)
    @body[:user] = user  
    @body[:link] = link 
    @body[:group] = group  
    @body[:moderator] = moderator
    
    message = Message.new(
      :from     => user,
      :to       => moderator,
      :subject  => 'Link compartido con la comunidad ' + group.name,
      :content  => 'Hola '+moderator.login+'! El usuario, <a href="'+profile_path(user.profile)+'">'+ user.login + '</a>, ha compartido la siguiente web:'+
           '<a target="_blank" href="'+link.url.url+'">'+link.url.url+ '</a>' + 
           'con la comunidad ' + group.name + '<br/>'
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
