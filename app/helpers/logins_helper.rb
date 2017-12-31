module LoginsHelper
  def disabled?(login)
    return '' unless login.next_refresh_possible_at
    login.next_refresh_possible_at>Time.now ? 'disabled' : ''
  end
end
