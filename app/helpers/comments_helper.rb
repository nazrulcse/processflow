module CommentsHelper

  def comments_replies(comment)
    html=''
    if comment
      html = "<li>#{render :partial => 'shared/comments_item', :locals => {:comment => comment}} </li>"
      if comment.replies
        for reply in comment.replies
          html << "<ul style='padding-left: 10px;'>"
          html << comments_replies(reply)
          html << "</ul>"
        end
      end
    end
    return html.html_safe
  end

end
