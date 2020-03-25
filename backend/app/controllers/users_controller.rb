class UsersController < ApplicationController

    def index 
        if params[:search]
            if params[:parameterSelect] == "name"
                @users = User.where(["name LIKE ?", "%#{params[:search]}%"])
            elsif params[:parameterSelect] == "skill"
                user_skills = Skill.all.where(["name LIKE ?", "%#{params[:search]}%"]).map {|skill| skill.user_skills}.flatten
                use_users = user_skills.select {|user_skill| user_skill.has_skill}
                users_ids = use_users.map {|use_user| use_user.user_id}
                @users = User.where(["id IN (?)", users_ids])
            elsif params[:parameterSelect] == "desiredSkill"
                user_skills = Skill.all.where(["name LIKE ?", "%#{params[:search]}%"]).map {|skill| skill.user_skills}.flatten
                use_users = user_skills.select {|user_skill| !user_skill.has_skill}
                users_ids = use_users.map {|use_user| use_user.user_id}
                @users = User.where(["id IN (?)", users_ids])
            else  
                @users = User.all 
            end
        else 
            @users = User.all 
        end

        render json: @users, include: [:skills, :user_skills]
    end 

    def show
        @user = User.find_by(email: params[:email])
        render json: @user, include: [:skills, :user_skills]
    end 

    def create 
        email = params[:email]
        User.create name: params[:name], email: email, password: params[:password], zip: params[:zip], bio: params[:bio], image_url: params[:image_url]

        redirect_to "http://localhost:3000/myProfile.html?email=#{email}"
    end 

    def update 
        @user = User.find_by(email: params[:email])

        user.update name: params[:name], email: params[:email], password: params[:password], zip: params[:zip], bio: params[:bio], image_url: params[:image_url]
        redirect_to "http://localhost:3000/index.html"
    end 

    def destroy
        @user = User.find_by(id: params[:id])
        @user.destroy

        redirect_to "http://localhost:3000/index.html"
    end 
    
end
