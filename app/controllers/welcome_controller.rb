class WelcomeController < ApplicationController

  def home
    @voting_round = VotingRound.last
#   render :template => 'home'
  end

end
