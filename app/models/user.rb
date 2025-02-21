# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :todo_lists, dependent: :destroy
  has_many :todos, through: :todo_lists
  has_many :collaborations, dependent: :destroy
  has_many :collaborated_todo_lists, through: :collaborations, source: :todo_list

  def admin?
    admin
  end
end
