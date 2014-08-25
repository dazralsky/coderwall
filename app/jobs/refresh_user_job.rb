class RefreshUserJob
  include Sidekiq::Worker
  sidekiq_options queue: :low

  def perform(user_id, full=false)
    return if Rails.env.test?

    user = User.find(user_id)

    return if !full && user.last_refresh_at > 3.days.ago

    begin
      user.build_facts(full)
      user.reload.check_achievements!
      user.add_skills_for_unbadgified_facts

      user.calculate_score!
    ensure
      user.touch(:last_refresh_at)
    end
  end
end
