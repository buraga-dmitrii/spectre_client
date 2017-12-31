module LoginsHelper
  def disabled?(login)
    login.next_refresh_possible_at>Time.now ? 'disabled' : ''
  end
end
