describe InterviewAssignment do
  it { should belong_to :student }
  it { should belong_to :internship }
  it { should belong_to :course }
  it { should validate_presence_of(:student) }
  it { should validate_presence_of(:internship) }
  it { should validate_presence_of(:course) }
  it { should validate_uniqueness_of(:internship_id).scoped_to(:student_id) }

  describe '#order_by_internship_name' do
    let(:internship) { FactoryBot.create(:internship, name: 'z labs') }
    let(:internship_2) { FactoryBot.create(:internship, name: 'a labs') }
    let(:student) { FactoryBot.create(:student) }
    let(:interview_assignment) { FactoryBot.create(:interview_assignment, student_id: student.id, internship_id: internship.id) }
    let(:interview_assignment_2) { FactoryBot.create(:interview_assignment, student_id: student.id, internship_id: internship_2.id) }

    it "returns a student's interview assignments ordered by internship name" do
      expect(student.interview_assignments.order_by_internship_name).to eq [interview_assignment_2, interview_assignment]
    end
  end

  describe '#for_course' do
    let(:course) { FactoryBot.create(:course) }
    let(:interview_assignment_for_course) { FactoryBot.create(:interview_assignment, course_id: course.id) }
    let(:interview_assignment_not_for_course) { FactoryBot.create(:interview_assignment) }

    it 'returns the interview assignments for a particular course' do
      expect(InterviewAssignment.for_course(course)).to eq [interview_assignment_for_course]
    end
  end

  describe '#for_internship' do
    let(:internship) { FactoryBot.create(:internship) }
    let(:interview_assignment_with_high_company_ranking) { FactoryBot.create(:interview_assignment, internship_id: internship.id, ranking_from_company: 1) }
    let(:interview_assignment_with_low_company_ranking) { FactoryBot.create(:interview_assignment, internship_id: internship.id, ranking_from_company: 2) }

    it 'returns the interview assignments for a particular internship ordered by company ranking' do
      expect(InterviewAssignment.for_internship(internship)).to eq [interview_assignment_with_high_company_ranking, interview_assignment_with_low_company_ranking]
    end
  end

  describe '#with_feedback_from_company' do
    let(:interview_assignment_with_feedback_from_company) { FactoryBot.create(:interview_assignment, ranking_from_company: 1, feedback_from_company: 'Great fit!') }
    let(:interview_assignment_without_feedback_from_company) { FactoryBot.create(:interview_assignment) }

    it 'returns the interview assignments for a particular internship ordered by company ranking' do
      expect(InterviewAssignment.with_feedback_from_company).to eq [interview_assignment_with_feedback_from_company]
    end
  end
end
