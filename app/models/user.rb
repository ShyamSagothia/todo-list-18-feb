# frozen_string_literal: true
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User


  has_many :todo_lists
  has_many :collaborators
  has_many :todo_lists, through: :collaborators
  validates :email, presence: true, uniqueness: true



end
