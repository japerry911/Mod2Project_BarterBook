class UserSkillsController < ApplicationController
    def create 
        UserSkill.create user: params[:user], skill: params[:skill], has_skill: params[:has_skill]
    end 

    def destroy 
        @user_skill = 
        UserSkill.destory
    end 
end
