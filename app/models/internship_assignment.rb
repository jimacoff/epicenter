class InternshipAssignment < ApplicationRecord
  belongs_to :student
  belongs_to :internship
  belongs_to :course

  validates :student, presence: true
  validates :internship, presence: true
  validates :course, presence: true
  validates :student_id, uniqueness: { scope: :course_id }

  scope :for_internship, ->(internship) { where(internship_id: internship.id) }
end
